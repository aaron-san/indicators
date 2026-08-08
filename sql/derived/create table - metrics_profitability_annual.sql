
DROP TABLE IF EXISTS metrics_profitability_annual;

CREATE TABLE metrics_profitability_annual AS
WITH
    last_price AS (
        SELECT
            pr.Ticker,
            x.ReportDate,
            pr.Date AS PrevCloseDate,
            pr.Close AS PrevClosePrice
        FROM (
                SELECT isa.Ticker, isa.ReportDate, (
                        SELECT pr.Date
                        FROM us_shareprices_daily pr
                        WHERE
                            pr.Ticker = isa.Ticker
                            AND pr.Date <= isa.ReportDate
                        ORDER BY pr.Date DESC
                        LIMIT 1
                    ) AS MarketPriceDate
                FROM us_income_quarterly isa
            ) x
            JOIN us_shareprices_daily pr ON pr.Ticker = x.Ticker
            AND pr.Date = x.MarketPriceDate
    ),
    fundamentals AS (
        SELECT
            isa.Ticker,
            isa.ReportDate,
            bsa.CashAndEquiv,
            CASE
                WHEN PretaxIncomeLoss > 0
                AND IncomeTaxExpenseBenefitNet < 0 THEN -1 * IncomeTaxExpenseBenefitNet / PretaxIncomeLoss
                ELSE NULL
            END AS EffectiveTaxRate,
            lp.PrevCloseDate,
            cfa.SharesBasic * lp.PrevClosePrice AS MarketCap,
            bsa.ShortTermDebt + bsa.LongTermDebt AS TotalDebt,
            cfa.NetCashFromOperatingActivities + cfa.ChangeInFixedAssetsIntangibles AS FreeCashFlow
        FROM
            us_income_quarterly isa
            LEFT JOIN us_cashflow_quarterly cfa USING (Ticker, ReportDate)
            LEFT JOIN us_balance_quarterly bsa USING (Ticker, ReportDate)
            LEFT JOIN last_price lp USING (Ticker, ReportDate)
    ),
    lagged_values AS (
        SELECT
            Ticker,
            ReportDate,
            LAG(TotalEquity, 1) OVER (
                PARTITION BY
                    Ticker
                ORDER BY ReportDate
            ) AS PrevYearTotalEquity,
            LAG(TotalAssets, 1) OVER (
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
    isa.Ticker,
    isa.ReportDate,
    f.EffectiveTaxRate,
    f.MarketCap + f.TotalDebt - f.CashAndEquiv AS EnterpriseValue,
    isa.GrossProfit / NULLIF(isa.Revenue, 0) AS GrossMargin,
    isa.OperatingIncomeLoss / NULLIF(isa.Revenue, 0) AS OperatingMargin,
    isa.NetIncome / NULLIF(isa.Revenue, 0) AS ProfitMargin,
    isa.NetIncome / CASE
        WHEN lv.PrevYearTotalAssets > 0 THEN lv.PrevYearTotalAssets
        ELSE NULL
    END AS ROA,
    isa.NetIncome / CASE
        WHEN lv.PrevYearTotalEquity > 0 THEN lv.PrevYearTotalEquity
        ELSE NULL
    END AS ROE,
    isa.OperatingIncomeLoss * (1 - f.EffectiveTaxRate) / (
        CASE
            WHEN bsa.TotalEquity > 0 THEN bsa.TotalEquity
            ELSE NULL
        END
    ) + bsa.ShortTermDebt + bsa.LongTermDebt - bsa.CashAndEquiv AS ROIC,
    isa.OperatingIncomeLoss / CASE
        WHEN ev.EnterpriseValue > 0 THEN ev.EnterpriseValue
        ELSE NULL
    END AS EBITToEV
FROM
    us_income_annual isa
    LEFT JOIN us_cashflow_annual cfa USING (Ticker, ReportDate)
    LEFT JOIN us_balance_annual bsa USING (Ticker, ReportDate)
    LEFT JOIN fundamentals f using (Ticker, ReportDate)
    LEFT JOIN enterprise_value ev using (Ticker, ReportDate)
    LEFT JOIN lagged_values lv using (Ticker, ReportDate)
