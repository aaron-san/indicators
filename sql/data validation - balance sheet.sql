
SELECT
    COUNT(*) AS TotalRows,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN CashAndEquiv IS NULL
            OR CashAndEquiv = 0
            OR CashAndEquiv = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS CashAndEquiv,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN AccountsNotesReceivable IS NULL
            OR AccountsNotesReceivable = 0
            OR AccountsNotesReceivable = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS AccountsNotesReceivable,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN Inventories IS NULL
            OR Inventories = 0
            OR Inventories = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS Inventories,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN TotalCurrentAssets IS NULL
            OR TotalCurrentAssets = 0
            OR TotalCurrentAssets = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS TotalCurrentAssets,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN PropertyPlantEquipmentNet IS NULL
            OR PropertyPlantEquipmentNet = 0
            OR PropertyPlantEquipmentNet = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS PropertyPlantEquipmentNet,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN LongTermInvestmentsReceivables IS NULL
            OR LongTermInvestmentsReceivables = 0
            OR LongTermInvestmentsReceivables = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS LongTermInvestmentsReceivables,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN OtherLongTermAssets IS NULL
            OR OtherLongTermAssets = 0
            OR OtherLongTermAssets = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS OtherLongTermAssets,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN TotalAssets IS NULL
            OR TotalAssets = 0
            OR TotalAssets = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS TotalAssets,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN PayablesAccruals IS NULL
            OR PayablesAccruals = 0
            OR PayablesAccruals = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS PayablesAccruals,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN ShortTermDebt IS NULL
            OR ShortTermDebt = 0
            OR ShortTermDebt = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS ShortTermDebt,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN TotalCurrentLiabilities IS NULL
            OR TotalCurrentLiabilities = 0
            OR TotalCurrentLiabilities = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS TotalCurrentLiabilities,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN LongTermDebt IS NULL
            OR LongTermDebt = 0
            OR LongTermDebt = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS LongTermDebt,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN TotalLiabilities IS NULL
            OR TotalLiabilities = 0
            OR TotalLiabilities = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS TotalLiabilities,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN ShareCapitalAdditionalPaidIn IS NULL
            OR ShareCapitalAdditionalPaidIn = 0
            OR ShareCapitalAdditionalPaidIn = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS ShareCapitalAdditionalPaidIn,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN TotalEquity IS NULL
            OR TotalEquity = 0
            OR TotalEquity = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS TotalEquity,
    CONCAT(ROUND(100 * SUM(
        CASE
            WHEN TotalLiabilitiesEquity IS NULL
            OR TotalLiabilitiesEquity = 0
            OR TotalLiabilitiesEquity = '' THEN 0
            ELSE 1
        END
    ) / COUNT(*), 1), "%") AS TotalLiabilitiesEquity,
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
FROM us_balance_annual



