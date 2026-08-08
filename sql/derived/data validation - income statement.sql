
SELECT
    COUNT(*) AS TotalRows,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN Revenue IS NULL
            OR Revenue = 0
            OR Revenue = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS Revenue,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN GrossProfit IS NULL
            OR GrossProfit = 0
            OR GrossProfit = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS GrossProfit,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN OperatingIncomeLoss IS NULL
            OR OperatingIncomeLoss = 0
            OR OperatingIncomeLoss = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS OperatingIncomeLoss,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN NetIncomeCommon IS NULL
            OR NetIncomeCommon = 0 
            OR NetIncomeCommon = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS NetIncomeCommon
FROM us_income_annual