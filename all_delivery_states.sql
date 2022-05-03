-- Merge Mall states with provider states --
CREATE TABLE if NOT EXISTS "full_states_history1" AS (
        SELECT
            l."delivery_id" | | l."code" | | l."date" AS "id",
            l."delivery_id",
            l."is_active",
            l."tracking_id",
            CASE
                WHEN l."code" = 'E91'
                THEN '100'
                WHEN l."code" IN ('E94', 'ER1', 'E93', 'Z01')
                THEN '101'
                WHEN l."code" IN ('E01', 'E02', 'E12', 'E13', 'E15', 'E21')
                THEN '98'
                WHEN l."code" IN ('E11') AND
                l."is_paid" = 1
                THEN 'E11'
                WHEN l."code" IN ('E23', 'E22')
                THEN '99'
                ELSE l."code"
            END AS "status",
            l."date" AS "status_date",
            NULL AS "status_created_date",
            l."title" AS "status_name",
            l."updated_date" AS "updated_date",
            NULL AS "admin_mapping_id"
        FROM "last_tracking_state" AS l
        ORDER BY "delivery_id"
    )
UNION (
    SELECT
        l."delivery_id" | | to_varchar(p."status_id") | | p."status_date" AS "id",
        l."delivery_id",
        l."is_active",
        p."tracking_id",
        CASE
            WHEN to_varchar(p."status_id") IN ('5', '12', '14', '9', '8', '18', '16', '23')
            THEN '100'
            WHEN to_varchar(p."status_id") IN ('6', '10')
            THEN '101'
            ELSE to_varchar(p."status_id")
        END AS "status",
        p."status_date" AS "status_date",
        p."status_created_date" AS "status_created_date",
        p."status_name" AS "status_name",
        l."updated_date" AS "updated_date",
        p."admin_mapping_id"
    FROM "provider_history_all" AS p
        INNER JOIN "last_tracking_state" AS l
        ON p."tracking_id" = l."tracking_id"
    ORDER BY "delivery_id"
);

-- Sort the states from first to the last based on defined order and date --
CREATE TABLE "full_states_history2" AS
SELECT f.*, s."order"
FROM "full_states_history1" AS f
    LEFT JOIN "all_states" AS s
    ON s."status_code" = f."status"
WHERE s."order" IS NOT NULL;

CREATE TABLE "full_states_history3" AS
SELECT
    DISTINCT f."tracking_id",
    f."delivery_id",
    f."status_date",
    am."mapping_title",
    am."title" AS "mapping_czech_title",
    am."order" AS "order"
FROM "full_states_history1" AS f
    LEFT JOIN "admin_mapping" AS am
    ON am."id" = f."admin_mapping_id";

-- Find the states and dates when our defined SLA was fullfill --
CREATE TABLE if NOT EXISTS "final_sla_dates1" AS
SELECT
    DISTINCT "delivery_id",
    "is_active",
    "tracking_id",
    "status",
    "order",
    "updated_date",
    CASE
        WHEN "status" IN ('100')
        THEN 'real_date_delivery'
        WHEN "status" IN ('3')
        THEN 'real_date_provider'
        WHEN "status" IN ('4', '11', '13', '15', '17', '7', '19', '22')
        THEN 'real_date_on_road'
        WHEN "status" IN ('99')
        THEN 'real_date_warehouse'
        WHEN "status" IN ('E24', 'E25')
        THEN 'real_date_warehouse_out'
        WHEN "status" IN ('E26')
        THEN 'real_date_pickup'
        WHEN "status" IN ('101')
        THEN 'real_date_storno'
        WHEN "status" IN ('98')
        THEN 'real_date_init'
        WHEN "status" IN ('E11')
        THEN 'real_date_pay'
    END AS "real_state",
    CASE
        WHEN "status" IN ('100')
        THEN "status_date"
        WHEN "status" IN ('3')
        THEN "status_date"
        WHEN "status" IN ('4', '11', '13', '15', '17', '7', '19', '22')
        THEN "status_date"
        WHEN "status" IN ('99')
        THEN "status_date"
        WHEN "status" IN ('E24', 'E25')
        THEN "status_date"
        WHEN "status" IN ('E26')
        THEN "status_date"
        WHEN "status" IN ('101')
        THEN "status_date"
        WHEN "status" IN ('98')
        THEN "status_date"
        WHEN "status" IN ('E11')
        THEN "status_date"
    END AS "real_date",
    CASE
        WHEN "status" IN ('100')
        THEN "status_created_date"
        WHEN "status" IN ('3')
        THEN "status_created_date"
        WHEN "status" IN ('4', '11', '13', '15', '17', '7', '19', '22')
        THEN "status_created_date"
        WHEN "status" IN ('99')
        THEN "status_created_date"
        WHEN "status" IN ('E24', 'E25')
        THEN "status_created_date"
        WHEN "status" IN ('E26')
        THEN "status_created_date"
        WHEN "status" IN ('101')
        THEN "status_created_date"
        WHEN "status" IN ('98')
        THEN "status_created_date"
        WHEN "status" IN ('E11')
        THEN "status_created_date"
    END AS "status_created_date",
    CASE
        WHEN "status" IN ('100')
        THEN 'Doručeno'
        WHEN "status" IN ('3')
        THEN 'U dopravce'
        WHEN "status" IN ('4', '11', '13', '15', '17', '7', '19', '22')
        THEN 'Na cestě'
        WHEN "status" IN ('99')
        THEN 'Na skladě'
        WHEN "status" IN ('E24', 'E25')
        THEN 'Vyskladněno'
        WHEN "status" IN ('E26')
        THEN 'Doručeno'
        WHEN "status" IN ('101')
        THEN 'Storno'
        WHEN "status" IN ('98')
        THEN ' '
        WHEN "status" IN ('E11')
        THEN 'Zaplaceno'
    END AS "real_state_cz"
FROM "full_states_history2"
WHERE "real_state" IS NOT NULL;

CREATE TABLE if NOT EXISTS "status_19" AS
SELECT
    DISTINCT "tracking_id",
    "status_name" AS "status",
    "status_id" AS "status_id",
    "status_date"
FROM "provider_history_all"
WHERE "status_id" IN (19, 20);