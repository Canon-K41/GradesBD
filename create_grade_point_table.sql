LOAD DATA INFILE './grade_point_table.csv' INTO TABLE grade_points
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(evaluation, grade_point);

