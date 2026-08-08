
SELECT
    COUNT(*) AS TotalRows,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN NetCashFromOperatingActivities IS NULL
            OR NetCashFromOperatingActivities = 0
            OR NetCashFromOperatingActivities = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS NetCashFromOperatingActivities,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN NetIncomeStartingLine IS NULL
            OR NetIncomeStartingLine = 0
            OR NetIncomeStartingLine = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS NetIncomeStartingLine,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN SharesBasic IS NULL
            OR SharesBasic = 0
            OR SharesBasic = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS SharesBasic,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN SharesDiluted IS NULL
            OR SharesDiluted = 0 
            OR SharesDiluted = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS SharesDiluted
FROM us_cashflow_annual