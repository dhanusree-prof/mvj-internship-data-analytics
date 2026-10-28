# Day 08 — Online Retail II KPI Analysis Project

## 1. Objective

To apply SQL and Excel skills to analyze the Online Retail II dataset, calculate key business performance indicators, identify sales and customer trends, and prepare a professional KPI workbook.

## 2. Project Overview

**Project:** Online Retail II — Sales and Customer KPI Analysis

**Tools used:**
- SQLite
- DB Browser for SQLite
- SQL
- Microsoft Excel Online
- Git and GitHub

The project focuses on sales performance, average order value, repeat purchasing, top-performing products, and month-on-month sales changes.

## 3. Tasks Completed

- Reviewed the existing SQL queries and reusable views developed during Days 5–7.
- Calculated overall sales and order metrics.
- Calculated average order value (AOV).
- Measured the repeat-customer rate using identifiable customers with at least two distinct orders.
- Identified the top 10 products by aggregated transaction-line value.
- Analyzed monthly sales and calculated month-on-month changes and growth percentages.
- Compared overall transaction-line value with aggregated monthly sales to validate consistency.
- Organized the final query results for use in Excel.
- Created an Excel KPI workbook with four sheets:
  - KPI Summary
  - Repeat Rate
  - Top Products
  - Monthly Trends
- Created a horizontal bar chart for the top 10 products and a line chart for monthly sales trends.
- Prepared the project README and business recommendations.

## 4. Key SQL Concepts Applied

### Aggregation
Used `SUM()`, `COUNT()`, `COUNT(DISTINCT ...)`, and `ROUND()` to calculate sales and order metrics.

### Conditional logic
Used `CASE WHEN` to identify repeat customers and calculate customer-related measures.

### Common table expressions
Used `WITH` clauses to organize multi-step queries and make the analysis easier to read.

### Window functions
Applied `LAG()` to retrieve the previous month's sales and calculate month-on-month changes.

### Date handling
Normalized invoice dates into a consistent calendar-date format and grouped transaction values by month.

### Data validation
Compared overall sales totals with the sum of monthly totals to check whether the aggregation was consistent.

## 5. Business KPIs

| KPI                  | Purpose 
|----------------------|--------------------------
| Net sales proxy      | Measures the aggregated transaction-line value 
| Total orders         | Counts distinct included invoices 
| Average order value  | Measures average net sales proxy per included order 
| Repeat-customer rate | Measures the percentage of identifiable customers with at least two included orders 
| Top 10 products      | Identifies products with the highest aggregated transaction-line value 
| Monthly sales        | Tracks sales performance by calendar month 
| MoM growth           | Measures the percentage change from the preceding month's sales 

**Note:** Net sales proxy is calculated as quantity multiplied by unit price. It should not be interpreted as audited accounting revenue.

## 6. Excel Deliverable

**Workbook:** `Online_Retail_II_KPI_Pack.xlsx`

The workbook contains four sheets:

1. **KPI Summary** — overall sales and order KPIs.
2. **Repeat Rate** — identifiable customers, repeat customers, and repeat-customer rate.
3. **Top Products** — top 10 products and a horizontal bar chart.
4. **Monthly Trends** — monthly sales, previous-month sales, absolute change, MoM growth, and a line chart.

## 7. Key Learnings

- SQL aggregation can convert transaction-level records into useful business KPIs.
- Distinct invoice counts help avoid treating every transaction line as a separate order.
- Repeat-customer analysis requires identifiable customer records and a clearly defined repeat-purchase rule.
- Window functions simplify comparisons between consecutive reporting periods.
- Date normalization is important for reliable monthly analysis.
- Excel charts make product rankings and monthly trends easier to interpret.
- KPI definitions and data-quality limitations must be documented to avoid misleading business conclusions.

## 8. Data Quality and Limitations

- The analysis excludes invoice numbers beginning with `C`, which are identified as cancellations in the source dataset.
- Records with missing invoice dates are excluded from the normalized analysis view.
- Transactions with missing customer IDs are excluded from the repeat-customer calculation.
- Negative quantities in non-cancellation invoices are retained and may represent returns or adjustments.
- The calculated net sales proxy does not independently account for taxes, shipping, or all accounting adjustments.

## 9. Deliverables

- `project1/sql/day_08_kpi_analysis.sql`
- `project1/outputs/overall_kpi_summary.csv`
- `project1/outputs/repeat_customer_rate.csv`
- `project1/outputs/top_10_products.csv`
- `project1/outputs/monthly_sales_mom.csv`
- `project1/outputs/Online_Retail_II_KPI_Pack.xlsx`
- `project1/recommendations.md`
- `project1/README.md`
- `learning-notes/day-08.md`

