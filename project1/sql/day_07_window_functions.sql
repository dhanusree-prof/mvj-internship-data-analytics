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