CREATE TABLE "final_sla_temp" AS
SELECT
    DISTINCT "delivery_id" AS delivery_id,
    "real_state" AS real_state,
    "real_date" AS real_date,
    "updated_date" AS updated_date
FROM "final_sla_dates"
GROUP BY 1, 2, 3, 4
ORDER BY "delivery_id", "real_date" desc;

CREATE TABLE "final_sla_temp1" AS
SELECT
    DISTINCT "delivery_id" AS delivery_id,
    "real_state" AS real_state,
    "status_created_date" AS status_created_date,
    "updated_date" AS updated_date
FROM "final_sla_dates"
GROUP BY 1, 2, 3, 4
ORDER BY "delivery_id", "status_created_date" desc;

CREATE TABLE "final_sla_transform" AS
SELECT
    delivery_id,
    updated_date,
    "'real_date_delivery'" AS real_date_delivery,
    "'real_date_provider'" AS real_date_provider,
    "'real_date_on_road'" AS real_date_on_road,
    "'real_date_warehouse'" AS real_date_warehouse,
    "'real_date_warehouse_out'" AS real_date_warehouse_out,
    "'real_date_pickup'" AS real_date_pickup,
    "'real_date_storno'" AS real_date_storno,
    "'real_date_init'" AS real_date_init,
    "'real_date_pay'" AS real_date_pay
FROM
    "final_sla_temp" pivot(
        MIN(real_date) FOR real_state IN (
            'real_date_delivery',
            'real_date_provider',
            'real_date_on_road',
            'real_date_warehouse',
            'real_date_warehouse_out',
            'real_date_pickup',
            'real_date_storno',
            'real_date_init',
            'real_date_pay'
        )
    ) p
ORDER BY delivery_id;

CREATE TABLE "final_status_transform" AS
SELECT
    delivery_id,
    updated_date,
    "'real_date_delivery'" AS real_date_delivery,
    "'real_date_provider'" AS real_date_provider,
    "'real_date_on_road'" AS real_date_on_road,
    "'real_date_warehouse'" AS real_date_warehouse,
    "'real_date_warehouse_out'" AS real_date_warehouse_out,
    "'real_date_pickup'" AS real_date_pickup,
    "'real_date_storno'" AS real_date_storno,
    "'real_date_init'" AS real_date_init,
    "'real_date_pay'" AS real_date_pay
FROM
    "final_sla_temp1" pivot(
        MIN(status_created_date) FOR real_state IN (
            'real_date_delivery',
            'real_date_provider',
            'real_date_on_road',
            'real_date_warehouse',
            'real_date_warehouse_out',
            'real_date_pickup',
            'real_date_storno',
            'real_date_init',
            'real_date_pay'
        )
    ) p
ORDER BY delivery_id;

CREATE TABLE if NOT EXISTS "non_delivered_orders" AS
SELECT
    DISTINCT n.*,
    first_value("mapping_czech_title") OVER (
        PARTITION BY "tracking_id"
        ORDER BY
            "order":: number desc,
            "status_date" asc
    ) "POSLEDNY_STAV",
    first_value("status_date") OVER (
        PARTITION BY "tracking_id"
        ORDER BY
            "order":: number desc,
            "status_date" asc
    ) "POSLEDNY_DATUM"
FROM "non_delivered_cz" AS n
    LEFT JOIN "full_states_history3" AS s
    ON s."tracking_id" = n."EXTERNI_IDENTIFIKACE_DODAVKY"
WHERE
    n."ODBYTOVY_DOKLAD" NOT LIKE '9%' AND
    "order" IS NOT NULL;