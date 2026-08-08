
DROP TABLE IF EXISTS us_income_ttm;

-- Create the table structure
CREATE TABLE us_income_ttm (
    Ticker                              VARCHAR(10)     NOT NULL,
    SimFinId                            INT             NOT NULL,
    Currency                            VARCHAR(5),
    FiscalYear                          SMALLINT        NOT NULL,
    FiscalPeriod                        VARCHAR(4)      NOT NULL,
    ReportDate                          DATE,
    PublishDate                         DATE,
    RestatedDate                        DATE,
    SharesBasic                         BIGINT,
    SharesDiluted                       BIGINT,
    Revenue                             BIGINT,
    CostOfRevenue                       BIGINT,
    GrossProfit                         BIGINT,
    OperatingExpenses                   BIGINT,
    SellingGeneralAdministrative        BIGINT,
    ResearchDevelopment                 BIGINT,
    DepreciationAmortization            BIGINT,
    OperatingIncomeLoss                 BIGINT,
    NonOperatingIncomeLoss              BIGINT,
    InterestExpenseNet                  BIGINT,
    PretaxIncomeLossAdj                 BIGINT,
    AbnormalGainsLosses                 BIGINT,
    PretaxIncomeLoss                    BIGINT,
    IncomeTaxExpenseBenefitNet          BIGINT,
    IncomeLossFromContinuingOperations  BIGINT,
    NetExtraordinaryGainsLosses         BIGINT,
    NetIncome                           BIGINT,
    NetIncomeCommon                     BIGINT,
    PRIMARY KEY (Ticker, FiscalYear, FiscalPeriod)
);

-- Upload the csv data
LOAD DATA LOCAL INFILE 'c:\\Users\\aaron\\Desktop\\Local Projects\\Portfolio Projects\\data\\SimFin\\us-income-ttm\\us-income-ttm.csv'
INTO TABLE us_income_ttm
FIELDS TERMINATED BY ';'
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; -- skip header row
