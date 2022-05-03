CREATE TABLE IF NOT EXISTS "delivery_dimension" AS
SELECT
    DISTINCT d."order_id" | | d."feed_item_id" AS "uuid",
    d."delivery_id",
    d."is_active",
    d."tracking_id" AS "tracking_id",
    d."updated_date",
    o."customer_id" AS "customer_id",
    dm."delivery_provider_id" AS "delivery_provider_id",
    CASE
        WHEN (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        ) AND
        dm."title" IS NOT NULL
        THEN dp."title" | | ' ' | | dm."title" | | ' ' | | regexp_substr(s."name", '\\w\\w')
        WHEN dm."delivery_type" = 'delivery' OR
        dm."delivery_type" = 'delivery_pickup'
        THEN dp."title" | | ' ' | | regexp_substr(s."name", '\\w\\w')
        WHEN dm."delivery_type" = 'pickup_point'
        THEN ou."title"
        ELSE d."mapped_name"
    END AS "provider",
    CASE
        WHEN (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        ) AND
        dm."title" IS NOT NULL AND
        d."is_marketplace" = 1
        THEN d."mapped_name" | | ' ' | | regexp_substr(s."name", '\\w\\w')
        WHEN (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup' OR
            dm."delivery_type" = 'pickup_point'
        ) AND
        d."is_marketplace" = 1 AND
        dm."delivery_provider_id" IS NULL
        THEN d."mapped_name" | | ' ' | | regexp_substr(s."name", '\\w\\w')
        WHEN (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        ) AND
        d."is_marketplace" = 1
        THEN d."mapped_name" | | ' ' | | regexp_substr(s."name", '\\w\\w')
        WHEN dm."delivery_type" = 'pickup_point' AND
        d."is_marketplace" = 1
        THEN ou."title" | | ' - ' | | d."mapped_name"
        ELSE NULL
    END AS "partner_name",
    d."order_id" AS "order_id",
    d."last_customer_delivery_date" AS "customer_delivery_date",
    d."personal_pickup" AS "personal_pickup",
    dm."delivery_type" AS "delivery_type_main",
    d."tracking_partner_id" AS "tracking_partner_id",
    d."is_marketplace",
    o."purchase_date" AS "purchase_date",
    o."shop_id",
    d."feed_item_id",
    ou."title" AS "mallbox_address",
    d."is_same_day_delivery",
    CASE
        WHEN d."is_marketplace" = 1
        THEN 'Marketplace'
        WHEN dm."delivery_type" = 'delivery' OR
        dm."delivery_type" = 'delivery_pickup' OR
        dm."delivery_type" = 'pickup_point'
        THEN 'Mall'
        ELSE NULL
    END AS "type",
    d."delivery_type" AS "deliv_type",
    CASE
        WHEN d."is_same_day_delivery" = 1 AND (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        )
        THEN 0
        WHEN d."has_extra_service" = 1 AND
        d."is_same_day_delivery" = 0 AND
        dm."delivery_provider_id" != 26
        THEN 2
        WHEN d."has_extra_service" = 1 AND
        d."is_same_day_delivery" = 0 AND
        dm."delivery_provider_id" = 26
        THEN 1
        ELSE dp."sla_days_warehouse"
    END AS "sla_days_warehouse1",
    dp."sla_close_time_warehouse",
    CASE
        WHEN d."is_same_day_delivery" = 1 AND (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        )
        THEN 0
        ELSE dp."sla_days_provider"
    END AS "sla_days_provider1",
    dp."sla_close_time_provider",
    CASE
        WHEN d."is_same_day_delivery" = 1 AND (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        )
        THEN 0
        ELSE dp."sla_days_on_road"
    END AS "sla_days_on_road1",
    dp."sla_close_time_on_road",
    CASE
        WHEN (
            dm."delivery_type" = 'delivery' OR
            dm."delivery_type" = 'delivery_pickup'
        )
        THEN d."last_customer_delivery_date"
    END AS "planned_date_delayed",
    CASE
        WHEN d."has_extra_service" = 1
        THEN dateadd(DAY, -2, d."last_customer_delivery_date")
        WHEN d."is_same_day_delivery" = 0
        THEN dateadd(DAY, -1, d."last_customer_delivery_date")
        WHEN d."is_same_day_delivery" = 1
        THEN d."last_customer_delivery_date"
    END AS "planned_date_delayed_pay",
    CASE
        WHEN dm."delivery_type" = 'pickup_point'
        THEN d."last_customer_delivery_date"
        WHEN d."is_marketplace" = 1
        THEN d."last_customer_delivery_date"
    END AS "planned_date_delayed_pickup",
    dateadd(
        DAY,
        - "sla_days_provider1",
        d."last_customer_delivery_date":: DATE
    ) | | ' ' | | dp."sla_close_time_provider" AS "planned_date_delayed_provider",
    dateadd(
        DAY,
        - "sla_days_on_road1",
        d."last_customer_delivery_date":: DATE
    ) | | ' ' | | dp."sla_close_time_on_road" AS "planned_date_delayed_on_road",
    CASE
        WHEN pc.DELIVERY_CLOSE_TIME:: TIME > pc.DELIVERY_DISPATCH_TIME:: TIME
        THEN dateadd(DAY, -1, pc.DELIVERY_DISPATCH_DATE:: DATE) | | ' ' | | pc.DELIVERY_CLOSE_TIME:: TIME
        ELSE pc.DELIVERY_DISPATCH_DATE:: DATE | | ' ' | | pc.DELIVERY_CLOSE_TIME:: TIME
    END AS "planned_date_delayed_warehouse",
    d."has_extra_service",
    pc.DELIVERY_DISPATCH_DATE:: DATE | | ' ' | | pc.DELIVERY_DISPATCH_TIME:: TIME AS "planned_date_delayed_warehouse_out",
    d."changed_last_customer_delivery_date",
    d."is_paid",
    d."admin_payments",
    d."transport_id",
    iff(s9."status_id" = 19, 1, 0) AS "status_19",
    iff(s9."status_id" = 20, 1, 0) AS "status_20",
    iff(s9."status_id" = 20, s9."status_date", NULL) AS "status_20_date",
    CASE
        WHEN dm."delivery_provider_id" IN (26, 24)
        THEN 0
        WHEN d."is_marketplace" = 1 AND
        dm."delivery_provider_id" NOT IN (21) AND
        dm."delivery_type" NOT IN ('pickup_point')
        THEN 0
        WHEN d."admin_payments" IN (
            'Na fakturu',
            'Nákup na splátky',
            'Nákup na splátky - online',
            'Nákup na splátky - online, Darčekový certifikát',
            'Platba cez TatraPay',
            'Platba cez TatraPay, Darčekový certifikát',
            'Bankovním převodem',
            'Bežným prevodom',
            'Bankovým prevodom'
        )
        THEN 0
        ELSE 1
    END AS "is_active_sla"
FROM "delivery" AS d
    INNER JOIN "order" AS o
    ON d."order_id" = o."order_id"
    LEFT JOIN "delivery_method" AS dm
    ON dm."id" = d."delivery_method_id"
    LEFT JOIN "delivery_provider" AS dp
    ON dp."delivery_provider_id" = dm."delivery_provider_id"
    LEFT JOIN "shop" AS s
    ON s."shop_id" = o."shop_id"
    LEFT JOIN "outlet" AS ou
    ON d."outlet_id" = ou."id"
    LEFT JOIN "purchase_cart" AS pc
    ON pc.ORDER_ID:: number | | pc.DELIVERY_LAST_CUSTOMER_DELIVERY_DATE:: DATE | | pc.DELIVERY_TS_TRANSPORT_ID:: number = d."order_id":: number | | d."last_customer_delivery_date":: DATE | | d."transport_id":: number
    LEFT JOIN "status_19" AS s9
    ON s9."tracking_id" = d."tracking_id"
WHERE
    "uuid" IS NOT NULL AND
    d."last_customer_delivery_date" IS NOT NULL
ORDER BY "order_id";