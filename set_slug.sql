CREATE OR REPLACE FUNCTION public.set_slug_from_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."slug" := public.slugify(NEW.name);
  RETURN _new;
END;
$function$

CREATE OR REPLACE FUNCTION public.slug_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
      BEGIN
          NEW.slug := slugify(NEW.name);
          RETURN NEW;
      END;
  $function$
