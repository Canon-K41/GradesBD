import pandas as pd
import sys
import mysql.connector

# コマンドライン引数からファイル名を取得
file = sys.argv[1]
df = pd.read_csv(file)
df = df.rename(columns={'分野系列名': 'field', '科目名': 'subject_name',
                        '単位': 'credit','評価': 'evaluation', 'GP':
                        'grade_point','年度':
                        'year', '期間': 'term', '評価': 'evaluation',
                        '科目ナンバリング': 'subject_number', '講義コード':
                        'subject_code',
                        '成績担当者': 'instructor', '最終更新日':
                        'last_update'})
#CSVファイルに出力
df = df.drop(['subject_number', 'subject_code', 'last_update'], axis=1)
# df.to_csv('gradebook.csv', index=False)
# exit()

# データベースに接続
try:
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='root',
        database='gradebook'
    )
except mysql.connector.Error as e:
    print(e)
    sys.exit(1)

# 指定されたテーブルからIDマップを取得する関数
def get_id_map(table_name):
    cursor = conn.cursor(dictionary=True)

    # テーブル名からフィールド名とID名を生成
    field = table_name[:-1]
    field_name = field + '_name'
    field_id = field + '_id'

    # クエリを作成して実行
    query = "SELECT " + field_id + ", " + field_name + " FROM " + table_name
    cursor.execute(query)
    rows = cursor.fetchall()

    # 結果をIDマップに変換
    id_map = {}
    for row in rows:
        id_map[row[field_name]] = row[field_id]

    # カーソルを閉じる
    cursor.close()
    
    return id_map

# テーブルのIDマップを更新する関数
def update_id_map(table_name):
    id_map = get_id_map(table_name)
    field_name = table_name[:-1] 

    # もしデータがない場合は追加
    for item in df[field_name].unique():
        if item not in id_map.keys():
            query = "INSERT INTO " + table_name + " (" + table_name[:-1] + "_name) VALUES (%s)"
            cursor = conn.cursor()
            cursor.execute(query, (item,))

            # コミットしてカーソルを閉じる
            conn.commit()
            cursor.close()

    return get_id_map(table_name)

# dfにIDを追加する関数
def add_id_to_df(table_name):
    id_map = update_id_map(table_name)
    column_name = table_name[:-1]
    df[column_name + '_id'] = df[column_name].apply(lambda x: id_map.get(x, None))

def main():
    # テーブルごとにIDを追加
    try:
        add_id_to_df('fields')
        add_id_to_df('instructors')
    except mysql.connector.Error as e:
        print(e)
        sys.exit(1)

    # df.to_csv('gradebook.csv', index=False)
    # exit()

    # データベースにデータを追加
    cursor = conn.cursor()

    # subjectsテーブルにデータを挿入
    for _, row in df.iterrows():
        query = "INSERT INTO subjects (field_id, subject_name, credits, year, term, instructor_id) VALUES (%s, %s, %s, %s, %s, %s)"
        values = (
            int(row['field_id']),
            str(row['subject_name']),
            float(row['credit']),
            int(row['year']),
            str(row['term']),
            int(row['instructor_id'])
        )
        cursor.execute(query, values)

    conn.commit()

    # gradesテーブルにデータを挿入
    for _, row in df.iterrows():
        query = """
        INSERT INTO grades (subject_id, evaluation) VALUES (
            (SELECT subject_id FROM subjects 
             WHERE subject_name = %s 
               AND year = %s
               AND term = %s 
               AND field_id = %s),
            %s
        )
        """
        values = (
            str(row['subject_name']),
            int(row['year']),
            str(row['term']),
            int(row['field_id']),
            str(row['evaluation'])
        )
        cursor.execute(query, values)

    # コミットしてカーソルを閉じる
    conn.commit()
    cursor.close()

    # データベースを閉じる
    conn.close()

if __name__ == '__main__':
    main()
