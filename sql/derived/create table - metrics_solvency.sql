DROP TABLE IF EXISTS metrics_solvency;

CREATE TABLE metrics_solvency AS (
SELECT
    bsq.Ticker,
    bsq.ReportDate,
    -- Debt-to-Equity: total debt relative to shareholder equity
    (misc.TotalDebt / NULLIF(bsq.TotalEquity, 0)) AS DebtToEquity,
    -- Debt-to-Assets: leverage relative to total assets
    (bsq.TotalLiabilities / NULLIF(bsq.TotalAssets, 0)) AS DebtRatio,
    -- Interest Coverage: ability to cover interest expense with EBIT
    CASE WHEN isq.InterestExpenseNet > 0  OR isq.OperatingIncomeLoss < 0 THEN NULL
    ELSE (isq.OperatingIncomeLoss / NULLIF(ABS(isq.InterestExpenseNet), 0))
    END AS InterestCoverageRatio
FROM us_balance_quarterly bsq
-- LEFT JOIN us_income_quarterly isq USING (Ticker, ReportDate)
LEFT JOIN metrics_misc misc USING(Ticker, ReportDate)
LEFT JOIN us_income_quarterly isq USING(Ticker, ReportDate)
);
