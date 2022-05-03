CREATE TABLE
    IF NOT EXISTS "provider_history" AS -- Ceska Posta --
SELECT
    p."delivery_provider_ceskaposta_history_id" | | 'ceska_posta' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_name" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'ceska_posta' AS "provider",
    9 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_ceskaposta_history" AS p
    INNER JOIN "delivery_provider_ceskaposta_status" AS s
    ON s."id" = p."delivery_provider_ceskaposta_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- DPD --
SELECT
    p."delivery_provider_dpd_history_id" | | 'dpd' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."last_scan_text" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'dpd' AS "provider",
    10 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_dpd_history" AS p
    INNER JOIN "delivery_provider_dpd_status" AS s
    ON s."id" = p."delivery_provider_dpd_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- GW --
SELECT
    p."delivery_provider_gebruder_weiss_history_id" | | 'gebruder_weiss' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_name" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'gebruder_weiss' AS "provider",
    4 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM
    "delivery_provider_gebruder_weiss_history" AS p
    INNER JOIN "delivery_provider_gebruder_weiss_status" AS s
    ON s."id" = p."delivery_provider_gebruder_weiss_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Geis --
SELECT
    p."delivery_provider_geis_history_id" | | 'geis' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'geis' AS "provider",
    3 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_geis_history" AS p
    INNER JOIN "delivery_provider_geis_status" AS s
    ON s."id" = p."delivery_provider_geis_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- In Time --
SELECT
    p."delivery_provider_in_time_history_id" | | 'intime' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'intime' AS "provider",
    7 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_intime_history" AS p
    INNER JOIN "delivery_provider_intime_status" AS s
    ON s."id" = p."status"
WHERE "status_id" IS NOT NULL
UNION
-- MallBox --
SELECT
    p."delivery_provider_mallbox_history_id" | | 'mallbox' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'mallbox' AS "provider",
    21 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_mallbox_history" AS p
    INNER JOIN "delivery_provider_mallbox_status" AS s
    ON s."id" = p."delivery_provider_mallbox_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- PPL --
SELECT
    p."delivery_provider_ppl_history_id" | | 'ppl' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_name" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'ppl' AS "provider",
    1 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_ppl_history" AS p
    INNER JOIN "delivery_provider_ppl_status" AS s
    ON s."id" = p."delivery_provider_ppl_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Raben --
SELECT
    p."delivery_provider_raben_history_id" | | 'raben' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."title" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'raben' AS "provider",
    8 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_raben_history" AS p
    INNER JOIN "delivery_provider_raben_status" AS s
    ON s."id" = p."delivery_provider_raben_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Top Trans --
SELECT
    p."delivery_provider_toptrans_history_id" | | 'toptrans' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_message" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'toptrans' AS "provider",
    6 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_toptrans_history" AS p
    INNER JOIN "delivery_provider_toptrans_status" AS s
    ON s."id" = p."delivery_provider_toptrans_status_code"
WHERE "status_id" IS NOT NULL
UNION
-- Ulozenka --
SELECT
    DISTINCT p."tracking_id" | | p."status_date" | | s."delivery_mapping_id" AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."delivery_status" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'ulozenka' AS "provider",
    2 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_ulozenka_history" AS p
    INNER JOIN "delivery_provider_ulozenka_status" AS s
    ON s."id" = p."delivery_provider_ulozenka_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- ZVK --
SELECT
    p."delivery_provider_zavolejsikuryra_history_id" | | 'zavolejsikuryra' AS "id",
    p."created_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."delivery_status_text" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'zavolejsikuryra' AS "provider",
    5 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM
    "delivery_provider_zavolejsikuryra_history" AS p
    INNER JOIN "delivery_provider_zavolejsikuryra_status" AS s
    ON s."id" = p."delivery_provider_zavolejsikuryra_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Speedy --
SELECT
    p."id" | | 'speedy' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'speedy' AS "provider",
    29 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_speedy_history" AS p
    INNER JOIN "delivery_provider_speedy_status" AS s
    ON s."id" = p."delivery_provider_speedy_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Zasilkovna --
SELECT
    p."id" | | 'zasilkovna_cz' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."code_text" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'zasilkovna_cz' AS "provider",
    34 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_packetery_history" AS p
    INNER JOIN "delivery_provider_packetery_status" AS s
    ON s."id" = p."delivery_provider_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Helicar --
