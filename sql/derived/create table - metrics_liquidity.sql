DROP TABLE IF EXISTS metrics_liquidity;

CREATE TABLE metrics_liquidity (
    Ticker VARCHAR(20),
    ReportDate DATE,
    CashRatio DOUBLE,
    QuickRatio DOUBLE,
    CurrentRatio DOUBLE,
    PRIMARY KEY (Ticker, ReportDate)
);

INSERT INTO metrics_liquidity (Ticker, ReportDate, CashRatio, QuickRatio, CurrentRatio)
SELECT
    Ticker,
    ReportDate,
    CashAndEquiv / NULLIF(TotalCurrentLiabilities, 0) AS CashRatio,
    (CashAndEquiv + COALESCE(AccountsNotesReceivable, 0)) / NULLIF(TotalCurrentLiabilities, 0) AS QuickRatio,
    TotalCurrentAssets / NULLIF(TotalCurrentLiabilities, 0) AS CurrentRatio
FROM us_balance_quarterly;

INSERT INTO metrics_liquidity (Ticker, ReportDate, CashRatio, QuickRatio, CurrentRatio)
SELECT
    Ticker,
    ReportDate,
    CashAndEquiv / NULLIF(TotalCurrentLiabilities, 0) AS CashRatio,
    (CashAndEquiv + COALESCE(AccountsNotesReceivable, 0)) / NULLIF(TotalCurrentLiabilities, 0) AS QuickRatio,
    TotalCurrentAssets / NULLIF(TotalCurrentLiabilities, 0) AS CurrentRatio
FROM us_balance_annual
ON DUPLICATE KEY UPDATE
    CashRatio = VALUES(CashRatio),
    QuickRatio = VALUES(QuickRatio),
    CurrentRatio = VALUES(CurrentRatio);
