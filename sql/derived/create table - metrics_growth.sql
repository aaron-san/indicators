DROP TABLE IF EXISTS metrics_growth;

CREATE TABLE metrics_growth AS
SELECT
    isa.Ticker,
    isa.ReportDate,
    isa.Revenue / NULLIF(LAG(isa.Revenue) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS RevenueGrowthYOY,
    CASE
        WHEN isa.GrossProfit < 0
        OR LAG(isa.GrossProfit) OVER(PARTITION BY isa.Ticker ORDER BY isa.ReportDate) <= 0 THEN NULL
        ELSE isa.GrossProfit / NULLIF(LAG(isa.GrossProfit, 4) OVER (
            PARTITION BY
                isa.Ticker
            ORDER BY isa.ReportDate
        ), 0) -1
    END AS GrossProfitGrowthYOY,
    CASE
        WHEN isa.OperatingIncomeLoss < 0
        OR LAG(isa.OperatingIncomeLoss) OVER(PARTITION BY isa.Ticker ORDER BY isa.ReportDate) <= 0 THEN NULL
        ELSE isa.OperatingIncomeLoss / NULLIF(LAG(isa.OperatingIncomeLoss) OVER (
            PARTITION BY
                isa.Ticker
            ORDER BY isa.ReportDate
        ), 0) -1 
    END AS OperatingIncomeGrowthYOY,
    CASE
        WHEN isa.NetIncome < 0
        OR LAG(isa.NetIncome) OVER(PARTITION BY isa.Ticker ORDER BY isa.ReportDate) <= 0 THEN NULL
        ELSE isa.NetIncome / NULLIF(LAG(isa.NetIncome) OVER (
            PARTITION BY
                isa.Ticker
            ORDER BY isa.ReportDate
        ), 0) -1
    END AS NetIncomeGrowthYOY,
    bsa.TotalAssets / NULLIF(LAG(bsa.TotalAssets) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS TotalAssetsGrowthYOY,
    bsa.TotalLiabilities / NULLIF(LAG(bsa.TotalLiabilities) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS TotalLiabilitiesGrowthYOY,
    bsa.CashAndEquiv / NULLIF(LAG(bsa.CashAndEquiv) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS CashAndEquivGrowthYOY,
    cfa.NetCashFromOperatingActivities / NULLIF(LAG(cfa.NetCashFromOperatingActivities) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS NetCashFromOperatingActivitiesYOY,
    cfa.NetCashFromInvestingActivities / NULLIF(LAG(cfa.NetCashFromInvestingActivities) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS NetCashFromInvestingActivitiesYOY,
    cfa.NetCashFromFinancingActivities / NULLIF(LAG(cfa.NetCashFromFinancingActivities) OVER (
        PARTITION BY
            isa.Ticker
        ORDER BY isa.ReportDate
    ), 0) -1 AS NetCashFromFinancingActivitiesYOY
FROM
    us_income_annual isa
    LEFT JOIN us_balance_annual bsa 
        ON isa.Ticker = bsa.Ticker 
        AND isa.ReportDate = bsa.ReportDate
    LEFT JOIN us_cashflow_annual cfa
        ON isa.Ticker = cfa.Ticker 
        AND isa.ReportDate = cfa.ReportDate