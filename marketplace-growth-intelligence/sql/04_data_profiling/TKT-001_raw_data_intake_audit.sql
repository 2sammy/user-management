/*
Ticket ID: TKT-001
Title: Raw Data Intake Audit and Source Reconciliation

Requested by:
Analytics Engineering Lead

Business objective:
Confirm that all approved Olist source datasets were loaded completely
and correctly into the PostgreSQL raw schema before downstream modelling.

Acceptance criteria:
1. All 11 expected raw tables appear in the audit.
2. Actual rows equal expected rows.
3. Every table contains exactly one source_file value.
4. source_file and loaded_at are populated.
5. All tables return an audit_status of PASS.
*/

-- ============================================================
-- SECTION 1: APPROVED SOURCE INVENTORY
-- ============================================================
-- This CTE acts as the control register supplied by the project.
-- It represents what the database is expected to contain.

WITH expect_inventory AS (
    SELECT
        'customers'::TEXT AS table_name,
        'olist_customers_dataset.csv'::TEXT AS source_file,
        99441::BIGINT AS expected_rows
    UNION ALL
        SELECT
            'orders',
            'olist_orders_dataset.csv',
            99441
    UNION ALL
        SELECT
            'order_items',
            'olist_order_items_dataset.csv',
            112650
    UNION ALL
        SELECT
            'order_payments',
            'olist_order_payments_dataset.csv',
            103886
    UNION ALL
        SELECT
            'order_reviews',
            'olist_order_reviews_dataset.csv',
            99224
    UNION ALL
        SELECT
            'products',
            'olist_products_dataset.csv',
            32951
    UNION ALL
        SELECT
            'sellers',
            'olist_sellers_dataset.csv',
            3095
    UNION ALL
        SELECT
            'geolocation',
            'olist_geolocation_dataset.csv',
            1000163
    UNION ALL
        SELECT
            'product_category_translation',
            'olist_product_category_translation_dataset.csv',
            71
    UNION ALL
        SELECT
            'marketing_qualified_leads',
            'olist_marketing_qualified_leads_dataset.csv',
            8000
    UNION ALL
        SELECT
            'closed_deals',
            'olist_closed_deals_dataset.csv',
            842 


),

-- ============================================================
-- SECTION 2: ACTUAL DATABASE INVENTORY
-- ============================================================
-- Each SELECT summarizes one raw table.
-- UNION ALL combines the table summaries into one result.

actual_inventory AS (

    SELECT
        'customers'::TEXT AS table_name,
        COUNT(*)::BIGINT AS actual_rows,
        MIN(source_file) AS source_file,
        COUNT(DISTINCT source_file)::BIGINT AS source_file_count,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT AS missing_source_file_rows,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT AS missing_loaded_at_rows,
        MIN(loaded_at) AS first_loaded_at,
        MAX(loaded_at) AS last_loaded_at
    FROM raw.customers

    UNION ALL

    SELECT
        'orders',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.orders

    UNION ALL

    SELECT
        'order_items',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.order_items

    UNION ALL

    SELECT
        'order_payments',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.order_payments

    UNION ALL

    SELECT
        'order_reviews',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.order_reviews

    UNION ALL

    SELECT
        'products',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.products

    UNION ALL

    SELECT
        'sellers',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.sellers

    UNION ALL

    SELECT
        'geolocation',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.geolocation

    UNION ALL

    SELECT
        'product_category_translation',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.product_category_translation

    UNION ALL

    SELECT
        'marketing_qualified_leads',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.marketing_qualified_leads

    UNION ALL

    SELECT
        'closed_deals',
        COUNT(*)::BIGINT,
        MIN(source_file),
        COUNT(DISTINCT source_file)::BIGINT,
        COUNT(*) FILTER (
            WHERE source_file IS NULL
               OR TRIM(source_file) = ''
        )::BIGINT,
        COUNT(*) FILTER (
            WHERE loaded_at IS NULL
        )::BIGINT,
        MIN(loaded_at),
        MAX(loaded_at)
    FROM raw.closed_deals
)


-- ============================================================
-- SECTION 3: SOURCE-TO-TARGET RECONCILIATION
-- ============================================================

SELECT
    e.table_name,
    e.expected_source_file,
    a.source_file AS actual_source_file,
    e.expected_rows,
    a.actual_rows,
    a.actual_rows - e.expected_rows AS row_variance,
    a.source_file_count,
    a.missing_source_file_rows,
    a.missing_loaded_at_rows,
    a.first_loaded_at,
    a.last_loaded_at,

    CASE
        WHEN a.table_name IS NULL
            THEN 'FAIL: TABLE NOT AUDITED'

        WHEN a.actual_rows <> e.expected_rows
            THEN 'FAIL: ROW COUNT MISMATCH'

        WHEN a.source_file_count <> 1
        
            THEN 'FAIL: MULTIPLE SOURCE FILES'

        WHEN a.missing_source_file_rows > 0
            THEN 'FAIL: MISSING SOURCE FILE'

        WHEN a.source_file <> e.expected_source_file
            THEN 'FAIL: INCORRECT SOURCE FILE'

        WHEN a.missing_loaded_at_rows > 0
            THEN 'FAIL: MISSING LOAD TIMESTAMP'

        ELSE 'PASS'
    END AS audit_status

FROM expected_inventory AS e

LEFT JOIN actual_inventory AS a
    ON e.table_name = a.table_name

ORDER BY e.table_name;
