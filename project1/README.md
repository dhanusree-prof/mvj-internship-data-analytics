# Online Retail II — Sales and Customer KPI Analysis

## 1. Project Overview

This project analyzes the Online Retail II transactional dataset to understand sales performance, customer purchasing behaviour, product performance, and monthly sales trends.

The analysis uses SQL for data preparation, aggregation, customer analysis, and time-series calculations. Microsoft Excel is used to present key performance indicators (KPIs), product comparisons, and monthly sales trends in a structured KPI workbook.

**Project:** Online Retail II KPI Analysis  
**Program:** MVJ Data Analytics Internship  
**Tools:** SQLite, DB Browser for SQLite, SQL, Microsoft Excel Online  
**Analysis period:** December 2009 – December 2011

## 2. Business Problem

Retail businesses need to understand how sales change over time, which products contribute most to sales, how much customers spend per order, and whether customers return to make additional purchases.

This project uses historical transaction data to answer the following business questions:

- What are the overall sales and order performance metrics?
- What is the average order value?
- What proportion of identifiable customers make repeat purchases?
- Which products generate the highest net sales proxy?
- How does monthly sales performance change over time?
- What actions could help improve sales monitoring and customer retention?

**Intended audience:** Retail managers, sales analysts, and business stakeholders who need a concise overview of sales and customer performance.

## 3. Dataset and Source

The project uses the **Online Retail II** dataset published by the UCI Machine Learning Repository.

