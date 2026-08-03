# Marketplace Growth, Fulfilment and Customer Experience Intelligence

## Project Overview

This project analyses the growth, fulfilment performance, customer experience, seller activity, and marketing funnel of an online marketplace.

The project is designed as an industry-style analytics assignment. Each stage is managed through a formal analytics work ticket containing:

* Business context
* Stakeholder request
* Objective
* Data requirements
* Risks and assumptions
* SQL implementation
* Validation criteria
* Business interpretation
* GitHub delivery

## Business Stakeholders

The analysis is intended to support:

* Chief Product Officer
* Head of Marketplace Operations
* Head of Logistics
* Head of Customer Experience
* Head of Seller Growth
* Finance Director

## Core Business Questions

1. Which product categories, customer locations, seller locations, and time periods contributed most to growth in orders, customers, and sellers?

2. What customer characteristics and first-order experiences distinguish repeat customers from one-time customers?

3. Which sellers, product categories, and customer locations have the highest late-delivery rates?

4. Which categories and customer locations have the lowest review scores, and what operational factors are associated with those scores?

5. Which categories and markets show the strongest supply-risk signals based on cancellations, unavailable orders, demand, and seller concentration?

6. Which marketing acquisition channels generate the strongest lead-to-seller conversion performance?

## Technology Stack

* PostgreSQL
* SQL
* Power BI
* Git
* GitHub
* Visual Studio Code
* Microsoft PowerShell

## Data Sources

The project uses the Brazilian E-Commerce Public Dataset by Olist and the Olist Marketing Funnel Dataset.

The database contains 11 raw source tables:

* `raw.customers`
* `raw.orders`
* `raw.order_items`
* `raw.order_payments`
* `raw.order_reviews`
* `raw.products`
* `raw.sellers`
* `raw.geolocation`
* `raw.product_category_translation`
* `raw.marketing_qualified_leads`
* `raw.closed_deals`

## Database Architecture

The PostgreSQL database uses three schemas.

### `raw`

Stores source data with minimal transformation. Source fields are initially retained as text to preserve the original records.

### `staging`

Stores validated, cleaned, deduplicated, and correctly typed data prepared for analysis.

### `analytics`

Stores analytical models, business metrics, reporting views, and Power BI-ready datasets.

## Repository Structure

```text
sql/
├── 01_database_setup/
│   ├── 01_create_database.sql
│   └── 02_create_schemas.sql
├── 02_table_creation/
│   └── 01_create_raw_tables.sql
├── 03_data_import/
│   ├── 01_import_raw_data.psql
│   └── 02_validate_import_counts.sql
└── 04_data_profiling/
    └── TKT-001_raw_data_intake_audit.sql
```

## Completed Work Tickets

### TKT-001 — Raw Data Intake Audit and Source Reconciliation

**Requested by:** Analytics Engineering Lead

#### Objective

Confirm that all approved source datasets were loaded completely and correctly into the PostgreSQL raw schema before downstream transformation and analysis.

#### Scope

The audit covers all 11 raw tables and checks:

* Expected versus actual row counts
* Row-count variance
* Source filename accuracy
* Number of distinct source files
* Missing source-file metadata
* Missing load timestamps
* Earliest and latest load timestamps

#### Acceptance Criteria

* All 11 expected raw tables are included.
* Actual row counts equal expected row counts.
* Each raw table contains one approved source filename.
* No records have missing source-file metadata.
* No records have missing load timestamps.
* Every table receives a `PASS` audit status.

#### Expected Raw Data Volume

| Table                        | Expected rows |
| ---------------------------- | ------------: |
| Customers                    |        99,441 |
| Orders                       |        99,441 |
| Order items                  |       112,650 |
| Order payments               |       103,886 |
| Order reviews                |        99,224 |
| Products                     |        32,951 |
| Sellers                      |         3,095 |
| Geolocation                  |     1,000,163 |
| Product category translation |            71 |
| Marketing-qualified leads    |         8,000 |
| Closed deals                 |           842 |
| **Total**                    | **1,558,785** |

#### Important Data-Quality Observations

1. The order reviews CSV contains embedded line breaks in review comments. Its physical text-line count is therefore greater than its actual number of CSV records.

2. The geolocation table contains 1,000,163 records but only 19,015 distinct ZIP-code prefixes. Directly joining the raw geolocation table to customers or sellers could multiply records and inflate analytical metrics.

3. The marketing funnel contains 842 closed deals. Of these, 462 seller IDs do not appear in the main marketplace seller dataset. This may indicate different observation periods, inactive converted sellers, or incomplete cross-dataset coverage.

