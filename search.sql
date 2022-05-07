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
