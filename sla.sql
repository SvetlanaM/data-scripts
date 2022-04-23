-- Find the first occurence of the SLA --
create table if not exists "final_sla_dates" as
select distinct
    first_value("real_date") over (partition by "delivery_id", "real_state", "order" order by "order"::number asc, "real_date" asc) as "real_date",
    first_value("status_created_date") over (partition by "delivery_id", "real_state", "order" order by "order"::number asc, "status_created_date" asc) as "status_created_date",
    first_value("real_state") over (partition by "delivery_id", "real_state", "order" order by "order"::number asc, "real_date" asc) as "real_state",
    first_value("real_state_cz") over (partition by "delivery_id", "real_state", "order" order by "order"::number asc, "real_date" asc) as "real_state_cz",
    "delivery_id",
    "is_active",
    "tracking_id",
    last_value("updated_date") over (partition by "delivery_id" order by "updated_date" asc) as "updated_date",
    first_value("status") over (partition by "delivery_id", "real_state", "order" order by "order"::number asc, "real_date" asc) as "status",
    first_value("order") over (partition by "delivery_id", "real_state", "order" order by "order"::number asc, "real_date" asc) as "order"
from "final_sla_dates1"
where "real_date" is not null
order by "order" desc;