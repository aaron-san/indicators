
DROP TABLE IF EXISTS us_balance_annual;

-- Create the table structure

CREATE TABLE us_balance_annual (
    Ticker                          VARCHAR(10)     NOT NULL,
    SimFinId                        INT             NOT NULL,
    Currency                        VARCHAR(5),
    FiscalYear                      SMALLINT        NOT NULL,
    FiscalPeriod                    VARCHAR(4)      NOT NULL,
    ReportDate                      DATE,
    PublishDate                     DATE,
    RestatedDate                    DATE,
    SharesBasic                     BIGINT,
    SharesDiluted                   BIGINT,
    CashAndEquiv                    BIGINT,
    AccountsNotesReceivable         BIGINT,
    Inventories                     BIGINT,
    TotalCurrentAssets              BIGINT,
    PropertyPlantEquipmentNet       BIGINT,
    LongTermInvestmentsReceivables  BIGINT,
    OtherLongTermAssets             BIGINT,
    TotalNoncurrentAssets           BIGINT,
    TotalAssets                     BIGINT,
    PayablesAccruals                BIGINT,
    ShortTermDebt                   BIGINT,
    TotalCurrentLiabilities         BIGINT,
    LongTermDebt                    BIGINT,
    TotalNoncurrentLiabilities      BIGINT,
    TotalLiabilities                BIGINT,
    ShareCapitalAdditionalPaidIn    BIGINT,
    TreasuryStock                   BIGINT,
    RetainedEarnings                BIGINT,
    TotalEquity                     BIGINT,
    TotalLiabilitiesEquity          BIGINT,
    PRIMARY KEY (Ticker, FiscalYear, FiscalPeriod)
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\us-balance-annual\\us-balance-annual.csv'
INTO TABLE us_balance_annual
FIELDS TERMINATED BY ';'
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- skip header row
