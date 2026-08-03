/*
Ticket ID: TKT-002
Title: Raw Data Structural Profiling and Key Integrity Assessment

Requested by:
Analytics Engineering Lead
Data Governance Lead

Business objective:
Validate table grain, candidate keys and relationships before building
the staging and analytics layers.

Section 1:
Entity key integrity assessment.
*/

WITH entity_key_audit AS (

    SELECT
        'customers'::TEXT AS table_name,
        'customer_id'::TEXT AS candidate_key,
        COUNT(*)::BIGINT AS total_rows,

        COUNT(*) FILTER ( -- count only rows that satisfy the filter condition
            WHERE customer_id IS NULL
               OR TRIM(customer_id) = '' ---if the trimmed result is an empty string convert it to NULL this treat blank as actual_NULLS

        )::BIGINT AS missing_key_rows,

        COUNT( -- 
            DISTINCT NULLIF(TRIM(customer_id), '')
        )::BIGINT AS distinct_valid_keys

    FROM raw.customers

    UNION ALL

    SELECT
        'orders',
        'order_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE order_id IS NULL
               OR TRIM(order_id) = ''
        )::BIGINT,

        COUNT(
            DISTINCT NULLIF(TRIM(order_id), '')
        )::BIGINT

    FROM raw.orders

    UNION ALL

    SELECT
        'products',
        'product_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE product_id IS NULL
               OR TRIM(product_id) = ''
        )::BIGINT,

        COUNT(
            DISTINCT NULLIF(TRIM(product_id), '')
        )::BIGINT

    FROM raw.products

    UNION ALL

    SELECT
        'sellers',
        'seller_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE seller_id IS NULL
               OR TRIM(seller_id) = ''
        )::BIGINT,

        COUNT(
            DISTINCT NULLIF(TRIM(seller_id), '')
        )::BIGINT

    FROM raw.sellers

    UNION ALL

    SELECT
        'product_category_translation',
        'product_category_name',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE product_category_name IS NULL
               OR TRIM(product_category_name) = ''
        )::BIGINT,

        COUNT(
            DISTINCT NULLIF(TRIM(product_category_name), '')
        )::BIGINT

    FROM raw.product_category_translation

    UNION ALL

    SELECT
        'marketing_qualified_leads',
        'mql_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE mql_id IS NULL
               OR TRIM(mql_id) = ''
        )::BIGINT,

        COUNT(
            DISTINCT NULLIF(TRIM(mql_id), '')
        )::BIGINT

    FROM raw.marketing_qualified_leads

    UNION ALL

    SELECT
        'closed_deals',
        'mql_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE mql_id IS NULL
               OR TRIM(mql_id) = ''
        )::BIGINT,

        COUNT(
            DISTINCT NULLIF(TRIM(mql_id), '')
        )::BIGINT

    FROM raw.closed_deals
)

SELECT
    table_name,
    candidate_key,
    total_rows,
    missing_key_rows,
    distinct_valid_keys,

    total_rows

        - missing_key_rows
        - distinct_valid_keys
        AS duplicate_key_excess_rows,

    CASE
        WHEN missing_key_rows > 0
            THEN 'FAIL: MISSING KEYS'

        WHEN total_rows
             - missing_key_rows
             - distinct_valid_keys > 0
            THEN 'FAIL: DUPLICATE KEYS'

        ELSE 'PASS'
    END AS key_status

FROM entity_key_audit

ORDER BY table_name;
---This script answers: "Can I trust this column to uniquely identify each row, or are there problems I need to fix first?"

-- ============================================================
-- SECTION 2: COMPOSITE-KEY INTEGRITY
-- ============================================================

