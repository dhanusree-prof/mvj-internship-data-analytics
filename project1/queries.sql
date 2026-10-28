-- Day 05:
-- Combined view creation
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

-- Checking combined count
SELECT COUNT(*) AS total_rows
FROM retail_transactions;

-- KPI analysis

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


-- Day 06:
-- Purpose: Prepare customer-level analysis

-- Confirm the combined dataset size
SELECT COUNT(*) AS total_rows
FROM retail_transactions;

-- Count rows with and without a customer ID
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_id_rows,
    COUNT(DISTINCT Customer_ID) AS distinct_customers
FROM retail_transactions;

-- Inspect customer transaction data
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


-- Day 07:
-- Test query
WITH sample AS (
    SELECT 1 AS month_number, 100 AS sales
    UNION ALL
    SELECT 2, 150
    UNION ALL
    SELECT 3, 120
)
SELECT
    month_number,
    sales,
    SUM(sales) OVER (
        ORDER BY month_number
    ) AS running_total,
    LAG(sales) OVER (
        ORDER BY month_number
    ) AS previous_month_sales
FROM sample;

-- Monthly sales preparation
-- Standardize transaction dates and calculate monthly line value.
WITH date_parts AS (
    SELECT
        Quantity,
        Price,
        substr(InvoiceDate, 1, instr(InvoiceDate, '/') - 1)
            AS month_part,
        substr(
            InvoiceDate,
            instr(InvoiceDate, '/') + 1,
            instr(
                substr(InvoiceDate, instr(InvoiceDate, '/') + 1),
                '/'
            ) - 1
        ) AS day_part,
        substr(
            InvoiceDate,
            instr(InvoiceDate, '/') + 1
            + instr(
                substr(InvoiceDate, instr(InvoiceDate, '/') + 1),
                '/'
            )
        ) AS year_and_time
    FROM retail_transactions
    WHERE InvoiceDate IS NOT NULL
      AND Invoice NOT LIKE 'C%'
),
normalized AS (
    SELECT
        Quantity * Price AS line_value,
        printf(
            '%04d-%02d-%02d',
            CAST(substr(year_and_time, 1, 4) AS INTEGER),
            CAST(month_part AS INTEGER),
            CAST(day_part AS INTEGER)
        ) AS order_date
    FROM date_parts
),
monthly_sales AS (
    SELECT
        substr(order_date, 1, 7) AS order_month,
        ROUND(SUM(line_value), 2) AS monthly_sales
    FROM normalized
    GROUP BY substr(order_date, 1, 7)
)
SELECT *
FROM monthly_sales
ORDER BY order_month;

-- Create a reusable normalized transaction view

CREATE VIEW IF NOT EXISTS day07_normalized_transactions AS
WITH date_parts AS (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        Price,
        Customer_ID,
        Country,
        substr(InvoiceDate, 1, instr(InvoiceDate, '/') - 1)
            AS month_part,
        substr(
            InvoiceDate,
            instr(InvoiceDate, '/') + 1,
            instr(
                substr(InvoiceDate, instr(InvoiceDate, '/') + 1),
                '/'
            ) - 1
        ) AS day_part,
        substr(
            InvoiceDate,
            instr(InvoiceDate, '/') + 1
            + instr(
                substr(InvoiceDate, instr(InvoiceDate, '/') + 1),
                '/'
            )
        ) AS year_and_time
    FROM retail_transactions
    WHERE InvoiceDate IS NOT NULL
      AND Invoice NOT LIKE 'C%'
),
normalized AS (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        Price,
        Customer_ID,
        Country,
        Quantity * Price AS line_value,
        printf(
            '%04d-%02d-%02d',
            CAST(substr(year_and_time, 1, 4) AS INTEGER),
            CAST(month_part AS INTEGER),
            CAST(day_part AS INTEGER)
        ) AS order_date
    FROM date_parts
)
SELECT *
FROM normalized;

-- Monthly sales

CREATE VIEW IF NOT EXISTS day07_monthly_sales AS
SELECT
    substr(order_date, 1, 7) AS order_month,
    ROUND(SUM(line_value), 2) AS monthly_sales
FROM day07_normalized_transactions
GROUP BY substr(order_date, 1, 7);

-- Running total of monthly sales

