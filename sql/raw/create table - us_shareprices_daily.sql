
DROP TABLE IF EXISTS us_shareprices_daily;

-- Create the table structure

CREATE TABLE us_shareprices_daily (
    Ticker              VARCHAR(10)     NOT NULL,
    SimFinId            INT             NOT NULL,
    Date                DATE            NOT NULL,
    Open                DECIMAL(12,4),
    High                DECIMAL(12,4),
    Low                 DECIMAL(12,4),
    Close               DECIMAL(12,4),
    AdjClose            DECIMAL(12,4),
    Volume              BIGINT,
    Dividend            DECIMAL(12,6),
    SharesOutstanding   BIGINT,
    PRIMARY KEY (Ticker, Date)
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\us-shareprices-daily\\us-shareprices-daily.csv'
INTO TABLE us_shareprices_daily
FIELDS TERMINATED BY ';'
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- skip header row


CREATE INDEX idx_daily_ticker_date
ON us_shareprices_daily (Ticker, Date);