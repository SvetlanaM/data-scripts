CREATE
OR REPLACE VIEW "public"."brand_fav_type" AS
SELECT
  max(x.number_of_reviews) AS number_of_reviews,
  x.brand_type,
  max(x.max_review) AS max_review
FROM
  (
    SELECT
      count(p.brand_type) AS number_of_reviews,
      max(r.review_type) AS max_review,
      p.brand_type
    FROM
      (
        (
          (
            "Product" p
            JOIN "Review" r ON ((r.product_id = p.id))
          )
          JOIN "Cat" c ON ((c.id = r.cat_id))
        )
        JOIN "User" u ON ((u.id = c.user_id))
      )
    GROUP BY
      p.brand_type
  ) x
GROUP BY
  x.brand_type
ORDER BY
  (max(x.max_review)) DESC,
  (max(x.number_of_reviews)) DESC;
