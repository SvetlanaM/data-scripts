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
