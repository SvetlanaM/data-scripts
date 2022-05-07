CREATE
OR REPLACE VIEW "public"."user_stats" AS
SELECT
  count(DISTINCT r.id) AS count_of_reviews,
  count(DISTINCT c.id) AS count_of_cats,
  round(avg((r.review_type) :: integer), 2) AS avg_review,
  u.interacted_count,
  u.id
FROM
  (
    (
      "User" u
      RIGHT JOIN "Cat" c ON ((c.user_id = u.id))
    )
    LEFT JOIN "Review" r ON ((r.cat_id = c.id))
  )
GROUP BY
  u.id,
  u.interacted_count;
