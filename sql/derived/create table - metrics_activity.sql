DROP TABLE IF EXISTS metrics_activity;

CREATE TABLE metrics_activity AS
SELECT
    isq.Ticker,
    isq.ReportDate,
    isq.Revenue / LAG(bsq.TotalAssets, 1) OVER (PARTITION BY isq.Ticker ORDER BY isq.ReportDate) AS SalesTurnover
FROM
    us_income_quarterly isq
    LEFT JOIN us_cashflow_quarterly cfq USING(Ticker, ReportDate)
    LEFT JOIN us_balance_quarterly bsq USING(Ticker, ReportDate)
    LEFT JOIN metrics_misc misc USING(Ticker, ReportDate);