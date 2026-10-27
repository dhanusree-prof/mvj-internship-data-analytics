# Day 7 — SQL Window Functions

## Objective
Practise SQL window functions to analyse monthly sales, rank products, and identify customer purchase cohorts using the Online Retail II dataset.

## Analyses completed
- Prepared monthly sales using standardized transaction dates.
- Calculated cumulative monthly sales using `SUM() OVER()`.
- Compared monthly sales using `LAG()` and calculated month-on-month change.
- Ranked products within each country using `ROW_NUMBER()` and `PARTITION BY`.
- Identified each customer's first purchase month.
- Summarized customers by first purchase month.

## Data handling
- Excluded invoices beginning with `C` from the analyses.
- Calculated line value as `Quantity * Price`.
- Standardized dates to `YYYY-MM-DD` and grouped monthly results as `YYYY-MM`.
- Retained negative quantities on non-cancellation invoices; line value should not automatically be interpreted as official revenue.

## Validation
- First month: 2009-12
- Last month: 2011-12
- Normalized transaction row count: [enter your result]
- Number of monthly records: [enter your result]
- Validation issues: [enter result or write "None observed"]

## Learning activities
- Kaggle Advanced SQL: [actual status]
- LeetCode SQL 50: [list completed problems or actual status]
- HackerRank SQL Basic: [challenge/test attempted and actual status]

## Key learning
Window functions calculate values across related rows without collapsing the result into one row per group. `SUM() OVER()` supports running totals, `LAG()` enables comparisons with previous rows, and `ROW_NUMBER()` supports ranking within groups.


