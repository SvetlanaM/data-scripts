CREATE OR REPLACE FUNCTION public.search_articles(brand_type text)
 RETURNS SETOF "Product"
 LANGUAGE sql
 STABLE
AS $function$
    SELECT *
    FROM "Product"
    WHERE
      brand_type = 'Applaws'
$function$

CREATE OR REPLACE FUNCTION public.search_articles1(brand_type text)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
    SELECT count(brand_type)
    FROM "Product" as p
    join "Review" as r
    on r."product_id" = p."id"
    group by r."review_type"
    order by r."review_type" desc
$function$
