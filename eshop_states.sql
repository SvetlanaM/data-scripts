CREATE TABLE IF NOT EXISTS "last_tracking_state" AS
SELECT
    DISTINCT "lt"."delivery_id",
    "lt"."date",
    "lt"."title",
    "d"."updated_date",
    "lt"."code",
    "d"."personal_pickup",
    "d"."tracking_id",
    "d"."is_active",
    "d"."is_paid"
FROM "delivery" AS "d"
    INNER JOIN "delivery_tracking" AS "lt"
    ON "d"."delivery_id" = "lt"."delivery_id";