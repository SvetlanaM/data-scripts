-- Find the first occurence of the SLA --
CREATE TABLE if NOT EXISTS "final_sla_dates" AS
SELECT
    DISTINCT first_value("real_date") OVER (
        PARTITION BY "delivery_id",
        "real_state",
        "order"
        ORDER BY
            "order":: number asc,
            "real_date" asc
    ) "real_date",
    first_value("status_created_date") OVER (
        PARTITION BY "delivery_id",
        "real_state",
        "order"
        ORDER BY
            "order":: number asc,
            "status_created_date" asc
    ) "status_created_date",
    first_value("real_state") OVER (
        PARTITION BY "delivery_id",
        "real_state",
        "order"
        ORDER BY
            "order":: number asc,
            "real_date" asc
    ) "real_state",
    first_value("real_state_cz") OVER (
        PARTITION BY "delivery_id",
        "real_state",
        "order"
        ORDER BY
            "order":: number asc,
            "real_date" asc
    ) "real_state_cz",
    "delivery_id",
    "is_active",
    "tracking_id",
    last_value("updated_date") OVER (
        PARTITION BY "delivery_id"
        ORDER BY
            "updated_date" asc
    ) "updated_date",
    first_value("status") OVER (
        PARTITION BY "delivery_id",
        "real_state",
        "order"
        ORDER BY
            "order":: number asc,
            "real_date" asc
    ) "status",
    first_value("order") OVER (
        PARTITION BY "delivery_id",
        "real_state",
        "order"
        ORDER BY
            "order":: number asc,
            "real_date" asc
    ) "order"
FROM "final_sla_dates1"
WHERE "real_date" IS NOT NULL
ORDER BY "order" desc;