WITH composite_key_audit AS (

    SELECT
        'order_items'::TEXT AS table_name,
        '(order_id, order_item_id)'::TEXT AS candidate_key,
        COUNT(*)::BIGINT AS total_rows,

        COUNT(*) FILTER (
            WHERE order_id IS NULL
               OR TRIM(order_id) = ''
               OR order_item_id IS NULL
               OR TRIM(order_item_id) = ''
        )::BIGINT AS rows_with_missing_key_parts,

        COUNT(
            DISTINCT (
                NULLIF(TRIM(order_id), ''),
                NULLIF(TRIM(order_item_id), '')
            )
        )::BIGINT AS distinct_composite_keys

    FROM raw.order_items

    UNION ALL

    SELECT
        'order_payments',
        '(order_id, payment_sequential)',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE order_id IS NULL
               OR TRIM(order_id) = ''
               OR payment_sequential IS NULL
               OR TRIM(payment_sequential) = ''
        )::BIGINT,

        COUNT(
            DISTINCT (
                NULLIF(TRIM(order_id), ''),
                NULLIF(TRIM(payment_sequential), '')
            )
        )::BIGINT

    FROM raw.order_payments

    UNION ALL

    SELECT
        'order_reviews',
        '(review_id, order_id)',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE review_id IS NULL
               OR TRIM(review_id) = ''
               OR order_id IS NULL
               OR TRIM(order_id) = ''
        )::BIGINT,

        COUNT(
            DISTINCT (
                NULLIF(TRIM(review_id), ''),
                NULLIF(TRIM(order_id), '')
            )
        )::BIGINT

    FROM raw.order_reviews
)

SELECT
    table_name,
    candidate_key,
    total_rows,
    rows_with_missing_key_parts,
    distinct_composite_keys,

    total_rows
        - rows_with_missing_key_parts
        - distinct_composite_keys
        AS duplicate_key_excess_rows,

    CASE
        WHEN rows_with_missing_key_parts > 0
            THEN 'FAIL: MISSING KEY PARTS'

        WHEN total_rows
             - rows_with_missing_key_parts
             - distinct_composite_keys > 0
            THEN 'FAIL: DUPLICATE COMPOSITE KEYS'

        ELSE 'PASS'
    END AS key_status

FROM composite_key_audit

ORDER BY table_name;


-- ============================================================
-- SECTION 3: REFERENTIAL INTEGRITY
-- ============================================================

WITH relationship_audit AS (

    SELECT
        'orders.customer_id -> customers.customer_id'::TEXT
            AS relationship_name,

        COUNT(*)::BIGINT AS child_rows,

        COUNT(*) FILTER (
            WHERE o.customer_id IS NULL
               OR TRIM(o.customer_id) = ''
        )::BIGINT AS missing_foreign_key_rows,

        COUNT(*) FILTER (
            WHERE o.customer_id IS NOT NULL
              AND TRIM(o.customer_id) <> ''
              AND c.customer_id IS NULL
        )::BIGINT AS unmatched_rows

    FROM raw.orders AS o

    LEFT JOIN raw.customers AS c
        ON TRIM(o.customer_id) = TRIM(c.customer_id)

    UNION ALL

    SELECT
        'order_items.order_id -> orders.order_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE oi.order_id IS NULL
               OR TRIM(oi.order_id) = ''
        )::BIGINT,

        COUNT(*) FILTER (
            WHERE oi.order_id IS NOT NULL
              AND TRIM(oi.order_id) <> ''
              AND o.order_id IS NULL
        )::BIGINT

    FROM raw.order_items AS oi

    LEFT JOIN raw.orders AS o
        ON TRIM(oi.order_id) = TRIM(o.order_id)

    UNION ALL

    SELECT
        'order_items.product_id -> products.product_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE oi.product_id IS NULL
               OR TRIM(oi.product_id) = ''
        )::BIGINT,

        COUNT(*) FILTER (
            WHERE oi.product_id IS NOT NULL
              AND TRIM(oi.product_id) <> ''
              AND p.product_id IS NULL
        )::BIGINT

    FROM raw.order_items AS oi

    LEFT JOIN raw.products AS p
        ON TRIM(oi.product_id) = TRIM(p.product_id)

    UNION ALL

    SELECT
        'order_items.seller_id -> sellers.seller_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE oi.seller_id IS NULL
               OR TRIM(oi.seller_id) = ''
        )::BIGINT,

        COUNT(*) FILTER (
            WHERE oi.seller_id IS NOT NULL
              AND TRIM(oi.seller_id) <> ''
              AND s.seller_id IS NULL
        )::BIGINT

    FROM raw.order_items AS oi

    LEFT JOIN raw.sellers AS s
        ON TRIM(oi.seller_id) = TRIM(s.seller_id)

    UNION ALL

    SELECT
        'order_payments.order_id -> orders.order_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE op.order_id IS NULL
               OR TRIM(op.order_id) = ''
        )::BIGINT,

        COUNT(*) FILTER (
            WHERE op.order_id IS NOT NULL
              AND TRIM(op.order_id) <> ''
              AND o.order_id IS NULL
        )::BIGINT

    FROM raw.order_payments AS op

    LEFT JOIN raw.orders AS o
        ON TRIM(op.order_id) = TRIM(o.order_id)

    UNION ALL

    SELECT
        'order_reviews.order_id -> orders.order_id',
        COUNT(*)::BIGINT,

        COUNT(*) FILTER (
            WHERE r.order_id IS NULL
               OR TRIM(r.order_id) = ''
        )::BIGINT,

        COUNT(*) FILTER (
            WHERE r.order_id IS NOT NULL
              AND TRIM(r.order_id) <> ''
              AND o.order_id IS NULL
        )::BIGINT

    FROM raw.order_reviews AS r

    LEFT JOIN raw.orders AS o
        ON TRIM(r.order_id) = TRIM(o.order_id)
)