SELECT
    p."id" | | 'helicar_cz' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'helicar_cz' AS "provider",
    28 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_helicar_history" AS p
    INNER JOIN "delivery_provider_helicar_status" AS s
    ON s."id" = p."delivery_provider_helicar_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Liftago --
SELECT
    p."id" | | 'liftago_cz' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'liftago_cz' AS "provider",
    37 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_liftago_history" AS p
    INNER JOIN "delivery_provider_liftago_status" AS s
    ON s."id" = p."delivery_provider_status_id"
WHERE "status_id" IS NOT NULL;

CREATE TABLE
    IF NOT EXISTS "provider_history_sk" AS -- DPD --
SELECT
    p."delivery_provider_dpd_sk_history_id" | | 'dpd_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'dpd_sk' AS "provider",
    13 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_dpd_sk_history" AS p
    INNER JOIN "delivery_provider_dpd_sk_status" AS s
    ON s."id" = p."delivery_provider_dpd_sk_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- GW --
SELECT
    p."delivery_provider_gebruder_weiss_history_id" | | 'gebruder_weiss_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_name" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'gebruder_weiss_sk' AS "provider",
    19 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM
    "delivery_provider_gebruder_weiss_sk_history" AS p
    INNER JOIN "delivery_provider_gebruder_weiss_sk_status" AS s
    ON s."id" = p."delivery_provider_gebruder_weiss_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- MallBox --
SELECT
    p."delivery_provider_mallbox_history_id" | | 'mallbox_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'mallbox_sk' AS "provider",
    25 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_mallbox_sk_history" AS p
    INNER JOIN "delivery_provider_mallbox_sk_status" AS s
    ON s."id" = p."delivery_provider_mallbox_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Slovenská Pošta --
SELECT
    p."delivery_provider_slovenska_posta_history_id" | | 'slovenska_posta_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'slovenska_posta_sk' AS "provider",
    12 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM
    "delivery_provider_slovenska_posta_history" AS p
    INNER JOIN "delivery_provider_slovenska_posta_status" AS s
    ON s."id" = p."delivery_provider_slovenska_posta_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- TopTrans --
SELECT
    p."delivery_provider_top_trans_skhistory_id" | | 'toptrans_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_message" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'toptrans_sk' AS "provider",
    18 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_toptrans_sk_history" AS p
    INNER JOIN "delivery_provider_toptrans_sk_status" AS s
    ON s."id" = p."delivery_provider_toptrans_sk_status_code"
WHERE "status_id" IS NOT NULL
UNION
-- Uloženka --
SELECT
    DISTINCT p."tracking_id" | | p."status_date" | | s."delivery_mapping_id" AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."delivery_status" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'ulozenka_sk' AS "provider",
    25 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_ulozenka_sk_history" AS p
    INNER JOIN "delivery_provider_ulozenka_sk_status" AS s
    ON s."id" = p."delivery_provider_ulozenka_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Zasilkovna --
SELECT
    p."id" | | 'zasilkovna_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."code_text" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'zasilkovna_sk' AS "provider",
    35 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_packetery_sk_history" AS p
    INNER JOIN "delivery_provider_packetery_sk_status" AS s
    ON s."id" = p."delivery_provider_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Liftago --
SELECT
    p."id" | | 'liftago_sk' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'liftago_sk' AS "provider",
    38 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_liftago_sk_history" AS p
    INNER JOIN "delivery_provider_liftago_sk_status" AS s
    ON s."id" = p."delivery_provider_status_id"
WHERE "status_id" IS NOT NULL;

