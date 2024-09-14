--

# Grades Database Insertion Script

このスクリプトは、CSVファイルからデータを読み込み、MySQLデータベースに挿入するためのものです。

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
2. スクリプトを実行するために、CSVファイルを準備します。
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

## 注意事項

- スクリプトを実行する前に、データベースの接続情報を正しく設定してください。
- データベースに既に存在するデータに対しては、適切なエラーハンドリングを行ってください。

---
