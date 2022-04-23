create table if not exists "final_sla_dates2" as
select 
last_value("real_state") over (partition by s."delivery_id" order by "order"::number asc) as "status_id",
last_value("real_date") over (partition by s."delivery_id" order by "order"::number asc, "real_date"::date desc) as "status_date",
d.*
from "final_sla_dates" as s
inner join "delivery_dimension" as d
on s."delivery_id" = d."delivery_id"
where 
    (
      "planned_date_delayed"::date = current_date::date
      or "planned_date_delayed"::date = dateadd(day, -1, current_date::date)
    ) 
    or (
      "planned_date_delayed_pickup"::date = current_date::date
      or "planned_date_delayed_pickup"::date = dateadd(day, -1, current_date::date)
    ) 
    or (
      "planned_date_delayed_provider"::date = current_date::date
      or "planned_date_delayed_provider"::date = dateadd(day, -1, current_date::date)
     ) 
     or (
       "planned_date_delayed_on_road"::date = current_date::date
       or "planned_date_delayed_on_road"::date = dateadd(day, -1, current_date::date)
     ) 
     or (
       "planned_date_delayed_warehouse"::date = current_date::date
       or "planned_date_delayed_warehouse"::date = dateadd(day, -1, current_date::date)
     ) 
     or (
       "planned_date_delayed_warehouse_out"::date = current_date::date
       or "planned_date_delayed_warehouse_out"::date = dateadd(day, -1, current_date::date)
       ) 
     or (
       "planned_date_delayed_pay"::date = current_date::date
       or "planned_date_delayed_pay"::date = dateadd(day, -1, current_date::date)
       ) 
     or (
         s."real_date"::date between dateadd(day, -61, current_date::date) and  current_date::date
      );