-- データベースの作成
CREATE DATABASE gradebook;
-- 作成したデータベースを使用
USE gradebook;

-- 分野テーブルの作成
CREATE TABLE fields (
    field_id INT AUTO_INCREMENT PRIMARY KEY, -- 主キー
    field_name VARCHAR(255) NOT NULL         -- 分野名
);

-- 担当者テーブルの作成
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY, -- 主キー
    instructor_name VARCHAR(255) NOT NULL         -- 担当者名
);

-- 科目テーブルの作成
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY, -- 主キー
    field_id INT,                              -- 分野id（外部キー）
    subject_name VARCHAR(255) NOT NULL,        -- 科目名
    credits DECIMAL(3, 1) NOT NULL,            -- 単位数
    year INT NOT NULL,                         -- 年度
    term VARCHAR(20) NOT NULL,                 -- 期間
    instructor_id INT NOT NULL,                -- 担当者id（外部キー）
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id), -- 担当者テーブルへの外部キー
    FOREIGN KEY (field_id) REFERENCES fields(field_id)                 -- 分野テーブルへの外部キー
);

-- 成績ポイントのテーブルの作成
CREATE TABLE grade_points (
    evaluation CHAR(1) PRIMARY KEY,   -- 評価
    grade_point DECIMAL(3, 1)         -- 成績ポイント
);

-- 成績テーブルの作成
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY, -- 主キー
    subject_id INT NOT NULL,                 -- 科目id（外部キー）
    evaluation CHAR(1),                      -- 評価
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最終更新日
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id), -- 科目テーブルへの外部キー
    FOREIGN KEY (evaluation) REFERENCES grade_points(evaluation) -- 成績ポイントテーブルへの外部キー
);
