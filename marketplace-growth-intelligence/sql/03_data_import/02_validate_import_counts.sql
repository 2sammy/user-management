/*
Project: Marketplace Growth, Fulfilment and Customer Experience Intelligence
Purpose: Perform a basic post-import row-count validation.

This confirms that every raw table contains the expected number of rows.
A more detailed source audit will be completed under TKT-001.
*/

SELECT
    'customers' AS table_name,
    COUNT(*) AS imported_rows,
    99441 AS expected_rows,
    COUNT(*) - 99441 AS row_variance
FROM raw.customers

UNION ALL

SELECT
    'orders',
    COUNT(*),
    99441,
    COUNT(*) - 99441
FROM raw.orders

UNION ALL

SELECT
    'order_items',
    COUNT(*),
    112650,
    COUNT(*) - 112650
FROM raw.order_items

UNION ALL

SELECT
    'order_payments',
    COUNT(*),
    103886,
    COUNT(*) - 103886
FROM raw.order_payments

UNION ALL

SELECT
    'order_reviews',
    COUNT(*),
    99224,
    COUNT(*) - 99224
FROM raw.order_reviews

UNION ALL

SELECT
    'products',
    COUNT(*),
    32951,
    COUNT(*) - 32951
FROM raw.products

UNION ALL

SELECT
    'sellers',
    COUNT(*),
    3095,
    COUNT(*) - 3095
FROM raw.sellers

UNION ALL

SELECT
    'geolocation',
    COUNT(*),
    1000163,
    COUNT(*) - 1000163
FROM raw.geolocation

UNION ALL

SELECT
    'product_category_translation',
    COUNT(*),
    71,
    COUNT(*) - 71
FROM raw.product_category_translation

UNION ALL

SELECT
    'marketing_qualified_leads',
    COUNT(*),
    8000,
    COUNT(*) - 8000
FROM raw.marketing_qualified_leads

UNION ALL

SELECT
    'closed_deals',
    COUNT(*),
    842,
    COUNT(*) - 842
FROM raw.closed_deals

ORDER BY table_name;