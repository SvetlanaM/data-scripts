/* For first run */
CREATE TABLE "in" IF NOT EXISTS AS
SELECT NULL AS "timestamp";

CREATE TABLE "out" AS
SELECT
    CASE
        WHEN DATEDIFF(
            DAY
            /*Exception for running twice in day*/
, (
                SELECT
                    MAX(convert_timezone('Europe/Prague', "timestamp"))
                FROM
                    "in"
            ),
            convert_timezone('Europe/Prague', CURRENT_TIMESTAMP())
        ) = 0
        THEN (1 / 0):: DATETIME
        ELSE convert_timezone('Europe/Prague', CURRENT_TIMESTAMP())
    END AS "timestamp",
    'event_trigger_30_parcel_tracking_orchestration_4_35' AS "event";