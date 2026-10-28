-- Project 1: Online Retail II KPI Analysis
-- Day 8: KPI pack using SQL and Excel
--
-- Dataset: UCI Online Retail II
-- Database: online_retail.db
--
-- KPIs:
-- 1. Net sales proxy, orders, and average order value
-- 2. Repeat customer rate
-- 3. Top products by net line value
-- 4. Monthly sales and month-on-month growth
--
-- Data handling:
-- Exclude invoices beginning with C.
-- Use Quantity * Price as line value.
-- Retain negative quantities on non-cancellation invoices.
-- Document limitations and assumptions in the project README.

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