
DROP TABLE IF EXISTS us_cashflow_quarterly;

-- Create the table structure

CREATE TABLE us_cashflow_quarterly (
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
    NetChangeInCash                 BIGINT
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\us-cashflow-quarterly\\us-cashflow-quarterly.csv'
INTO TABLE us_cashflow_quarterly
FIELDS TERMINATED BY ';'
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- skip header row

ALTER TABLE us_cashflow_quarterly
ADD PRIMARY KEY (Ticker, ReportDate);