4. Some orders have multiple review records. Directly joining orders to reviews without controlling the review grain could duplicate orders and distort order-level metrics.

5. The raw layer preserves the original source structure. Data types, deduplication rules, and business definitions will be implemented in the staging layer.

#### SQL Evidence

The audit implementation is stored in:

```text
sql/04_data_profiling/TKT-001_raw_data_intake_audit.sql
```

#### Ticket Status

Update this section after executing the audit:

```text
Tables audited:
Tables passed:
Tables requiring investigation:
Total expected records:
Total actual records:
Total row variance:
Overall ticket status:
```

## Data Governance Principles

This project follows these controls:

* Preserve original source data in the raw layer.
* Do not enforce assumed keys before validating uniqueness.
* Do not begin business analysis before source reconciliation.
* Document business definitions and assumptions.
* Validate row grain before joining tables.
* Use rates and minimum-volume thresholds when comparing seller performance.
* Treat association as evidence of a relationship, not proof of causation.
* Commit only reviewed and validated work to GitHub.

## Current Project Status

* Database created
* Schemas created
* Eleven source tables imported
* Raw-table row counts validated
* Candidate keys assessed
* Core table relationships assessed
* Marketing-funnel coverage limitation identified
* Raw data intake audit in progress

## Next Work Ticket

**TKT-002 — Raw Data Structural Profiling and Key Integrity Assessment**

The next ticket will examine:

* Missing values
* Duplicate candidate keys
* Invalid data types
* Referential integrity
* Table grain
* Join multiplication risks
* Data-cleaning requirements

## TKT-002 — Raw Data Structural Profiling and Key Integrity Assessment

**Requested by:** Analytics Engineering Lead and Data Governance Lead

### Objective

Validate the grain, candidate keys, composite keys, and relationships of the raw datasets before building the staging and analytics layers.

### Work Completed

The ticket assessed:

* Missing values in candidate-key columns
* Duplicate entity keys
* Duplicate composite keys
* Referential integrity between related tables
* Table grain
* Join-multiplication risks

### Candidate-Key Results

The following entity keys passed the missing-value and uniqueness checks:

* `customers.customer_id`
* `orders.order_id`
* `products.product_id`
* `sellers.seller_id`
* `product_category_translation.product_category_name`
* `marketing_qualified_leads.mql_id`
* `closed_deals.mql_id`

### Composite-Key Results

The following composite keys passed:

* `order_items (order_id, order_item_id)`
* `order_payments (order_id, payment_sequential)`
* `order_reviews (review_id, order_id)`

The `review_id` column alone is not unique. The combination of `review_id` and `order_id` is required to identify review records uniquely.

### Relationship Results

The following relationships were validated:

* `orders.customer_id` to `customers.customer_id`
* `order_items.order_id` to `orders.order_id`
* `order_items.product_id` to `products.product_id`
* `order_items.seller_id` to `sellers.seller_id`
* `order_payments.order_id` to `orders.order_id`
* `order_reviews.order_id` to `orders.order_id`

No unmatched records were found in these core relationships.

### Grain and Join-Risk Results

| Metric                               | Orders |
| ------------------------------------ | -----: |
| Total orders                         | 99,441 |
| Orders with multiple items           |  9,803 |
| Orders with multiple payment records |  2,961 |
| Orders with multiple reviews         |    547 |
| Item-payment join-risk orders        |    275 |
| Item-review join-risk orders         |     75 |

### Key Findings

1. The raw tables do not all operate at the same grain.

2. Directly joining order items, payments, and reviews can multiply rows.

3. There are 275 orders with both multiple items and multiple payment records.

4. There are 75 orders with both multiple items and multiple review records.

5. Payment values, product values, freight totals, GMV, and item counts could be inflated by direct joins.

6. The geolocation table contains repeated ZIP-code prefixes and must be reduced to one location record per ZIP prefix before use.

7. Orders with multiple reviews require a documented rule, such as selecting the latest review or aggregating review scores.

### Modelling Decision

The analytics model will not directly join all transactional child tables.

Instead:

1. Aggregate order items to one row per order.
2. Aggregate payments to one row per order.
3. select or aggregate reviews to one row per order.
4. Join the prepared order-level datasets.

This preserves one row per order and prevents duplicated business metrics.

### Files Created or Updated

* `sql/04_data_profiling/TKT-002_structural_profiling.sql`
* `README.md`

### Ticket Status

**PASS — structural risks identified and documented**

### Next Ticket

**TKT-003 — Raw Data Completeness and Data-Type Readiness Assessment**
