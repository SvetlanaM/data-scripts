create table "final_sla_temp" as
select distinct
"delivery_id" as delivery_id,
"real_state" as real_state,
"real_date" as real_date,
"updated_date" as updated_date
from "final_sla_dates"
group by 1, 2, 3, 4
order by "delivery_id", "real_date" desc;

create table "final_sla_temp1" as
select distinct
"delivery_id" as delivery_id,
"real_state" as real_state,
"status_created_date" as status_created_date,
"updated_date" as updated_date
from "final_sla_dates"
group by 1, 2, 3, 4
order by "delivery_id", "status_created_date" desc;

create table "final_sla_transform" as 
select
delivery_id,
updated_date,
"'real_date_delivery'" as real_date_delivery, 
"'real_date_provider'" as real_date_provider, 
"'real_date_on_road'" as real_date_on_road, 
"'real_date_warehouse'" as real_date_warehouse,
"'real_date_warehouse_out'" as real_date_warehouse_out, 
"'real_date_pickup'" as real_date_pickup, 
"'real_date_storno'" as real_date_storno, 
"'real_date_init'" as real_date_init,
"'real_date_pay'" as real_date_pay
from "final_sla_temp"
    pivot(min(real_date) for real_state in (
      'real_date_delivery', 
      'real_date_provider',
      'real_date_on_road',
      'real_date_warehouse',
      'real_date_warehouse_out',
      'real_date_pickup',
      'real_date_storno',
      'real_date_init',
      'real_date_pay'
    )) 
      as p
      order by delivery_id;

create table "final_status_transform" as 
select
delivery_id,
updated_date,
"'real_date_delivery'" as real_date_delivery, 
"'real_date_provider'" as real_date_provider, 
"'real_date_on_road'" as real_date_on_road, 
"'real_date_warehouse'" as real_date_warehouse,
"'real_date_warehouse_out'" as real_date_warehouse_out, 
"'real_date_pickup'" as real_date_pickup, 
"'real_date_storno'" as real_date_storno, 
"'real_date_init'" as real_date_init,
"'real_date_pay'" as real_date_pay
from "final_sla_temp1"
    pivot(min(status_created_date) for real_state in (
      'real_date_delivery', 
      'real_date_provider',
      'real_date_on_road',
      'real_date_warehouse',
      'real_date_warehouse_out',
      'real_date_pickup',
      'real_date_storno',
      'real_date_init',
      'real_date_pay'
    )) 
      as p
      order by delivery_id;

create table if not exists "non_delivered_orders" as
select distinct n.*,
first_value("mapping_czech_title") over (partition by "tracking_id"
                                        order by "order"::number desc, "status_date" asc) 
    as "POSLEDNY_STAV",
first_value("status_date") over (partition by "tracking_id"
                                        order by "order"::number desc, "status_date" asc)
    as "POSLEDNY_DATUM"
from "non_delivered_cz" as n
left join "full_states_history3" as s
on s."tracking_id" = n."EXTERNI_IDENTIFIKACE_DODAVKY"
where n."ODBYTOVY_DOKLAD" not like '9%'
and "order" is not null;