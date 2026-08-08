DROP TABLE IF EXISTS dates_lookup;

CREATE TABLE dates_lookup AS
SELECT
    isq.Ticker,
    isq.ReportDate,
    prc.PrevCloseDate,
    isq.PublishDate,
    ndp.NextMarketDateFollowingPublish,
    mep.NextMonthEndDateFollowingPublish
FROM us_income_quarterly isq
LEFT JOIN us_shareprices_daily pr
    ON pr.Ticker = isq.Ticker
    AND pr.Date = isq.ReportDate
LEFT JOIN LATERAL (
    SELECT 
    Date AS PrevCloseDate
    FROM us_shareprices_daily
    WHERE Ticker = isq.Ticker
      AND Date < isq.ReportDate
    ORDER BY Date DESC
    LIMIT 1
) prc ON TRUE
LEFT JOIN LATERAL (
    SELECT 
    Date AS NextMarketDateFollowingPublish
    FROM us_shareprices_daily
    WHERE Ticker = isq.Ticker
      AND Date > isq.PublishDate
    ORDER BY Date ASC
    LIMIT 1
) ndp ON TRUE
LEFT JOIN LATERAL (
    SELECT 
    pr2.Date AS NextMonthEndDateFollowingPublish
    FROM us_shareprices_daily pr2
    WHERE pr2.Ticker = isq.Ticker
      AND pr2.Date <= (
            CASE 
                WHEN DATEDIFF(LAST_DAY(isq.PublishDate), isq.PublishDate) <= 3
                    THEN LAST_DAY(DATE_ADD(isq.PublishDate, INTERVAL 1 MONTH))
                ELSE LAST_DAY(isq.PublishDate)
            END
      )
    ORDER BY pr2.Date DESC
    LIMIT 1
) mep ON TRUE;
