# Project 1: Online Retail KPI Analysis

## 1. Project Overview

This project analyzes the Online Retail II dataset to understand sales performance across different months and countries. SQL is used to calculate business KPIs and identify patterns in revenue, order volume, and average order value.

**Business question:** How do sales value, order volume, and average order value vary over time and across countries?

**Intended audience:** Retail business managers and analysts who need to understand sales performance and identify areas for further investigation.

## 2. Objectives

- Load and validate the Online Retail II dataset using SQLite.
- Calculate revenue-related measures and order counts by month and country.
- Calculate average order value (AOV).
- Examine data quality issues, including missing values, cancellations, and negative quantities.
- Document findings, calculation methods, and limitations.
- Prepare the results for further analysis in Excel.

## 3. Dataset and Source

- **Dataset:** Online Retail II
- **Source:** UCI Machine Learning Repository
- **Dataset page:** https://archive.ics.uci.edu/dataset/502/online+retail+ii
- **Citation:** Chen, D. (2012). *Online Retail II* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D
- **Licence:** CC BY 4.0
- **Original file:** `online_retail_II.xlsx`
- **Source worksheets:** `year 2009-2010` and `year 2010-2011`

The original workbook was exported into two CSV files for import into SQLite. The raw workbook and CSV files are retained locally and are not intended to be committed to GitHub because of their size.

## 4. Tools Used

- SQLite
- DB Browser for SQLite
- SQL
- Microsoft Excel or a compatible spreadsheet application
- Git and GitHub for version control and documentation

## 5. Repository Structure

```text
project1/
├── data/          # Local source workbook and CSV exports
├── database/      # Local SQLite database
├── sql/           # SQL validation and KPI queries
├── excel/         # Excel KPI analysis and workbook
├── evidence/      # Screenshots of validation and results
└── README.md      # Project documentation
```

The large raw data files and local database are excluded from GitHub commits. SQL scripts, documentation, and appropriate evidence are maintained in the repository.

## 6. Data Preparation and Validation

The two worksheets were imported into SQLite as separate tables:

- `retail_2009_2010`
- `retail_2010_2011`

The tables contain the following columns:

- `Invoice`
- `StockCode`
- `Description`
- `Quantity`
- `InvoiceDate`
- `Price`
- `Customer ID`
- `Country`

### Import summary

| Period | Imported rows |
|---|---:|
| 2009–2010 | 525,461 |
| 2010–2011 | 541,910 |
| **Total** | **1,067,371** |

### Data quality checks

| Check | 2009–2010 | 2010–2011 |
|---|---:|---:|
| Missing descriptions | 2,928 | 1,454 |
| Missing customer IDs | 107,927 | 135,080 |
| Missing invoice dates | 0 | 0 |
| Missing countries | 0 | 0 |
| Cancellation rows detected | 10,206 | 9,288 |
| Negative quantity rows | 12,326 | 10,624 |
| Zero quantity rows | 0 | 0 |

These checks were performed using SQL. The original data was retained without deleting rows during the initial validation stage.

## 7. KPI Definitions

### Line value

Calculated for each transaction line as:

`Quantity × Price`

### Order count

The number of distinct invoice identifiers after excluding invoices whose identifiers begin with `C`, which are treated as cancellation invoices for the current analysis.

### Average order value (AOV)

Calculated as:

`AOV = Total line value / Distinct non-cancellation invoice count`

### Monthly analysis

The transaction date is converted to a year-month format to group the results by calendar month.

### Country analysis

The same line-value, order-count, and AOV calculations are grouped by country.

**Calculation note:** The current queries exclude cancellation invoices but retain negative quantities on other invoices. The resulting line-value measure is therefore a preliminary measure under the chosen filters and has not yet been fully reconciled as accounting revenue.

## 8. Initial Findings

The initial SQL queries executed successfully and produced monthly and country-level results.

- December 2009 recorded a line value of 825,685.76, 1,929 distinct non-cancellation invoices, and an AOV of 428.04.
- March 2010 recorded a line value of 833,570.13, 1,960 distinct non-cancellation invoices, and an AOV of 425.29.
- September 2010 recorded a line value of 924,333.01, 2,004 distinct non-cancellation invoices, and an AOV of 461.24.
- The United Kingdom had the highest line value among the countries shown in the initial results: 17,712,301.64, with 41,793 distinct non-cancellation invoices and an AOV of 423.81.
- The Netherlands had an AOV of 2,420.23 across 229 distinct non-cancellation invoices in the displayed results.

These are initial results, not final business conclusions. The analysis will be extended and validated before final recommendations are made.

## 9. SQL Files

The SQL scripts are maintained in the `sql/` directory.

- `day_05_validation.sql` — table structure, row counts, missing values, cancellation checks, and other validation queries.
- `day_05_kpi_analysis.sql` — combined transaction view and monthly and country-level KPI queries.

## 10. Limitations

- A substantial number of records have missing customer IDs, limiting customer-level analysis.
- Cancellation invoices and negative quantities require careful treatment when defining revenue.
- The current KPI calculations are preliminary and should be reconciled before final reporting.
- The analysis describes the transactions available in the dataset and does not establish the causes behind sales differences between countries or months.
- Country-level AOV can be affected by differences in order volume and order composition.
- The dataset does not, by itself, explain customer motivations or future sales performance.

## 11. Next Steps

1. Validate the SQL KPI calculations and document the revenue definition.
2. Build an Excel KPI workbook to present monthly and country-level results.
3. Extend the SQL analysis to customer-level metrics using joins and `CASE` expressions.
4. Calculate repeat purchase rate, top products, and month-on-month growth.
5. Develop five evidence-based business recommendations.
6. Update the project documentation and evidence as the analysis progresses.

## 12. Use of AI

AI assistance was used to support SQL query drafting, explain validation steps, and structure project documentation. Queries were executed in DB Browser for SQLite, and the displayed results were used to check whether the SQL ran successfully. Further validation of the KPI definitions and results is required before final recommendations are made.


