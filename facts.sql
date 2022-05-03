ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

CREATE TABLE
    IF NOT EXISTS "fact_day_detail" AS -- Malo byť doručené -- (
SELECT
    DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
    d."delivery_id",
    d."planned_date_delayed" AS "planned_date",
    d."updated_date",
    d."status_date",
    d."status_id",
    CASE
        WHEN d."status_id" = 'real_date_on_road' AND
        CURRENT_TIMESTAMP:: DATE > "planned_date":: DATE
        THEN 'delayed'
        WHEN d."status_id" = 'real_date_warehouse_out' AND
        CURRENT_TIMESTAMP:: DATE > "planned_date":: DATE AND
        d."delivery_provider_id" = 26
        THEN 'delayed'
    END AS "state"
FROM "final_sla_dates2" AS d
WHERE (
        d."delivery_type_main" = 'delivery' OR
        d."delivery_type_main" = 'delivery_pickup'
    ) AND
    "customer_delivery_date" IS NOT NULL AND
    "state" IS NOT NULL
ORDER BY "planned_date" desc
)
UNION ALL
-- Meškajúce doručené, Nemeškajúce doručené -- (
SELECT
    DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
    d."delivery_id",
    d."planned_date_delayed" AS "planned_date",
    d."updated_date",
    d."status_date",
    d."status_id",
    CASE
        WHEN d."status_id" = 'real_date_delivery' AND
        "status_date":: DATE <= "planned_date":: DATE
        THEN 'delivered'
        WHEN d."status_id" = 'real_date_delivery' AND
        "status_date":: DATE > "planned_date":: DATE
        THEN 'delivered'
    END AS "state"
FROM "final_sla_dates2" AS d
WHERE
    d."delivery_type_main" = 'delivery' OR
    d."delivery_type_main" = 'delivery_pickup' AND
    "customer_delivery_date" IS NOT NULL AND
    "state" IS NOT NULL
ORDER BY "planned_date" desc
) -- storno vcera --
UNION ALL (
    SELECT
        DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
        d."delivery_id",
        d."customer_delivery_date" AS "planned_date",
        d."updated_date",
        d."status_date",
        d."status_id",
        CASE
            WHEN d."status_id" = 'real_date_storno' AND
            "status_date":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
            THEN 'storno_yesterday'
            WHEN d."status_id" = 'real_date_storno'
            THEN 'storno'
        END AS "state"
    FROM "final_sla_dates2" AS d
    WHERE
        "customer_delivery_date" IS NOT NULL AND
        "state" IS NOT NULL
    ORDER BY "planned_date" desc
);

ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Malo byť na sklade --
CREATE TABLE if NOT EXISTS "warehouse" AS (
        SELECT
            DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
            d."delivery_id",
            d."planned_date_delayed_warehouse" AS "planned_date",
            d."updated_date",
            d."status_date",
            d."status_id",
            CASE
                WHEN d."status_id" = 'real_date_init' AND
                CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP AND
                d."is_paid" = 1
                THEN 'delayed_warehouse'
            END AS "state"
        FROM "final_sla_dates2" AS d
        WHERE
            "customer_delivery_date" IS NOT NULL AND
            "state" IS NOT NULL AND
            "status_date" IS NOT NULL
        ORDER BY "planned_date" desc
    )
UNION (
    SELECT
        DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
        d."delivery_id",
        d."planned_date_delayed_pay" AS "planned_date",
        d."updated_date",
        d."status_date",
        d."status_id",
        CASE
            WHEN d."status_id" = 'real_date_init' AND
            CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP AND
            d."is_paid" = 0
            THEN 'delayed_pay'
        END AS "state"
    FROM "final_sla_dates2" AS d
    WHERE
        "customer_delivery_date" IS NOT NULL AND
        "state" IS NOT NULL AND
        "status_date" IS NOT NULL
    ORDER BY "planned_date" desc
);

ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

