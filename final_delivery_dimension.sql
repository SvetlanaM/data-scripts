ALTER session
SET timestamp_type_mapping = 'TIMESTAMP_TZ';

ALTER session
SET timezone = 'Europe/Prague';

ALTER session
SET
    timestamp_output_format = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Join delivery dimension with SLA calculations --
CREATE TABLE IF NOT EXISTS "connect" AS
SELECT
    DISTINCT d."tracking_id" | | f."delivery_id" | | d."order_id" AS "id",
    d."feed_item_id",
    d."purchase_date",
    d."type",
    d."personal_pickup",
    d."uuid",
    d."delivery_type_main",
    d."planned_date_delayed",
    d."planned_date_delayed_pay",
    d."planned_date_delayed_pickup",
    d."planned_date_delayed_provider",
    d."planned_date_delayed_on_road",
    d."planned_date_delayed_warehouse",
    d."planned_date_delayed_warehouse_out",
    d."customer_delivery_date",
    d."customer_id",
    d."tracking_id",
    d."provider",
    d."delivery_provider_id",
    d."order_id",
    d."shop_id",
    d."is_active",
    d."tracking_partner_id",
    d."partner_name",
    d."status_19",
    d."status_20",
    d."status_20_date",
    d."is_same_day_delivery",
    d."mallbox_address",
    d."admin_payments",
    d."changed_last_customer_delivery_date",
    d."delivery_id" AS "del_id",
    d."deliv_type",
    d."updated_date",
    d."is_active_sla",
    iff(c."export_date" IS NOT NULL, c."export_date", NULL) AS "export_date",
    iff(
        c."export_date_delivery" IS NOT NULL,
        c."export_date_delivery",
        NULL
    ) AS "export_date_delivery",
    iff(
        c."export_date_on_road" IS NOT NULL,
        c."export_date_on_road",
        NULL
    ) AS "export_date_on_road",
    iff(
        c."messaged_date" IS NOT NULL,
        c."messaged_date",
        NULL
    ) AS "messaged_date",
    iff(
        c."message_failed_date" IS NOT NULL,
        c."message_failed_date",
        NULL
    ) AS "message_failed_date",
    CURRENT_TIMESTAMP:: datetime AS "updated_at",
    f.*,
    d."planned_date_delayed_warehouse":: TIMESTAMP < t.REAL_DATE_WAREHOUSE:: TIMESTAMP AS "delayed_warehouse_history",
    d."planned_date_delayed_warehouse_out":: TIMESTAMP < t.REAL_DATE_WAREHOUSE_OUT:: TIMESTAMP AS "delayed_warehouse_out_history",
    d."planned_date_delayed_provider":: TIMESTAMP < t.REAL_DATE_PROVIDER:: TIMESTAMP AS "delayed_provider_history",
    d."planned_date_delayed_on_road":: TIMESTAMP < t.REAL_DATE_ON_ROAD:: TIMESTAMP AS "delayed_on_road_history",
    d."customer_delivery_date":: DATE < t.REAL_DATE_DELIVERY:: DATE OR
    d."customer_delivery_date":: DATE < t.REAL_DATE_PICKUP:: DATE AS "delayed_delivery_history",
    d."planned_date_delayed_pay":: TIMESTAMP < t.REAL_DATE_PAY:: TIMESTAMP AS "delayed_pay_history",
    t.REAL_DATE_WAREHOUSE:: TIMESTAMP AS "real_date_warehouse",
    t.REAL_DATE_STORNO:: TIMESTAMP AS "real_date_storno",
    t.REAL_DATE_WAREHOUSE_OUT:: TIMESTAMP AS "real_date_warehouse_out",
    t.REAL_DATE_PROVIDER:: TIMESTAMP AS "real_date_provider",
    t.REAL_DATE_ON_ROAD:: TIMESTAMP AS "real_date_on_road",
    t.REAL_DATE_DELIVERY:: TIMESTAMP AS "real_date_delivery",
    t.REAL_DATE_PICKUP:: TIMESTAMP AS "real_date_pickup",
    t.REAL_DATE_INIT:: TIMESTAMP AS "real_date_init",
    t.REAL_DATE_PAY:: TIMESTAMP AS "real_date_pay",
    CASE
        WHEN f."status_id" NOT IN (
            'real_date_delivery',
            'real_date_storno',
            'real_date_pickup'
        ) AND
        d."customer_delivery_date":: DATE < CURRENT_DATE:: DATE
        THEN 1
        ELSE 0
    END AS "delayed_total",
    CASE
        WHEN "real_date_warehouse" IS NULL AND
        "real_date_storno" IS NULL AND
        "real_date_warehouse_out" IS NULL AND
        "real_date_provider" IS NULL AND
        "real_date_on_road" IS NULL AND
        "real_date_delivery" IS NULL AND
        "real_date_pickup" IS NULL
        THEN d."is_paid"
        ELSE 1
    END AS "is_paid",
    iff (
        d."changed_last_customer_delivery_date" IS NOT NULL AND
        f."status_id" NOT IN (
            'real_date_delivery',
            'real_date_storno',
            'real_date_pickup'
        ),
        1,
        0
    ) AS "changed_date",
    CASE
        WHEN "real_date_storno" IS NOT NULL
        THEN "real_date_storno"
        WHEN "real_date_delivery" IS NOT NULL
        THEN "real_date_delivery"
        WHEN "real_date_pickup" IS NOT NULL
        THEN "real_date_pickup"
    END AS "real_delivery_date",
    CASE
        WHEN "real_date_warehouse" IS NOT NULL AND
        "real_date_storno" IS NULL AND
        "real_date_warehouse_out" IS NULL AND
        "real_date_provider" IS NULL AND
        "real_date_on_road" IS NULL AND
        "real_date_delivery" IS NULL AND
        "real_date_pickup" IS NULL
        THEN 'Na skladě'
        WHEN "real_date_warehouse_out" IS NOT NULL AND
        "real_date_storno" IS NULL AND
        "real_date_provider" IS NULL AND
        "real_date_on_road" IS NULL AND
        "real_date_delivery" IS NULL AND
        "real_date_pickup" IS NULL
        THEN 'Vyskladněno'
        WHEN "real_date_provider" IS NOT NULL AND
        "real_date_storno" IS NULL AND
        "real_date_on_road" IS NULL AND
        "real_date_delivery" IS NULL AND
        "real_date_pickup" IS NULL
        THEN 'U dopravce'
        WHEN "real_date_storno" IS NOT NULL
        THEN 'Storno'
        WHEN "real_date_on_road" IS NOT NULL AND
        "real_date_storno" IS NULL AND
        "real_date_delivery" IS NULL AND
        "real_date_pickup" IS NULL
        THEN 'Na cestě'
        WHEN "real_date_delivery" IS NOT NULL AND
        "real_date_storno" IS NULL
        THEN 'Doručeno'
        WHEN "real_date_pickup" IS NOT NULL AND
        "real_date_storno" IS NULL
        THEN 'Doručeno'
        ELSE ''
    END AS "state_cz",
    CASE
        WHEN f."status_id" IN ('real_date_init') AND
        d."is_same_day_delivery" = 1 AND
        d."is_paid" = 1
        THEN d."planned_date_delayed_warehouse":: DATE
        WHEN f."status_id" IN ('real_date_init') AND
        d."is_paid" = 0
        THEN d."planned_date_delayed_pay":: DATE
        WHEN f."status_id" IN ('real_date_init') AND
        d."is_same_day_delivery" = 0 AND
        d."is_paid" = 1
        THEN dateadd(DAY, 1, d."planned_date_delayed_warehouse":: DATE)
        WHEN f."status_id" IN ('real_date_init') AND
        d."is_same_day_delivery" IS NULL AND
        d."is_paid" = 1
        THEN dateadd(DAY, 1, d."planned_date_delayed_warehouse":: DATE)
        WHEN f."status_id" IN ('real_date_warehouse') AND
        d."is_same_day_delivery" = 1
        THEN d."planned_date_delayed_warehouse_out":: DATE
        WHEN f."status_id" IN ('real_date_warehouse') AND
        d."is_same_day_delivery" = 0
        THEN dateadd(
            DAY,
            1,
            d."planned_date_delayed_warehouse_out":: DATE
        )
        WHEN f."status_id" IN ('real_date_warehouse') AND
        d."is_same_day_delivery" IS NULL
        THEN dateadd(
            DAY,
            1,
            d."planned_date_delayed_warehouse_out":: DATE
        )
        WHEN f."status_id" IN ('real_date_warehouse_out') AND (
            d."delivery_type_main" = 'delivery' OR
            d."delivery_type_main" = 'delivery_pickup'
        )
        THEN d."planned_date_delayed_provider"
        WHEN f."status_id" IN ('real_date_provider') AND (
            d."delivery_type_main" = 'delivery' OR
            d."delivery_type_main" = 'delivery_pickup'
        )
        THEN d."planned_date_delayed_on_road"
        WHEN f."status_id" IN ('real_date_on_road') AND (
            d."delivery_type_main" = 'delivery' OR
            d."delivery_type_main" = 'delivery_pickup'
        )
        THEN d."customer_delivery_date"
        WHEN f."status_id" IN ('real_date_warehouse_out') AND (
            d."delivery_type_main" = 'delivery' OR
            d."delivery_type_main" = 'delivery_pickup'
        )
        THEN d."customer_delivery_date"
        WHEN f."status_id" IN ('real_date_warehouse_out') AND
        d."delivery_type_main" = 'pickup_point'
        THEN d."customer_delivery_date"
        WHEN f."status_id" IN (
            'real_date_delivery',
            'real_date_storno',
            'real_date_pickup'
        )
        THEN "real_delivery_date"
    END AS "new_date",
    CASE
        WHEN "real_date_delivery" IS NOT NULL AND
        "real_date_delivery":: DATE > d."customer_delivery_date":: DATE AND
        "real_date_storno" IS NULL
        THEN 1
    END AS "delivered_delayed",
    CASE
        WHEN "real_date_pickup" IS NOT NULL AND
        "real_date_pickup":: DATE > d."customer_delivery_date":: DATE AND
        "real_date_storno" IS NULL
        THEN 1
    END AS "delivered_delayed_pickup",
    c1."is_closed" AS "is_closed_pickup"
FROM "final_sla_dates2" AS d
    INNER JOIN "final_sla_transform" AS t
    ON t.DELIVERY_ID = d."delivery_id"
    FULL JOIN "fact_provider" AS f
    ON d."delivery_id" = f."delivery_id"
    LEFT JOIN "export_dates" AS c
    ON c."delivery_id" = d."delivery_id"
    LEFT JOIN "pickups" AS c1
    ON c1."provider" = d."provider"
WHERE
    d."customer_delivery_date" IS NOT NULL AND
    d."order_id" NOT LIKE '9%';