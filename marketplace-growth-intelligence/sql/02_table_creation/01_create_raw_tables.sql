/*
Project: Marketplace Growth, Fulfilment and Customer Experience Intelligence
Layer: Raw

Purpose:
Create raw tables that preserve the source CSV structures.

Design decisions:
1. Source fields are initially stored as TEXT.
2. Data types are corrected later in the staging layer.
3. Primary and foreign keys are not enforced in raw tables.
4. source_file records the originating CSV file.
5. loaded_at records when the row was imported.
*/


-- ============================================================
-- 1. CUSTOMERS
-- Grain: One customer record associated with an order
-- Candidate key: customer_id
-- ============================================================

CREATE TABLE raw.customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT,
    source_file TEXT DEFAULT 'olist_customers_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. ORDERS
-- Grain: One marketplace order
-- Candidate key: order_id
-- ============================================================

CREATE TABLE raw.orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT,
    source_file TEXT DEFAULT 'olist_orders_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 3. ORDER ITEMS
-- Grain: One item position within an order
-- Candidate key: (order_id, order_item_id)
-- ============================================================

CREATE TABLE raw.order_items (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT,
    source_file TEXT DEFAULT 'olist_order_items_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. ORDER PAYMENTS
-- Grain: One payment sequence used for an order
-- Candidate key: (order_id, payment_sequential)
-- ============================================================

CREATE TABLE raw.order_payments (
    order_id TEXT,
    payment_sequential TEXT,
    payment_type TEXT,
    payment_installments TEXT,
    payment_value TEXT,
    source_file TEXT DEFAULT 'olist_order_payments_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 5. ORDER REVIEWS
-- Grain: One review record associated with an order
-- Candidate key: (review_id, order_id)
-- ============================================================

CREATE TABLE raw.order_reviews (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT,
    source_file TEXT DEFAULT 'olist_order_reviews_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 6. PRODUCTS
-- Grain: One anonymised marketplace product
-- Candidate key: product_id
--
-- Note:
-- The original source misspells "length" as "lenght".
-- Source column names are preserved in the raw layer.
-- ============================================================

CREATE TABLE raw.products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght TEXT,
    product_description_lenght TEXT,
    product_photos_qty TEXT,
    product_weight_g TEXT,
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT,
    source_file TEXT DEFAULT 'olist_products_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 7. SELLERS
-- Grain: One marketplace seller
-- Candidate key: seller_id
-- ============================================================

CREATE TABLE raw.sellers (
    seller_id TEXT,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT,
    source_file TEXT DEFAULT 'olist_sellers_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 8. GEOLOCATION
-- Grain: One geographic coordinate associated with a ZIP prefix
--
-- No natural primary key has been confirmed.
-- A ZIP-code prefix can appear many times.
-- ============================================================

CREATE TABLE raw.geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat TEXT,
    geolocation_lng TEXT,
    geolocation_city TEXT,
    geolocation_state TEXT,
    source_file TEXT DEFAULT 'olist_geolocation_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 9. PRODUCT CATEGORY TRANSLATION
-- Grain: One Portuguese-to-English category translation
-- Candidate key: product_category_name
-- ============================================================

CREATE TABLE raw.product_category_translation (
    product_category_name TEXT,
    product_category_name_english TEXT,
    source_file TEXT DEFAULT 'product_category_name_translation.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 10. MARKETING-QUALIFIED LEADS
-- Grain: One marketing-qualified lead
-- Candidate key: mql_id
-- ============================================================

CREATE TABLE raw.marketing_qualified_leads (
    mql_id TEXT,
    first_contact_date TEXT,
    landing_page_id TEXT,
    origin TEXT,
    source_file TEXT DEFAULT 'olist_marketing_qualified_leads_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 11. CLOSED DEALS
-- Grain: One marketing-qualified lead that became a closed deal
-- Candidate key: mql_id
-- ============================================================

CREATE TABLE raw.closed_deals (
    mql_id TEXT,
    seller_id TEXT,
    sdr_id TEXT,
    sr_id TEXT,
    won_date TEXT,
    business_segment TEXT,
    lead_type TEXT,
    lead_behaviour_profile TEXT,
    has_company TEXT,
    has_gtin TEXT,
    average_stock TEXT,
    business_type TEXT,
    declared_product_catalog_size TEXT,
    declared_monthly_revenue TEXT,
    source_file TEXT DEFAULT 'olist_closed_deals_dataset.csv',
    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- TABLE-CREATION VALIDATION
-- Expected result: 11 raw tables
-- ============================================================

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'raw'
ORDER BY table_name;