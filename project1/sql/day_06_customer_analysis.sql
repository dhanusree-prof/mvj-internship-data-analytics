-- Day 6: SQL Joins and CASE
-- Project 1: Online Retail II
-- Purpose: Prepare customer-level analysis

-- 1. Confirm the combined dataset size
SELECT COUNT(*) AS total_rows
FROM retail_transactions;

-- 2. Count rows with and without a customer ID
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_id_rows,
    COUNT(DISTINCT Customer_ID) AS distinct_customers
FROM retail_transactions;

-- 3. Inspect customer transaction data
SELECT
    Customer_ID,
    Invoice,
    InvoiceDate,
    Quantity,
    Price,
    Country
FROM retail_transactions
WHERE Customer_ID IS NOT NULL
LIMIT 10;


-- Customer-level summary
-- Exclude missing customer IDs and cancellation invoices.

WITH customer_transactions AS (
    SELECT *
    FROM retail_transactions
    WHERE Customer_ID IS NOT NULL
      AND TRIM(CAST(Customer_ID AS TEXT)) <> ''
      AND Invoice NOT LIKE 'C%'
),
customer_summary AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS order_count,
        SUM(Quantity) AS total_quantity,
        ROUND(SUM(Quantity * Price), 2) AS total_line_value,
        MIN(InvoiceDate) AS first_purchase_raw,
        MAX(InvoiceDate) AS last_purchase_raw
    FROM customer_transactions
    GROUP BY Customer_ID
)
SELECT *
FROM customer_summary
ORDER BY total_line_value DESC
LIMIT 20;

-- Validating customer summary
WITH customer_transactions AS (
    SELECT *
    FROM retail_transactions
    WHERE Customer_ID IS NOT NULL
      AND TRIM(CAST(Customer_ID AS TEXT)) <> ''
      AND Invoice NOT LIKE 'C%'
)
SELECT
    COUNT(DISTINCT Customer_ID) AS customer_count,
    COUNT(DISTINCT Invoice) AS order_count,
    COUNT(*) AS transaction_lines
FROM customer_transactions;

-- classifying customers according to their distinct invoice counts

WITH customer_transactions AS (
    SELECT *
    FROM retail_transactions
    WHERE Customer_ID IS NOT NULL
      AND TRIM(CAST(Customer_ID AS TEXT)) <> ''
      AND Invoice NOT LIKE 'C%'
),
customer_summary AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS order_count,
        SUM(Quantity) AS total_quantity,
        ROUND(SUM(Quantity * Price), 2) AS total_line_value,
        MIN(InvoiceDate) AS first_purchase_raw,
        MAX(InvoiceDate) AS last_purchase_raw
    FROM customer_transactions
    GROUP BY Customer_ID
)
SELECT
    *,
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
        ELSE 'Frequent'
    END AS customer_segment
FROM customer_summary
ORDER BY total_line_value DESC
LIMIT 20;

-- Creating permanent customer table

DROP TABLE IF EXISTS customer_analysis_day06;

CREATE TABLE customer_analysis_day06 AS
WITH customer_transactions AS (
    SELECT *
    FROM retail_transactions
    WHERE Customer_ID IS NOT NULL
      AND TRIM(CAST(Customer_ID AS TEXT)) <> ''
      AND Invoice NOT LIKE 'C%'
),
customer_summary AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS order_count,
        SUM(Quantity) AS total_quantity,
        ROUND(SUM(Quantity * Price), 2) AS total_line_value,
        MIN(InvoiceDate) AS first_purchase_raw,
        MAX(InvoiceDate) AS last_purchase_raw
    FROM customer_transactions
    GROUP BY Customer_ID
)
SELECT
    *,
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
        ELSE 'Frequent'
    END AS customer_segment
FROM customer_summary;

-- Verifying the if the above query was added 
SELECT
    customer_segment,
    COUNT(*) AS customers
FROM customer_analysis_day06
GROUP BY customer_segment
ORDER BY customers DESC;

-- Checking tables's row count
SELECT COUNT(*) AS customer_rows
FROM customer_analysis_day06;

-- Adding a join based customer table
DROP TABLE IF EXISTS customer_analysis_day06;

CREATE TABLE customer_analysis_day06 AS
WITH valid_transactions AS (
    SELECT *
    FROM retail_transactions
    WHERE Customer_ID IS NOT NULL
      AND TRIM(CAST(Customer_ID AS TEXT)) <> ''
      AND Invoice NOT LIKE 'C%'
),
customer_metrics AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS order_count,
        SUM(Quantity) AS total_quantity,
        ROUND(SUM(Quantity * Price), 2) AS total_line_value
    FROM valid_transactions
    GROUP BY Customer_ID
),
customer_dates AS (
    SELECT
        Customer_ID,
        MIN(InvoiceDate) AS first_purchase_raw,
        MAX(InvoiceDate) AS last_purchase_raw
    FROM valid_transactions
    GROUP BY Customer_ID
)
SELECT
    m.Customer_ID,
    m.order_count,
    m.total_quantity,
    m.total_line_value,
    d.first_purchase_raw,
    d.last_purchase_raw,
    CASE
        WHEN m.order_count = 1 THEN 'One-time'
        WHEN m.order_count BETWEEN 2 AND 4 THEN 'Repeat'
        ELSE 'Frequent'
    END AS customer_segment
FROM customer_metrics AS m
INNER JOIN customer_dates AS d
    ON m.Customer_ID = d.Customer_ID;

-- Confirming the no. of customers
SELECT COUNT(*) AS customer_rows
FROM customer_analysis_day06;

-- Checking customer segments
SELECT
    customer_segment,
    COUNT(*) AS customers
FROM customer_analysis_day06
GROUP BY customer_segment
ORDER BY customers DESC;

-- Inspecting first 10 rows
SELECT *
FROM customer_analysis_day06
LIMIT 10;
