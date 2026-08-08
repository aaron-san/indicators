

DROP TABLE IF EXISTS us_shareprices_monthly_returns;

CREATE TABLE us_shareprices_monthly_returns AS
WITH base AS (
    SELECT
        Ticker,
        Date,
        AdjClose,
        Close,
        LAG(AdjClose) OVER (
            PARTITION BY Ticker ORDER BY Date
        ) AS PrevAdjClose
    FROM us_shareprices_monthly
)
SELECT
    Ticker,
    Date,
    AdjClose,
    Close,
    PrevAdjClose,
    CASE
        WHEN PrevAdjClose IS NULL THEN NULL
        WHEN PrevAdjClose = 0 THEN NULL
        ELSE (AdjClose - PrevAdjClose) / PrevAdjClose
    END AS MonthlyReturn
FROM base;


CREATE INDEX idx_monthly_returns_ticker_date
ON us_shareprices_monthly_returns (Ticker, Date);
