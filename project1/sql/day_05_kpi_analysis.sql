//combined view creation
CREATE VIEW IF NOT EXISTS retail_transactions AS
SELECT
    CAST(Invoice AS TEXT) AS Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    "Customer ID" AS Customer_ID,
    Country,
    '2009-2010' AS source_period
FROM retail_2009_2010

UNION ALL

SELECT
    CAST(Invoice AS TEXT),
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    "Customer ID",
    Country,
    '2010-2011'
FROM retail_2010_2011;

//checking combined count
SELECT COUNT(*) AS total_rows
FROM retail_transactions;

//kpi analysis

WITH parsed AS (
    SELECT
        *,
        substr(InvoiceDate, 1, instr(InvoiceDate, '/') - 1) AS month_part,
        substr(InvoiceDate, instr(InvoiceDate, '/') + 1) AS remainder
    FROM retail_transactions
),
dated AS (
    SELECT
        *,
        substr(remainder, 1, instr(remainder, '/') - 1) AS day_part,
        substr(remainder, instr(remainder, '/') + 1) AS year_part
    FROM parsed
),
prepared AS (
    SELECT
        *,
        printf(
            '%04d-%02d',
            CAST(year_part AS INTEGER),
            CAST(month_part AS INTEGER)
        ) AS sales_month
    FROM dated
)
SELECT
    sales_month,
    ROUND(SUM(Quantity * Price), 2) AS net_line_value,
    COUNT(DISTINCT Invoice) AS order_count,
    ROUND(
        SUM(Quantity * Price) * 1.0
        / NULLIF(COUNT(DISTINCT Invoice), 0),
        2
    ) AS average_order_value
FROM prepared
WHERE Invoice NOT LIKE 'C%'
GROUP BY sales_month
ORDER BY sales_month;


SELECT
    Country,
    ROUND(SUM(Quantity * Price), 2) AS net_line_value,
    COUNT(DISTINCT Invoice) AS order_count,
    ROUND(
        SUM(Quantity * Price) * 1.0
        / NULLIF(COUNT(DISTINCT Invoice), 0),
        2
    ) AS average_order_value
FROM retail_transactions
WHERE Invoice NOT LIKE 'C%'
GROUP BY Country
ORDER BY net_line_value DESC;

