
DROP TABLE IF EXISTS us_companies;

-- Create the table structure
CREATE TABLE us_companies (
    Ticker VARCHAR(20),
    SimFinId INT,
    CompanyName VARCHAR(100),
    IndustryId INT,
    ISIN VARCHAR(50),
    EndOfFinancialYearMonth INT,
    NumberEmployees INT,
    BusinessSummary TEXT,
    Market VARCHAR(50),
    CIK INT,
    MainCurrency VARCHAR(50)
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\us-companies\\us-companies-text-merged.csv'
INTO TABLE us_companies
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r'
IGNORE 1 LINES
(
    Ticker,
    SimFinId,
    CompanyName,
    IndustryId,
    ISIN,
    EndOfFinancialYearMonth,
    NumberEmployees,
    BusinessSummary,
    Market,
    CIK,
    MainCurrency
);



UPDATE us_companies SET Ticker = REPLACE(REPLACE(Ticker, '\r', ''), '\n', '');
UPDATE us_companies SET Ticker = NULL WHERE Ticker = '';
UPDATE us_companies SET CompanyName = NULL WHERE CompanyName = '';
UPDATE us_companies SET IndustryId = NULL WHERE IndustryId = 0;
UPDATE us_companies SET ISIN = NULL WHERE ISIN = '';
UPDATE us_companies SET EndOfFinancialYearMonth = NULL WHERE EndOfFinancialYearMonth = 0;
UPDATE us_companies SET NumberEmployees = NULL WHERE NumberEmployees = 0;
UPDATE us_companies SET BusinessSummary = NULL WHERE BusinessSummary = '';
UPDATE us_companies SET CIK = NULL WHERE CIK = 0;
UPDATE us_companies SET MainCurrency = NULL WHERE MainCurrency = '';