- **Source:** [UCI Machine Learning Repository — Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii)
- **Dataset creator:** Daqing Chen
- **Dataset DOI:** [10.24432/C5CG6D](https://doi.org/10.24432/C5CG6D)
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Original file:** `online_retail_II.xlsx`
- **Original dataset size:** 1,067,371 transaction records
- **Source period:** 1 December 2009 – 9 December 2011
- **Download date:** Not recorded; update this field if the original download date is available.

The original workbook contains two periods, represented in the source file by the sheets `year 2009-2010` and `year 2010-2011`.

The source dataset contains invoice numbers, product codes, descriptions, quantities, invoice dates, unit prices, customer identifiers, and countries.

## 4. Tools and Technologies

| Tool                   | Purpose 
|------------------------|-------------------
| SQLite                 | Store and query the transaction data 
| DB Browser for SQLite  | Execute SQL queries and inspect results 
| SQL                    | Calculate KPIs, analyze customers and products, and measure monthly changes 
| Microsoft Excel Online | Organize KPI results and create charts 
| Git and GitHub         | Track project files and document project progress 

## 5. Data Preparation and Quality Checks

The original data was imported into SQLite for analysis. The two source periods were made available through the tables `retail_2009_2010` and `retail_2010_2011`, with a combined view named `retail_transactions`.

A normalized analysis view, `day07_normalized_transactions`, was created to prepare the transaction dates and calculate transaction-line values. The monthly sales view, `day07_monthly_sales`, supports the monthly trend analysis.

The following preparation steps were applied:

1. Combined the two source periods through the transaction view.
2. Examined the table structures and transaction counts.
3. Excluded invoices whose invoice numbers begin with `C`, which the dataset documentation identifies as cancellations.
4. Excluded records with missing invoice dates from the normalized analysis view.
5. Converted the source date strings into a consistent `YYYY-MM-DD` format for analysis.
6. Calculated transaction-line value as quantity multiplied by unit price.
7. Grouped transactions by month for monthly sales analysis.
8. Used distinct invoice numbers when counting orders.
9. Excluded records with missing customer identifiers from the repeat-customer calculation.
10. Compared the overall transaction-line total with the sum of monthly sales to check aggregation consistency.

### Data quality considerations

The source dataset contains missing values. The analysis applies field-specific filters where necessary rather than assuming every field is complete.

The imported source tables contain 525,461 rows for the 2010–2011 period; table structures were also checked against the other source period.

Negative quantities in non-cancellation invoices were not automatically removed. Consequently, the calculated sales measure can reflect returns or adjustments represented by negative quantities.

## 6. KPI Definitions

| KPI                         | Definition 
|-----------------------------|----------------
| Net sales proxy             | Sum of quantity multiplied by unit price for included transaction lines 
| Total orders                | Count of distinct included invoice numbers 
| Average order value (AOV)   | Net sales proxy divided by total orders 
| Repeat-customer rate        | Percentage of identifiable customers with at least two distinct included invoices 
| Top products                | Products ranked by aggregated transaction-line value 
| Monthly sales               | Sum of transaction-line values grouped by calendar month 
| Month-on-month (MoM) growth | Percentage change in monthly sales compared with the preceding month 

**Important:** The net sales proxy is an analytical measure calculated from the available transaction fields. It should not automatically be treated as audited revenue or official accounting sales.

## 7. SQL Analysis

The SQL work is organized into daily scripts under `project1/sql/`.

### Day 5 — KPI and aggregation analysis

- Calculated sales and order-related metrics.
- Practised grouping and aggregation.
- Checked the imported dataset and table structure.

### Day 6 — Customer analysis

- Used joins to combine customer-level analysis results.
- Calculated customer order counts.
- Classified customers using order-count-based segments:
  - One-time: one order
  - Repeat: two to four orders
  - Frequent: five or more orders

These segments describe observed order frequency and are not predictive customer classifications.

### Day 7 — Window functions and time-series analysis

- Normalized transaction dates.
- Calculated monthly sales.
- Used `SUM() OVER` for running totals.
- Used `LAG()` to compare monthly sales with the previous month.
- Ranked products by country using `ROW_NUMBER()`.
- Identified first-purchase months and customer cohorts.

### Day 8 — Final KPI pack

The final KPI analysis covers:

- Overall sales, orders, average order value, and transaction-line counts.
- Repeat-customer rate.
- Top 10 products by net sales proxy.
- Monthly sales and month-on-month growth.
- Reconciliation of overall and monthly totals.

## 8. Excel KPI Dashboard

The Excel workbook is named `Online_Retail_II_KPI_Pack.xlsx` and contains four sheets.

| Sheet             | Contents 
|-------------------|-----------
| `KPI Summary`     | Overall KPI values and definitions 
| `Repeat Rate`     | Identifiable customers, repeat customers, and repeat-customer rate 
| `Top Products`    | Top 10 products by net sales proxy, with a horizontal bar chart 
| `Monthly Trends`  | Monthly sales, previous-month sales, sales change, and MoM growth, with a line chart 

The workbook is designed to make the analysis easier to interpret without requiring stakeholders to read the SQL queries.

## 9. Key Findings

The final numerical findings should be taken directly from the completed SQL outputs and Excel workbook.

The following observations are supported by the current analysis:

- The source dataset covers December 2009 through December 2011.
- The monthly sales chart shows substantial variation in sales across the analysis period, including visible peaks in late 2010 and late 2011.
- The top-products chart identifies products with the highest aggregated net sales proxy within the included transactions.
- The repeat-customer calculation measures repeat purchasing among customers with identifiable customer IDs.
- The monthly comparison includes both absolute sales changes and percentage MoM growth.

**Final KPI values:** 
net_sales_proxy	    : 20813918.43
total_orders	    : 45336
average_order_value : 459.1
transaction_lines	: 1047877

## 10. Business Recommendations

The analysis can support the following recommendations. Each should be reviewed against the final KPI results before being presented as a confirmed business conclusion.

1. **Monitor monthly sales:** Track monthly sales and MoM growth to identify unusually large increases or decreases and investigate the underlying transactions.
2. **Review leading products:** Examine the highest-ranked products when making inventory, merchandising, and product-promotion decisions.
3. **Track repeat purchasing:** Monitor the repeat-customer rate over time and investigate opportunities to encourage another purchase from one-time customers.
4. **Monitor average order value:** Compare AOV across reporting periods to understand changes in average spending per order.
5. **Improve reporting quality:** Standardize date handling, document cancellation and return treatment, and validate KPI totals before using them for business decisions.

These recommendations are analytical suggestions, not proof that a particular business intervention will increase sales.

## 11. Limitations

- The dataset represents historical transactions from one online retailer and may not represent other retailers or current market conditions.
- Missing customer identifiers prevent some transactions from being linked to a known customer.
- Excluding invoices beginning with `C` removes cancellation invoices, but negative quantities in other invoices remain in the analysis.
- The net sales proxy is calculated from quantity and unit price; it does not independently account for tax, shipping, discounts, or other accounting adjustments.
- The date normalization focuses on calendar dates. The analysis does not use the full timestamp for intraday behaviour.
- Repeat-customer rate depends on the identifiable customers and the included invoice records.
- Historical correlations and trends do not establish causation.
- Product descriptions may contain inconsistent wording or operational entries, so product rankings should be interpreted with care.

## 12. Use of AI and Verification

AI assistance was used to support the organization of project tasks, explain SQL concepts, troubleshoot queries, structure documentation, and improve the presentation of findings.

AI-generated suggestions were treated as guidance rather than automatically accepted results. SQL outputs were checked in DB Browser for SQLite, table structures and row counts were inspected, monthly aggregation totals were compared with overall totals, and KPI values and charts were reviewed in Excel.

## 13. Project Structure

project1/
├── README.md
├── queries.sql
├── recommendations.md
├── sql/
│   ├── day_05_kpi_analysis.sql
│   ├── day_05_validation.sql
│   ├── day_06_customer_analysis.sql
│   ├── day_07_window_functions.sql
│   └── day_08_kpi_analysis.sql
├── excel/
│   └── (optional working files or templates)
├── evidence/
│   ├── day_05_country_kpis.png
│   ├── day_05_monthly_kpis.png
│   ├── day_06_customer_analysis.png
│   ├── day_07_window_functions.png
│   ├── day_08_kpi_summary.png
│   ├── day_08_top_products_chart.png
│   └── day_08_monthly_sales_chart.png
├── database/
│   └── online_retail.db        [local only; do not commit]
├── data/
│   └── raw data files          [do not commit]
└── outputs/
    ├── overall_kpi_summary.csv
    ├── repeat_customer_rate.csv
    ├── top_10_products.csv
    ├── monthly_sales_mom.csv
    └── Online_Retail_II_KPI_Pack.xlsx

The excel/ directory is reserved for optional working spreadsheets and templates. The final KPI workbook and exported query results are stored in outputs/. The evidence/ directory contains screenshots documenting the SQL analysis, validation steps, and final dashboard. Raw source data and the local SQLite database are excluded from version control.

## 14. References and Attribution

Chen, D. (2012). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D

Dataset licence: Creative Commons Attribution 4.0 International (CC BY 4.0). Refer to the [official UCI dataset page](https://archive.ics.uci.edu/dataset/502/online+retail+ii) for the dataset description, licence, and citation information.
