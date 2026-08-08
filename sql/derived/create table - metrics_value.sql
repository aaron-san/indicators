DROP TABLE IF EXISTS metrics_value;

CREATE TABLE metrics_value AS
-- CREATE TABLE metrics_value AS
SELECT
    isq.Ticker,
    isq.ReportDate,
    dts.PrevCloseDate AS PriceDate,
    -- PE = MarketCap / NetIncome
    CASE
        WHEN isq.NetIncome IS NULL OR isq.NetIncome <= 0 THEN NULL
        ELSE misc.MarketCap / isq.NetIncome
    END AS PE,
    -- PS = MarketCap / Revenue
    misc.MarketCap / NULLIF(isq.Revenue, 0) AS PS,
    -- PB = MarketCap / TotalEquity
    misc.MarketCap / NULLIF(bsq.TotalEquity, 0) AS PB

FROM us_income_quarterly isq
LEFT JOIN us_cashflow_quarterly cfq USING (Ticker, ReportDate)
LEFT JOIN us_balance_quarterly bsq USING (Ticker, ReportDate)
LEFT JOIN metrics_misc misc USING (Ticker, ReportDate)
LEFT JOIN dates_lookup dts USING (Ticker, ReportDate);
