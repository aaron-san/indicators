
DROP TABLE IF EXISTS industries;

-- Create the table structure
CREATE TABLE industries (
    IndustryId INT,
    Industry VARCHAR(100),
    Sector VARCHAR(100)
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\industries\\industries.csv'
INTO TABLE industries
FIELDS TERMINATED BY ';'
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- skip header row

UPDATE industries SET Sector = REPLACE(REPLACE(Sector, '\r', ''), '\n', '');
