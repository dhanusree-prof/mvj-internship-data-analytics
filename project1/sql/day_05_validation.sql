SELECT name
FROM sqlite_master
WHERE type = 'table'
ORDER BY name;

SELECT '2009-2010' AS period, COUNT(*) AS row_count
FROM retail_2009_2010

UNION ALL

SELECT '2010-2011' AS period, COUNT(*) AS row_count
FROM retail_2010_2011;

SELECT *
FROM retail_2009_2010
LIMIT 5;

SELECT *
FROM retail_2010_2011
LIMIT 5;

PRAGMA table_info(retail_2009_2010);

PRAGMA table_info(retail_2010_2011);

SELECT
    '2009-2010' AS period,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Description IS NULL OR TRIM(Description) = '' THEN 1 ELSE 0 END) AS missing_description,
    SUM(CASE WHEN "Customer ID" IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN InvoiceDate IS NULL OR TRIM(InvoiceDate) = '' THEN 1 ELSE 0 END) AS missing_invoice_date,
    SUM(CASE WHEN Country IS NULL OR TRIM(Country) = '' THEN 1 ELSE 0 END) AS missing_country
FROM retail_2009_2010

UNION ALL

SELECT
    '2010-2011',
    COUNT(*),
    SUM(CASE WHEN Description IS NULL OR TRIM(Description) = '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN "Customer ID" IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN InvoiceDate IS NULL OR TRIM(InvoiceDate) = '' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Country IS NULL OR TRIM(Country) = '' THEN 1 ELSE 0 END)
FROM retail_2010_2011;
SELECT '2009-2010' AS period, COUNT(*) AS row_count
FROM retail_2009_2010

UNION ALL

SELECT '2010-2011', COUNT(*)
FROM retail_2010_2011;

SELECT COUNT(*) AS cancellation_rows
FROM retail_2009_2010
WHERE UPPER(CAST(Invoice AS TEXT)) LIKE 'C%';

SELECT COUNT(*) AS cancellation_rows
FROM retail_2010_2011
WHERE UPPER(CAST(Invoice AS TEXT)) LIKE 'C%';

SELECT
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS negative_quantity_rows,
    SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS zero_quantity_rows
FROM retail_2009_2010;

SELECT
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS negative_quantity_rows,
    SUM(CASE WHEN Quantity = 0 THEN 1 ELSE 0 END) AS zero_quantity_rows
FROM retail_2010_2011;

SELECT
    Invoice,
    StockCode,
    Quantity,
    Price,
    InvoiceDate,
    Country
FROM retail_2010_2011
WHERE UPPER(CAST(Invoice AS TEXT)) LIKE 'C%'
LIMIT 10;

SELECT InvoiceDate
FROM retail_2009_2010
LIMIT 10;

SELECT InvoiceDate
FROM retail_2010_2011
LIMIT 10;

SELECT
    typeof(Invoice) AS stored_type,
    COUNT(*) AS row_count
FROM retail_2009_2010
GROUP BY typeof(Invoice);

SELECT
    typeof(Invoice) AS stored_type,
    COUNT(*) AS row_count
FROM retail_2010_2011
GROUP BY typeof(Invoice);