CREATE TABLE
    if NOT EXISTS "delayed_provider" AS -- Mělo být u dopravce -- (
SELECT
    DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
    d."delivery_id",
    d."planned_date_delayed_provider" AS "planned_date",
    d."updated_date",
    d."status_date",
    d."status_id",
    CASE
        WHEN d."status_id" = 'real_date_warehouse_out' AND
        CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP
        THEN 'delayed_provider'
    END AS "state"
FROM "final_sla_dates2" AS d
WHERE (
        d."delivery_type_main" = 'delivery' OR
        d."delivery_type_main" = 'delivery_pickup'
    ) AND
    d."delivery_provider_id" != 26 AND
    "customer_delivery_date" IS NOT NULL AND
    "state" IS NOT NULL AND
    "status_date" IS NOT NULL
ORDER BY "planned_date" desc
)
UNION ALL
-- Mělo být na cestě -- (
SELECT
    DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
    d."delivery_id",
    d."planned_date_delayed_on_road" AS "planned_date",
    d."updated_date",
    d."status_date",
    d."status_id",
    CASE
        WHEN d."status_id" = 'real_date_provider' AND
        CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP
        THEN 'delayed_on_road'
    END AS "state"
FROM "final_sla_dates2" AS d
WHERE (
        d."delivery_type_main" = 'delivery' OR
        d."delivery_type_main" = 'delivery_pickup'
    ) AND
    "customer_delivery_date" IS NOT NULL AND
    "state" IS NOT NULL AND
    "status_date" IS NOT NULL
ORDER BY "planned_date" desc
);

ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Malo byť vyskladnené --
CREATE TABLE if NOT EXISTS "warehouse_out" AS (
        SELECT
            DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
            d."delivery_id",
            d."planned_date_delayed_warehouse_out" AS "planned_date",
            d."updated_date",
            d."status_date",
            d."status_id",
            CASE
                WHEN d."status_id" = 'real_date_warehouse' AND
                CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP
                THEN 'delayed_warehouse_out'
                WHEN d."status_id" = 'real_date_init' AND
                CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP AND
                d."planned_date_delayed_warehouse" IS NULL
                THEN 'delayed_warehouse_out'
            END AS "state"
        FROM "final_sla_dates2" AS d
        WHERE (
                d."delivery_type_main" = 'delivery' OR
                d."delivery_type_main" = 'delivery_pickup'
            ) AND
            "customer_delivery_date" IS NOT NULL AND
            "state" IS NOT NULL AND
            "status_date" IS NOT NULL
        ORDER BY "planned_date" desc
    );

ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Malo byť vyskladnené --
CREATE TABLE if NOT EXISTS "fact_pickup" AS (
        SELECT
            DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
            d."delivery_id",
            d."planned_date_delayed_warehouse_out" AS "planned_date",
            d."updated_date",
            d."status_date",
            d."status_id",
            CASE
                WHEN d."status_id" = 'real_date_warehouse' AND
                CURRENT_TIMESTAMP:: TIMESTAMP > "planned_date":: TIMESTAMP
                THEN 'delayed_warehouse_out'
            END AS "state"
        FROM "final_sla_dates2" AS d
        WHERE
            d."delivery_type_main" = 'pickup_point' AND
            "customer_delivery_date" IS NOT NULL AND
            "state" IS NOT NULL AND
            "status_date" IS NOT NULL
        ORDER BY "planned_date" desc
    );

ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Malo byť doručené --
CREATE TABLE
    IF NOT EXISTS "fact_day_detail_pickup" AS (
        SELECT
            DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
            d."delivery_id",
            d."planned_date_delayed_pickup" AS "planned_date",
            d."updated_date",
            d."status_date",
            d."status_id",
            CASE
                WHEN d."status_id" = 'real_date_warehouse_out' AND
                CURRENT_TIMESTAMP:: DATE > "planned_date":: DATE
                THEN 'delayed_pickup'
            END AS "state"
        FROM "final_sla_dates2" AS d
        WHERE
            d."delivery_type_main" = 'pickup_point' AND
            "customer_delivery_date" IS NOT NULL AND
            "state" IS NOT NULL AND
            "status_date" IS NOT NULL
        ORDER BY "planned_date" desc
    )
UNION ALL
-- Doručené - načas/s meškaním -- (
    SELECT
        DISTINCT d."tracking_id" | | d."delivery_id" | | d."order_id" AS "id",
        d."delivery_id",
        d."planned_date_delayed_pickup" AS "planned_date",
        d."updated_date",
        d."status_date",
        d."status_id",
        CASE
            WHEN d."status_id" = 'real_date_pickup' AND
            "status_date":: DATE <= "planned_date":: DATE
            THEN 'delivered_pickup'
            WHEN d."status_id" = 'real_date_pickup' AND
            "status_date":: DATE > "planned_date":: DATE
            THEN 'delivered_pickup'
        END AS "state"
    FROM "final_sla_dates2" AS d
    WHERE
        d."delivery_type_main" = 'pickup_point' AND
        "customer_delivery_date" IS NOT NULL AND
        "state" IS NOT NULL AND
        "status_date" IS NOT NULL
    ORDER BY "planned_date" desc
);