SELECT
    order_month,
    monthly_sales,
    ROUND(
        SUM(monthly_sales) OVER (
            ORDER BY order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_sales_total
FROM day07_monthly_sales
ORDER BY order_month;

-- Month-on-month sales growth using LAG

WITH monthly_comparison AS (
    SELECT
        order_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY order_month
        ) AS previous_month_sales
    FROM day07_monthly_sales
)
SELECT
    order_month,
    monthly_sales,
    previous_month_sales,
    ROUND(monthly_sales - previous_month_sales, 2)
        AS sales_change,
    ROUND(
        100.0 * (monthly_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0),
        2
    ) AS mom_growth_percent
FROM monthly_comparison
ORDER BY order_month;

-- Top three products by net line value in each country

WITH product_sales AS (
    SELECT
        Country,
        StockCode,
        MAX(Description) AS Description,
        ROUND(SUM(line_value), 2) AS product_sales
    FROM day07_normalized_transactions
    WHERE StockCode IS NOT NULL
    GROUP BY Country, StockCode
),
ranked_products AS (
    SELECT
        Country,
        StockCode,
        Description,
        product_sales,
        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY product_sales DESC, StockCode
        ) AS product_rank
    FROM product_sales
)
SELECT
    Country,
    product_rank,
    StockCode,
    Description,
    product_sales
FROM ranked_products
WHERE product_rank <= 3
ORDER BY Country, product_rank;

-- First purchase month for each customer

SELECT
    Customer_ID,
    MIN(substr(order_date, 1, 7)) AS first_purchase_month
FROM day07_normalized_transactions
WHERE Customer_ID IS NOT NULL
GROUP BY Customer_ID
ORDER BY first_purchase_month, Customer_ID;

-- Customer count by first purchase month

WITH customer_first_purchase AS (
    SELECT
        Customer_ID,
        MIN(substr(order_date, 1, 7)) AS first_purchase_month
    FROM day07_normalized_transactions
    WHERE Customer_ID IS NOT NULL
    GROUP BY Customer_ID
)
SELECT
    first_purchase_month AS cohort_month,
    COUNT(*) AS customers_in_cohort
FROM customer_first_purchase
GROUP BY first_purchase_month
ORDER BY cohort_month;


-- Day 08:
-- Query 1: Overall KPI summary

SELECT
    ROUND(SUM(line_value), 2) AS net_sales_proxy,
    COUNT(DISTINCT Invoice) AS total_orders,
    ROUND(
        SUM(line_value) / NULLIF(COUNT(DISTINCT Invoice), 0),
        2
    ) AS average_order_value,
    COUNT(*) AS transaction_lines
FROM day07_normalized_transactions;

-- Query 2: Repeat customer rate

WITH customer_orders AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS order_count
    FROM day07_normalized_transactions
    WHERE Customer_ID IS NOT NULL
    GROUP BY Customer_ID
)
SELECT
    COUNT(*) AS identifiable_customers,
    SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_percent
FROM customer_orders;

-- Query 3: Top 10 products by net line value

SELECT
    StockCode,
    MAX(Description) AS product_description,
    ROUND(SUM(line_value), 2) AS net_sales_proxy,
    SUM(Quantity) AS net_quantity
FROM day07_normalized_transactions
WHERE StockCode IS NOT NULL
GROUP BY StockCode
ORDER BY net_sales_proxy DESC, StockCode
LIMIT 10;

-- Query 4: Monthly sales and month-on-month growth

WITH monthly_comparison AS (
    SELECT
        order_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY order_month
        ) AS previous_month_sales
    FROM day07_monthly_sales
)
SELECT
    order_month,
    monthly_sales,
    previous_month_sales,
    ROUND(monthly_sales - previous_month_sales, 2)
        AS sales_change,
    ROUND(
        100.0 * (monthly_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0),
        2
    ) AS mom_growth_percent
FROM monthly_comparison
ORDER BY order_month;

-- Query 5: Monthly and overall sales consistency check

SELECT
    (SELECT ROUND(SUM(line_value), 2)
     FROM day07_normalized_transactions) AS overall_net_sales_proxy,
    (SELECT ROUND(SUM(monthly_sales), 2)
     FROM day07_monthly_sales) AS sum_of_monthly_sales;




