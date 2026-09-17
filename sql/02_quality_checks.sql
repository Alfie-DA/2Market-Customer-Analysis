-- Run these checks before the analytical queries.

-- Expected row counts.
SELECT 'marketing_data' AS table_name, COUNT(*) AS row_count FROM marketing_data
UNION ALL
SELECT 'ad_data', COUNT(*) FROM ad_data;

-- Duplicate customer IDs. Both queries should return zero rows.
SELECT id, COUNT(*) AS occurrences
FROM marketing_data
GROUP BY id
HAVING COUNT(*) > 1;

SELECT id, COUNT(*) AS occurrences
FROM ad_data
GROUP BY id
HAVING COUNT(*) > 1;

-- Customers missing from either table.
SELECT
    COALESCE(m.id, a.id) AS id,
    CASE
        WHEN m.id IS NULL THEN 'Missing from marketing_data'
        WHEN a.id IS NULL THEN 'Missing from ad_data'
    END AS issue
FROM marketing_data m
FULL OUTER JOIN ad_data a USING (id)
WHERE m.id IS NULL OR a.id IS NULL;

-- Invalid binary values. Expected result: zero rows.
SELECT *
FROM ad_data
WHERE bulkmail_ad NOT IN (0, 1)
   OR twitter_ad NOT IN (0, 1)
   OR instagram_ad NOT IN (0, 1)
   OR facebook_ad NOT IN (0, 1)
   OR brochure_ad NOT IN (0, 1);

-- Birth years requiring review. Three records are expected in the supplied data.
SELECT id, year_birth
FROM marketing_data
WHERE year_birth < 1940 OR year_birth > 2005
ORDER BY year_birth;

-- Reconcile the supplied successful-conversion count to all five channels.
SELECT m.id, m.count_success,
       a.bulkmail_ad + a.twitter_ad + a.instagram_ad
       + a.facebook_ad + a.brochure_ad AS calculated_successes
FROM marketing_data m
JOIN ad_data a USING (id)
WHERE m.count_success <>
      a.bulkmail_ad + a.twitter_ad + a.instagram_ad
      + a.facebook_ad + a.brochure_ad;

-- Confirm that the join remains one row per customer.
SELECT
    (SELECT COUNT(*) FROM marketing_data) AS marketing_rows,
    (SELECT COUNT(*) FROM ad_data) AS advertising_rows,
    (SELECT COUNT(*) FROM marketing_data m JOIN ad_data a USING (id)) AS joined_rows;

