CREATE OR REPLACE FUNCTION public.set_current_timestamp_slug()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."slug" = NOW();
  RETURN _new;
END;
$function$