SELECT
    relationship_name,
    child_rows,
    missing_foreign_key_rows,
    unmatched_rows,

    CASE
        WHEN missing_foreign_key_rows > 0
            THEN 'FAIL: MISSING FOREIGN KEYS'

        WHEN unmatched_rows > 0
            THEN 'FAIL: UNMATCHED RECORDS'

        ELSE 'PASS'
    END AS relationship_status

FROM relationship_audit

ORDER BY relationship_name;


-- ============================================================
-- SECTION 4: GRAIN AND JOIN-MULTIPLICATION RISK
-- ============================================================

WITH order_level_grain AS (

    SELECT
        o.order_id,

        COUNT(DISTINCT oi.order_item_id) AS item_count,

        COUNT(DISTINCT op.payment_sequential) AS payment_count,

        COUNT(DISTINCT r.review_id) AS review_count

    FROM raw.orders AS o

    LEFT JOIN raw.order_items AS oi
        ON o.order_id = oi.order_id

    LEFT JOIN raw.order_payments AS op
        ON o.order_id = op.order_id

    LEFT JOIN raw.order_reviews AS r
        ON o.order_id = r.order_id

    GROUP BY o.order_id
)

SELECT
    COUNT(*) AS total_orders,

    COUNT(*) FILTER (
        WHERE item_count > 1
    ) AS orders_with_multiple_items,

    COUNT(*) FILTER (
        WHERE payment_count > 1
    ) AS orders_with_multiple_payments,

    COUNT(*) FILTER (
        WHERE review_count > 1
    ) AS orders_with_multiple_reviews,

    COUNT(*) FILTER (
        WHERE item_count > 1
          AND payment_count > 1
    ) AS orders_at_item_payment_join_risk,

    COUNT(*) FILTER (
        WHERE item_count > 1
          AND review_count > 1
    ) AS orders_at_item_review_join_risk

FROM order_level_grain;

/*
TKT-002 completion summary

Entity key checks: PASS
Composite key checks: PASS
Core relationship checks: PASS

Join-risk findings:
- Orders with multiple items: 9,803
- Orders with multiple payments: 2,961
- Orders with multiple reviews: 547
- Item-payment join-risk orders: 275
- Item-review join-risk orders: 75

Modelling decision:
Aggregate transactional child tables to order level before joining.
*/