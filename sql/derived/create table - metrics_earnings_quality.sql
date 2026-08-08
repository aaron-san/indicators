
DROP TABLE IF EXISTS metrics_earnings_quality;

CREATE TABLE metrics_earnings_quality AS 
SELECT
    isa.Ticker,
    isa.ReportDate,
    cfa.NetCashFromOperatingActivities / NULLIF(isa.NetIncome, 0) AS EarningsQuality,
    misc.FreeCashFlow / NULLIF(isa.Revenue, 0) AS FCFMargin,
    misc.FreeCashFlow / NULLIF(isa.NetIncome, 0) AS FCFConversion
FROM us_cashflow_quarterly cfa
LEFT JOIN us_income_quarterly isa USING(Ticker, ReportDate)
-- LEFT JOIN us_balance_quarterly bsq USING(Ticker, ReportDate)
LEFT JOIN metrics_misc misc USING(Ticker, ReportDate);
