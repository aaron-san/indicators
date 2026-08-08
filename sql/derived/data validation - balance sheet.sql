SELECT 'CashAndEquiv' AS Field,
       CONCAT(ROUND(100 * SUM(
           CASE WHEN CashAndEquiv IS NULL OR CashAndEquiv = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%") AS PercentMissing
FROM us_balance_annual

UNION ALL
SELECT 'AccountsNotesReceivable',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN AccountsNotesReceivable IS NULL OR AccountsNotesReceivable = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'Inventories',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN Inventories IS NULL OR Inventories = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'TotalCurrentAssets',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN TotalCurrentAssets IS NULL OR TotalCurrentAssets = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'PropertyPlantEquipmentNet',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN PropertyPlantEquipmentNet IS NULL OR PropertyPlantEquipmentNet = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'LongTermInvestmentsReceivables',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN LongTermInvestmentsReceivables IS NULL OR LongTermInvestmentsReceivables = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'OtherLongTermAssets',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN OtherLongTermAssets IS NULL OR OtherLongTermAssets = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'TotalAssets',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN TotalAssets IS NULL OR TotalAssets = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'PayablesAccruals',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN PayablesAccruals IS NULL OR PayablesAccruals = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'ShortTermDebt',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN ShortTermDebt IS NULL OR ShortTermDebt = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'TotalCurrentLiabilities',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN TotalCurrentLiabilities IS NULL OR TotalCurrentLiabilities = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'LongTermDebt',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN LongTermDebt IS NULL OR LongTermDebt = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'TotalLiabilities',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN TotalLiabilities IS NULL OR TotalLiabilities = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'ShareCapitalAdditionalPaidIn',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN ShareCapitalAdditionalPaidIn IS NULL OR ShareCapitalAdditionalPaidIn = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'TotalEquity',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN TotalEquity IS NULL OR TotalEquity = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'TotalLiabilitiesEquity',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN TotalLiabilitiesEquity IS NULL OR TotalLiabilitiesEquity = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'SharesBasic',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN SharesBasic IS NULL OR SharesBasic = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual

UNION ALL
SELECT 'SharesDiluted',
       CONCAT(ROUND(100 * SUM(
           CASE WHEN SharesDiluted IS NULL OR SharesDiluted = '' 
                THEN 1 ELSE 0 END
       ) / COUNT(*), 1), "%")
FROM us_balance_annual;
