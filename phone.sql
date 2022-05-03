CREATE TABLE if NOT EXISTS "daktela_orders" AS
SELECT
    DISTINCT "order_id",
    "tracking_id",
    c."shipping_phone" AS "phone_number",
    "purchase_date",
    "status_date" AS "provider_date",
    "provider",
    s."title",
    IFF("deliv_type" = 'ZST', 'zdarma', 'platena') AS "delivery_type",
    "state_cz" AS "delivery_state",
    first_value("status_date") OVER (
        PARTITION BY "tracking_id",
        "status_date"
        ORDER BY
            "status_date":: DATE asc
    ) "delivery_state_date",
    "personal_pickup",
    "type"
FROM "connect" AS d
    INNER JOIN "delivery_service" AS s
    ON s."delivery_id" = d."del_id"
    INNER JOIN "customer" AS c
    ON c."customer_id" = d."customer_id"
WHERE
    "provider_date" IS NOT NULL AND
    "delivery_state" != '' AND
    "state_cz" IN ('Doručeno', 'Storno') AND
    "personal_pickup" = 0 AND
    "delivery_provider_id" NOT IN (2, 25, 26) AND
    "tracking_id" IS NOT NULL AND
    "phone_number" IS NOT NULL
ORDER BY d."order_id";