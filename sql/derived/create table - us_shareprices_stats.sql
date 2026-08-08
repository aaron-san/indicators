
DROP TABLE IF EXISTS us_shareprices_stats;

CREATE TABLE us_shareprices_stats (
    Ticker VARCHAR(20),
    Date DATE,
    Close DECIMAL(12, 4),
    AdjClose DECIMAL(12, 4),
    MonthlyReturn DECIMAL(8, 4),
    RunningMax DECIMAL(12, 4),
    Drawdown DECIMAL(12, 4),
    MA_3M DECIMAL(12, 4),
    MA_6M DECIMAL(12, 4),
    MA_1Y DECIMAL(12, 4),
    Annualized_3Yr_Volatility DECIMAL(12, 4)
);

INSERT INTO
    us_shareprices_stats (
        Ticker,
        Date,
        Close,
        AdjClose,
        MonthlyReturn,
        RunningMax,
        Drawdown,
        MA_3M,
        MA_6M,
        MA_1Y,
        Annualized_3Yr_Volatility
    )
WITH
    monthly_returns AS (
        SELECT
            Ticker,
            `Date`,
            `Close`,
            AdjClose,
            CASE
                WHEN AdjClose > 0
                AND LAG(AdjClose) OVER (
                    PARTITION BY
                        Ticker
                    ORDER BY Date
                ) > 0 THEN LOG(
                    AdjClose / LAG(AdjClose) OVER (
                        PARTITION BY
                            Ticker
                        ORDER BY Date
                    )
                )
                ELSE NULL
            END AS MonthlyReturn
        FROM us_shareprices_monthly
    )
SELECT
    Ticker,
    Date,
    Close,
    AdjClose,
    MonthlyReturn,
    MAX(AdjClose) OVER (
        PARTITION BY
            Ticker
        ORDER BY Date
    ) AS RunningMax,
    ROUND(
        (
            AdjClose - MAX(AdjClose) OVER (
                PARTITION BY
                    Ticker
                ORDER BY Date
            )
        ) / NULLIF(
            MAX(AdjClose) OVER (
                PARTITION BY
                    Ticker
                ORDER BY Date
            ),
            0
        ),
        3
    ) AS Drawdown,
    ROUND(
        AVG(AdjClose) OVER (
            PARTITION BY
                Ticker
            ORDER BY Date ROWS BETWEEN 2 PRECEDING
                AND CURRENT ROW
        ),
        3
    ) AS MA_3M,
    ROUND(
        AVG(AdjClose) OVER (
            PARTITION BY
                Ticker
            ORDER BY Date ROWS BETWEEN 5 PRECEDING
                AND CURRENT ROW
        ),
        3
    ) AS MA_6M,
    ROUND(
        AVG(AdjClose) OVER (
            PARTITION BY
                Ticker
            ORDER BY Date ROWS BETWEEN 11 PRECEDING
                AND CURRENT ROW
        ),
        3
    ) AS MA_1Y,
    ROUND(
        SQRT(12) * STDDEV(MonthlyReturn) OVER (
            PARTITION BY
                Ticker
            ORDER BY Date ROWS BETWEEN 35 PRECEDING
                AND CURRENT ROW
        ),
        4
    ) AS Annualized_3Yr_Volatility
FROM monthly_returns;

-- ALTER TABLE us_shareprices_stats RENAME COLUMN RollingTrailing3YRStdDev TO Annualized_3Yr_Volatility;

UPDATE us_shareprices_stats SET Ticker = NULL WHERE Ticker = '';