CREATE TABLE
    IF NOT EXISTS "provider_history_hr" AS -- DPD -- (
SELECT
    p."delivery_provider_dpd_hr_history_id" | | 'dpd_hr' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'dpd_hr' AS "provider",
    14 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_dpd_hr_history" AS p
    INNER JOIN "delivery_provider_dpd_hr_status" AS s
    ON s."id" = p."delivery_provider_dpd_hr_status_id"
WHERE "status_id" IS NOT NULL
)
UNION ALL (
    SELECT
        p."delivery_provider_gebruder_weiss_history_id" | | 'gw_hr' AS "id",
        p."status_date" AS "status_date",
        p."created_date" AS "status_created_date",
        s."status_name" AS "status_name",
        s."delivery_mapping_id" AS "status_id",
        p."tracking_id" AS "tracking_id",
        s."admin_mapping_id",
        'gw_hr' AS "provider",
        27 AS "provider_id",
        p."updated_date" AS "updated_date"
    FROM
        "delivery_provider_gebruder_weiss_hr_history" AS p
        INNER JOIN "delivery_provider_gebruder_weiss_hr_status" AS s
        ON s."id" = p."delivery_provider_gebruder_weiss_status_id"
    WHERE "status_id" IS NOT NULL
)
UNION ALL (
    SELECT
        p."id" | | 'dhl_hr' AS "id",
        p."status_date" AS "status_date",
        p."created_date" AS "status_created_date",
        s."title" AS "status_name",
        s."delivery_mapping_id" AS "status_id",
        p."tracking_id" AS "tracking_id",
        s."admin_mapping_id",
        'dhl_hr' AS "provider",
        30 AS "provider_id",
        p."updated_date" AS "updated_date"
    FROM "delivery_provider_dhl_hr_history" AS p
        INNER JOIN "delivery_provider_dhl_hr_status" AS s
        ON s."id" = p."delivery_provider_dhl_hr_status_id"
    WHERE "status_id" IS NOT NULL
);

CREATE TABLE
    IF NOT EXISTS "provider_history_hu" AS -- DPD --
SELECT
    p."delivery_provider_dpd_hu_history_id" | | 'dpd_hu' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'dpd_hu' AS "provider",
    16 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_dpd_hu_history" AS p
    INNER JOIN "delivery_provider_dpd_hu_status" AS s
    ON s."id" = p."delivery_provider_dpd_hu_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- GW --
SELECT
    p."delivery_provider_gebruder_weiss_history_id" | | 'gebruder_weiss_hu' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."status_name" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'gebruder_weiss_hu' AS "provider",
    20 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM
    "delivery_provider_gebruder_weiss_hu_history" AS p
    INNER JOIN "delivery_provider_gebruder_weiss_hu_status" AS s
    ON s."id" = p."delivery_provider_gebruder_weiss_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Zasilkovna --
SELECT
    p."id" | | 'zasilkovna_hu' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."code_text" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'zasilkovna_hu' AS "provider",
    36 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_packetery_hu_history" AS p
    INNER JOIN "delivery_provider_packetery_hu_status" AS s
    ON s."id" = p."delivery_provider_status_id"
WHERE "status_id" IS NOT NULL;

CREATE TABLE
    IF NOT EXISTS "provider_history_pl" AS -- DHL --
SELECT
    p."delivery_provider_dhl_history_id" | | 'dhl_pl' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'dhl_pl' AS "provider",
    11 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_dhl_history" AS p
    INNER JOIN "delivery_provider_dhl_status" AS s
    ON s."id" = p."delivery_provider_dhl_status_id"
WHERE "status_id" IS NOT NULL;

CREATE TABLE
    IF NOT EXISTS "provider_history_si" AS -- DPD --
SELECT
    p."delivery_provider_dpd_si_history_id" | | 'dpd_si' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'dpd_si' AS "provider",
    15 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM "delivery_provider_dpd_si_history" AS p
    INNER JOIN "delivery_provider_dpd_si_status" AS s
    ON s."id" = p."delivery_provider_dpd_si_status_id"
WHERE "status_id" IS NOT NULL
UNION
-- Pošta Slovenije --
SELECT
    p."delivery_provider_posta_slovenije_history_id" | | 'posta_slovenije' AS "id",
    p."status_date" AS "status_date",
    p."created_date" AS "status_created_date",
    s."long_description" AS "status_name",
    s."delivery_mapping_id" AS "status_id",
    p."tracking_id" AS "tracking_id",
    s."admin_mapping_id",
    'posta_slovenije' AS "provider",
    17 AS "provider_id",
    p."updated_date" AS "updated_date"
FROM
    "delivery_provider_posta_slovenije_history" AS p
    INNER JOIN "delivery_provider_posta_slovenije_status" AS s
    ON s."id" = p."delivery_provider_posta_slovenije_status_id"
WHERE "status_id" IS NOT NULL;