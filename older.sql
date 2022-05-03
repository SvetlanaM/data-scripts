CREATE TABLE if NOT EXISTS "final_sla_dates2" AS
SELECT
    last_value("real_state") OVER (
        PARTITION BY s."delivery_id"
        ORDER BY
            "order":: number asc
    ) "status_id",
    last_value("real_date") OVER (
        PARTITION BY s."delivery_id"
        ORDER BY
            "order":: number asc,
            "real_date":: DATE desc
    ) "status_date",
    d.*
FROM "final_sla_dates" AS s
    INNER JOIN "delivery_dimension" AS d
    ON s."delivery_id" = d."delivery_id"
WHERE (
        "planned_date_delayed":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        "planned_date_delayed_pickup":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed_pickup":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        "planned_date_delayed_provider":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed_provider":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        "planned_date_delayed_on_road":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed_on_road":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        "planned_date_delayed_warehouse":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed_warehouse":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        "planned_date_delayed_warehouse_out":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed_warehouse_out":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        "planned_date_delayed_pay":: DATE = CURRENT_DATE:: DATE OR
        "planned_date_delayed_pay":: DATE = dateadd(DAY, -1, CURRENT_DATE:: DATE)
    ) OR (
        s."real_date":: DATE BETWEEN dateadd(DAY, -61, CURRENT_DATE:: DATE) AND
        CURRENT_DATE:: DATE
    );