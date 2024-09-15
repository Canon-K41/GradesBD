--

# Grades Database Insertion Script

このスクリプトは、CSVファイルからデータを読み込み、MySQLデータベースに挿入するためのものです。
成績開示にCampusmate-Jを使用している九大生を主に対象としています。
ただし必要条件と使用方法を満たしていれば、他の大学生でも使用可能です。

## 必要条件

- Python 3.x
- pandas ライブラリ
- mysql-connector-python ライブラリ
- MySQL データベース

## インストール

必要なPythonライブラリをインストールするには、以下のコマンドを実行してください。

```sh
pip install pandas mysql-connector-python
```

## 使用方法

1. MySQLデータベースを設定し、必要なテーブルを作成します。
2. スクリプトを実行するために、CSVファイルを準備します。CSVファイルのフォーマットは以下の通りです:

    | 科目名 | 分野系列名 | 単位数 | 評価 | GP | 年度 | 期間 | 成績担当者 |
    |--------|------------|--------|------|----|------|------|------------|
    | 科目1  | 分野1     | 2.0    | A    | 4  | 2021 | 前期 | 担当者1   |   
    | 科目2  | 分野2     | 1.0    | B    | 3  | 2021 | 後期 | 担当者2   |


   例:

    ```csv
    科目名,分野系列名,単位数,評価,GP,年度,期間,成績担当者
    科目1,分野1,2.0,A,4,2021,前期,担当者1
    科目2,分野2,1.0,B,3,2021,後期,担当者2
    ```
3. 以下のコマンドを実行してスクリプトを実行します。

```sh
python insert_db.py <CSVファイル名>
```

例:

```sh
python insert_db.py data.csv
```

## スクリプトの説明

- `insert_db.py` は、CSVファイルからデータを読み込み、MySQLデータベースに挿入します。
- スクリプトは以下の手順で動作します:
  1. CSVファイルを読み込みます。
  2. データベースに接続します。
  3. 必要なIDマップを取得または更新します。
  4. データをデータベースに挿入します。

## データベース構造

スクリプトは以下のテーブルを使用します:

- `fields`
- `instructors`
- `subjects`
- `grade_points`
- `grades`

各テーブルの構造は以下の通りです:

### fields

| フィールド名 | データ型 | 説明 |
|--------------|----------|------|
| field_id     | INT      | 主キー |
| field_name   | VARCHAR  | 分野名 |

### instructors

| フィールド名 | データ型 | 説明 |
|--------------|----------|------|
| instructor_id | INT      | 主キー |
| instructor_name | VARCHAR | 担当者名 |

### subjects

| フィールド名 | データ型 | 説明 |
|--------------|----------|------|
| subject_id   | INT      | 主キー |
| field_id     | INT      | 外部キー (fields.field_id) |
| subject_name | VARCHAR  | 科目名 |
| credits      | DECIMAL  | 単位数 |
| year         | INT      | 年度 |
| term         | VARCHAR  | 期間 |
| instructor_id | INT     | 外部キー (instructors.instructor_id) |

### grade_points

| フィールド名 | データ型 | 説明 |
|--------------|----------|------|
| evaluation   | CHAR     | 主キー |
| grade_point  | DECIMAL  | 成績ポイント |

### grades

| フィールド名 | データ型 | 説明 |
|--------------|----------|------|
| grade_id     | INT      | 主キー |
| subject_id   | INT      | 外部キー (subjects.subject_id) |
| evaluation   | CHAR     | 評価 |
| last_updated | TIMESTAMP| 最終更新日 |

![image1](./gradeook.png) "gradebook"

## 注意事項

- スクリプトを実行する前に、データベースの接続情報を正しく設定してください。
- データベースに既に存在するデータに対しては、適切なエラーハンドリングを行ってください。

---
