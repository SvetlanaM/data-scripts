CREATE
OR REPLACE VIEW "public"."brand_mine_type" AS
SELECT
  DISTINCT max(x.number_of_reviews) AS number_of_reviews,
  x.brand_type,
  max(x.max_review) AS max_review,
  x.user_id
FROM
  (
    SELECT
      count(p.brand_type) AS number_of_reviews,
      max(r.review_type) AS max_review,
      p.brand_type,
      c.user_id
    FROM
      (
        (
          "Product" p
          JOIN "Review" r ON ((r.product_id = p.id))
        )
        JOIN "Cat" c ON ((c.id = r.cat_id))
      )
    GROUP BY
      p.brand_type,
      c.user_id
  ) x
GROUP BY
  x.brand_type,
  x.user_id
ORDER BY
  x.user_id,
  (max(x.max_review)) DESC,
  (max(x.number_of_reviews)) DESC;
