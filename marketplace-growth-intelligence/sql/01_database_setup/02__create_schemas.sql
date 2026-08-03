/*
Project: Marketplace Growth, Fulfilment and Customer Experience Intelligence
Purpose: Create the database schemas used by the project.

Schemas:
- raw: Original source data
- staging: Data validation and transformation
- analytics: Cleaned analytical models and data marts
*/

CREATE SCHEMA raw;
CREATE SCHEMA staging;
CREATE SCHEMA analytics;


COMMENT ON SCHEMA raw IS
'Original Olist source data imported from CSV files with minimal transformation.';

COMMENT ON SCHEMA staging IS
'Tables used for data profiling, validation, cleaning and type preparation.';

COMMENT ON SCHEMA analytics IS
'Cleaned analytical tables, views and data marts used for business analysis and Power BI.';


-- Validation
SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw', 'staging', 'analytics')
ORDER BY schema_name;