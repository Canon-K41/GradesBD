-- データベースの作成
create database gradebook;
-- 作成したデータベースを使用
use gradebook;

-- 分野テーブルの作成
create table fields (
    field_id int auto_increment primary key, -- 主キー
    field_name varchar(255) not null         -- 分野名
);

-- 担当者テーブルの作成
create table instructors (
    instructor_id int auto_increment primary key, -- 主キー
    instructor_name varchar(255) not null         -- 担当者名
);

-- 科目テーブルの作成
create table subjects (
    subject_id int auto_increment primary key, -- 主キー
    field_id int,                              -- 分野id（外部キー）
    subject_name varchar(255) not null,        -- 科目名
    credits decimal(3, 1) not null,            -- 単位数
    year int not null,                         -- 年度
    term varchar(20) not null,                -- 期間
    instructor_id int not null,                -- 担当者id（外部キー）
    foreign key (instructor_id) references instructors(instructor_id), -- 担当者テーブルへの外部キー
    foreign key (field_id) references fields(field_id)                 -- 分野テーブルへの外部キー
);

-- 成績ポイントのテーブルの作成
create table grade_points (
    evaluation char(1) primary key,   -- 評価
    grade_point decimal(3, 1) not null   -- 成績ポイント
);

-- 成績テーブルの作成
create table grades (
    grade_id int auto_increment primary key, -- 主キー
    subject_id int not null,                          -- 科目id（外部キー）
    evaluation char(1),                      -- 評価
    last_updated timestamp default current_timestamp on update current_timestamp, -- 最終更新日
    foreign key (subject_id) references subjects(subject_id), -- 科目テーブルへの外部キー
    foreign key (evaluation) references grade_points(evaluation) -- 成績ポイントテーブルへの外部キー
);
