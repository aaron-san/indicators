
DROP TABLE IF EXISTS us_cashflow_annual;

-- Create the table structure

CREATE TABLE us_cashflow_annual (
    Ticker                          VARCHAR(10)     NOT NULL,
    SimFinId                        INT             NOT NULL,
    Currency                        VARCHAR(10),
    FiscalYear                      SMALLINT        NOT NULL,
    FiscalPeriod                    VARCHAR(10)      NOT NULL,
    ReportDate                      DATE,
    PublishDate                     DATE,
    RestatedDate                    DATE,
    SharesBasic                     BIGINT,
    SharesDiluted                   BIGINT,
    NetIncomeStartingLine           BIGINT,
    DepreciationAmortization        BIGINT,
    NonCashItems                    BIGINT,
    ChangeInWorkingCapital          BIGINT,
    ChangeInAccountsReceivable      BIGINT,
    ChangeInInventories             BIGINT,
    ChangeInAccountsPayable         BIGINT,
    ChangeInOther                   BIGINT,
    NetCashFromOperatingActivities  BIGINT,
    ChangeInFixedAssetsIntangibles  BIGINT,
    NetChangeInLongTermInvestment   BIGINT,
    NetCashFromAcquisitionsDivest   BIGINT,
    NetCashFromInvestingActivities  BIGINT,
    DividendsPaid                   BIGINT,
    CashFromRepaymentOfDebt         BIGINT,
    CashFromRepurchaseOfEquity      BIGINT,
    NetCashFromFinancingActivities  BIGINT,
    NetChangeInCash                 BIGINT,
    PRIMARY KEY (Ticker, FiscalYear, FiscalPeriod)
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\us-cashflow-annual\\us-cashflow-annual.csv'
INTO TABLE us_cashflow_annual
FIELDS TERMINATED BY ';'
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- skip header row
