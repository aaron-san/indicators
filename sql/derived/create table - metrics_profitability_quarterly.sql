DROP TABLE IF EXISTS metrics_profitability_quarterly;

CREATE TABLE metrics_profitability_quarterly AS
WITH
    last_price AS (
        SELECT
            pr.Ticker,
            x.ReportDate,
            pr.Date AS PrevCloseDate,
            pr.Close AS PrevClosePrice
        FROM (
                SELECT isq.Ticker, isq.ReportDate, (
                        SELECT pr.Date
                        FROM us_shareprices_daily pr
                        WHERE
                            pr.Ticker = isq.Ticker
                            AND pr.Date <= isq.ReportDate
                        ORDER BY pr.Date DESC
                        LIMIT 1
                    ) AS MarketPriceDate
                FROM us_income_quarterly isq
            ) x
            JOIN us_shareprices_daily pr ON pr.Ticker = x.Ticker
            AND pr.Date = x.MarketPriceDate
    ),
    fundamentals AS (
        SELECT
            isq.Ticker,
            isq.ReportDate,
            bsq.CashAndEquiv,
            CASE
                WHEN PretaxIncomeLoss > 0
                AND IncomeTaxExpenseBenefitNet < 0 THEN -1 * IncomeTaxExpenseBenefitNet / PretaxIncomeLoss
                ELSE NULL
            END AS EffectiveTaxRate,
            lp.PrevCloseDate,
            cfq.SharesBasic * lp.PrevClosePrice AS MarketCap,
            bsq.ShortTermDebt + bsq.LongTermDebt AS TotalDebt,
            cfq.NetCashFromOperatingActivities + cfq.ChangeInFixedAssetsIntangibles AS FreeCashFlow
        FROM
            us_income_quarterly isq
            LEFT JOIN us_cashflow_quarterly cfq USING (Ticker, ReportDate)
            LEFT JOIN us_balance_quarterly bsq USING (Ticker, ReportDate)
            LEFT JOIN last_price lp USING (Ticker, ReportDate)
    ),
    lagged_values AS (
        SELECT
            Ticker,
            ReportDate,
            LAG(TotalEquity, 4) OVER (
                PARTITION BY
                    Ticker
                ORDER BY ReportDate
            ) AS PrevYearTotalEquity,
            LAG(TotalAssets, 4) OVER (
                PARTITION BY
                    Ticker
                ORDER BY ReportDate
            ) AS PrevYearTotalAssets
        FROM us_balance_annual
    ),
    enterprise_value AS (
        SELECT
            Ticker,
            ReportDate,
            MarketCap + TotalDebt - CashAndEquiv AS EnterpriseValue
        FROM fundamentals
    )
SELECT
    isq.Ticker,
    isq.ReportDate,
    f.EffectiveTaxRate,
    f.MarketCap + f.TotalDebt - f.CashAndEquiv AS EnterpriseValue,
    isq.GrossProfit / NULLIF(isq.Revenue, 0) AS GrossMargin,
    isq.OperatingIncomeLoss / NULLIF(isq.Revenue, 0) AS OperatingMargin,
    isq.NetIncome / NULLIF(isq.Revenue, 0) AS ProfitMargin,
    isq.NetIncome / CASE
        WHEN lv.PrevYearTotalAssets > 0 THEN lv.PrevYearTotalAssets
        ELSE NULL
    END AS ROA,
    isq.NetIncome / CASE
        WHEN lv.PrevYearTotalEquity > 0 THEN lv.PrevYearTotalEquity
        ELSE NULL
    END AS ROE,
    isq.OperatingIncomeLoss * (1 - f.EffectiveTaxRate) / (
        CASE
            WHEN bsq.TotalEquity > 0 THEN bsq.TotalEquity
            ELSE NULL
        END + bsq.ShortTermDebt + bsq.LongTermDebt - bsq.CashAndEquiv
    ) AS ROIC,
    isq.OperatingIncomeLoss / CASE
        WHEN ev.EnterpriseValue > 0 THEN ev.EnterpriseValue
        ELSE NULL
    END AS EBITToEV
FROM
    us_income_quarterly isq
    LEFT JOIN us_cashflow_quarterly cfq USING (Ticker, ReportDate)
    LEFT JOIN us_balance_quarterly bsq USING (Ticker, ReportDate)
    LEFT JOIN fundamentals f using (Ticker, ReportDate)
    LEFT JOIN enterprise_value ev using (Ticker, ReportDate)
    LEFT JOIN lagged_values lv using (Ticker, ReportDate)