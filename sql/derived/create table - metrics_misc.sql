DROP TABLE IF EXISTS metrics_misc;

CREATE TABLE metrics_misc AS
WITH
/* -----------------------------------------------------------
   1. PRICE LOOKUP — find the last available market price
----------------------------------------------------------- */
    last_price AS (
        SELECT
            pr.Ticker,
            x.ReportDate,
            pr.Date AS PrevCloseDate,
            pr.Close AS PrevClosePrice
        FROM (
            SELECT
                isq.Ticker,
                isq.ReportDate,
                (
                    SELECT pr.Date
                    FROM us_shareprices_daily pr
                    WHERE pr.Ticker = isq.Ticker
                      AND pr.Date <= isq.ReportDate
                    ORDER BY pr.Date DESC
                    LIMIT 1
                ) AS MarketPriceDate
            FROM us_income_quarterly isq
        ) x
        JOIN us_shareprices_daily pr
          ON pr.Ticker = x.Ticker
         AND pr.Date = x.MarketPriceDate
    ),
/* -----------------------------------------------------------
   2. FUNDAMENTALS — tax rate, market cap, debt, FCF
----------------------------------------------------------- */
    fundamentals AS (
        SELECT
            isq.Ticker,
            isq.ReportDate,
            bsq.CashAndEquiv,

            CASE
                WHEN isq.IncomeTaxExpenseBenefitNet >= 0 THEN NULL
                WHEN isq.PretaxIncomeLoss <= 0 THEN NULL
                ELSE -1 * isq.IncomeTaxExpenseBenefitNet /
                     NULLIF(isq.PretaxIncomeLoss, 0)
            END AS EffectiveTaxRate,

            lp.PrevCloseDate,
            cfq.SharesBasic * lp.PrevClosePrice AS MarketCap,
            bsq.ShortTermDebt + bsq.LongTermDebt AS TotalDebt,
            cfq.NetCashFromOperatingActivities +
            cfq.ChangeInFixedAssetsIntangibles AS FreeCashFlow

        FROM us_income_quarterly isq
        LEFT JOIN us_cashflow_quarterly cfq USING (Ticker, ReportDate)
        LEFT JOIN us_balance_quarterly bsq USING (Ticker, ReportDate)
        LEFT JOIN last_price lp USING (Ticker, ReportDate)
    ),
/* -----------------------------------------------------------
   3. RAW PAYOUT RATIO — dividends + buybacks / net income
----------------------------------------------------------- */
    payout_raw AS (
        SELECT
            Ticker,
            ReportDate,
            CASE
                WHEN (-DividendsPaid + -CashFromRepurchaseOfEquity) > 0
                     AND NetIncomeStartingLine > 0
                     AND (-DividendsPaid + -CashFromRepurchaseOfEquity) /
                         NetIncomeStartingLine <= 1
                THEN (-DividendsPaid + -CashFromRepurchaseOfEquity) /
                     NetIncomeStartingLine
                ELSE NULL
            END AS PayoutRatio
        FROM us_cashflow_quarterly
    ),
/* -----------------------------------------------------------
   4. NUMBERING — assign row numbers per ticker for LOCF
----------------------------------------------------------- */
    payout_numbered AS (
        SELECT
            Ticker,
            ReportDate,
            PayoutRatio,
            ROW_NUMBER() OVER (
                PARTITION BY Ticker
                ORDER BY ReportDate ASC
            ) AS rn
        FROM payout_raw
    ),
/* -----------------------------------------------------------
   5. LOCF — fill forward last non-null payout ratio
----------------------------------------------------------- */
    payout_filled AS (
        SELECT
            n1.Ticker,
            n1.ReportDate,
            n1.PayoutRatio,
            (
                SELECT n2.PayoutRatio
                FROM payout_numbered n2
                WHERE n2.Ticker = n1.Ticker
                  AND n2.rn <= n1.rn
                  AND n2.PayoutRatio IS NOT NULL
                ORDER BY n2.rn DESC
                LIMIT 1
            ) AS FilledPayoutRatio
        FROM payout_numbered n1
    )
/* -----------------------------------------------------------
   6. FINAL OUTPUT — merge fundamentals + payout metrics
----------------------------------------------------------- */
SELECT
    f.*,
    CASE 
        WHEN f.MarketCap + f.TotalDebt - f.CashAndEquiv < 0 THEN NULL
        ELSE f.MarketCap + f.TotalDebt - f.CashAndEquiv
    END AS EnterpriseValue,

    pr.PayoutRatio,
    pf.FilledPayoutRatio,

    AVG(pr.PayoutRatio) OVER (
        PARTITION BY pr.Ticker
        ORDER BY pr.ReportDate
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS TtmAvgPayoutRatio,

    AVG(pr.PayoutRatio) OVER (PARTITION BY pr.Ticker) AS TickerAveragePayout

FROM fundamentals f
LEFT JOIN payout_raw pr USING (Ticker, ReportDate)
LEFT JOIN payout_filled pf USING (Ticker, ReportDate)
ORDER BY f.Ticker, f.ReportDate;
