-- Core analysis queries for the 2Market portfolio case study.

CREATE OR REPLACE VIEW customer_metrics AS
SELECT
    m.*,
    CASE
        WHEN year_birth BETWEEN 1940 AND 2005 THEN 2025 - year_birth
        ELSE NULL
    END AS age_at_2025,
    amt_liq + amt_vege + amt_nonveg
        + amt_pes + amt_chocolates + amt_comm AS total_sales
FROM marketing_data m;

-- Customer overview.
SELECT
    COUNT(*) AS customers,
    ROUND(AVG(age_at_2025), 1) AS average_age,
    SUM(total_sales) AS total_sales,
    ROUND(AVG(total_sales), 2) AS sales_per_customer
FROM customer_metrics;

-- Average age by marital status. Include sample size to expose small groups.
SELECT
    marital_status,
    COUNT(age_at_2025) AS valid_age_records,
    ROUND(AVG(age_at_2025), 1) AS average_age
FROM customer_metrics
GROUP BY marital_status
ORDER BY average_age DESC;

-- Assignment question: customers earning from $90,000 through $100,000.
SELECT
    COUNT(age_at_2025) AS valid_age_records,
    ROUND(AVG(age_at_2025), 2) AS average_age
FROM customer_metrics
WHERE income BETWEEN 90000 AND 100000;

-- Product sales: reshape columns to rows with a lateral values table.
WITH product_sales AS (
    SELECT
        m.id,
        p.product,
        p.sales
    FROM customer_metrics m
    CROSS JOIN LATERAL (
        VALUES
            ('Alcoholic beverages', amt_liq),
            ('Vegetables', amt_vege),
            ('Non-vegetable products', amt_nonveg),
            ('Fish products', amt_pes),
            ('Chocolates', amt_chocolates),
            ('Commodities', amt_comm)
    ) AS p(product, sales)
)
SELECT
    product,
    SUM(sales) AS total_sales,
    ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER (), 1) AS sales_share_pct
FROM product_sales
GROUP BY product
ORDER BY total_sales DESC;

-- Country performance: totals and normalized customer value.
SELECT
    country,
    COUNT(*) AS customers,
    SUM(total_sales) AS total_sales,
    ROUND(AVG(total_sales), 2) AS sales_per_customer
FROM customer_metrics
GROUP BY country
ORDER BY total_sales DESC;

-- Reshape social-platform indicators to rows so multi-platform customers
-- are counted once for every platform on which a conversion was recorded.
WITH social_conversions AS (
    SELECT
        m.id,
        m.country,
        m.marital_status,
        p.platform,
        p.converted
    FROM marketing_data m
    JOIN ad_data a USING (id)
    CROSS JOIN LATERAL (
        VALUES
            ('Twitter', a.twitter_ad),
            ('Instagram', a.instagram_ad),
            ('Facebook', a.facebook_ad)
    ) AS p(platform, converted)
)
SELECT
    platform,
    SUM(converted) AS successful_conversions
FROM social_conversions
GROUP BY platform
ORDER BY successful_conversions DESC;

-- Country-platform matrix. Report counts rather than "effectiveness."
WITH social_conversions AS (
    SELECT
        m.country,
        p.platform,
        p.converted
    FROM marketing_data m
    JOIN ad_data a USING (id)
    CROSS JOIN LATERAL (
        VALUES
            ('Twitter', a.twitter_ad),
            ('Instagram', a.instagram_ad),
            ('Facebook', a.facebook_ad)
    ) AS p(platform, converted)
)
SELECT
    country,
    platform,
    SUM(converted) AS successful_conversions
FROM social_conversions
GROUP BY country, platform
ORDER BY country, successful_conversions DESC, platform;

-- Customers with any recorded conversion, without double-counting people.
SELECT
    COUNT(*) FILTER (WHERE m.count_success > 0) AS customers_with_conversion,
    COUNT(*) AS customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE m.count_success > 0) / COUNT(*),
        1
    ) AS customer_share_pct
FROM marketing_data m;

