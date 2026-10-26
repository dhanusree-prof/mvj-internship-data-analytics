# Day 6 — SQL Joins, CASE and Customer Analysis

## Objective
Build a customer-level analysis table using SQL aggregation, joins and CASE-based segmentation.

## Dataset
Online Retail II — combined retail transaction data from 2009–2011.

## Work completed
- Reviewed the combined transaction data.
- Filtered out rows without customer IDs.
- Excluded cancellation invoices beginning with `C`.
- Calculated customer-level order counts, quantities and total line values.
- Used an INNER JOIN to combine customer metrics and purchase-date summaries.
- Used CASE to classify customers into One-time, Repeat and Frequent segments.
- Saved the SQL queries in `project1/sql/day_06_customer_analysis.sql`.

## Validation results
- Customers included: 5,881
- Distinct non-cancellation orders: 36,975
- Transaction lines included: 805,620

## Customer segmentation
- One-time: 1 order
- Repeat: 2–4 orders
- Frequent: 5 or more orders

Record the customer count for each segment after running the segment validation query.

## Limitations and notes
- Missing customer IDs are excluded from customer-level analysis.
- Cancellation invoices are excluded using the invoice prefix.
- Total line value is calculated as Quantity × Price. It should be treated as an analytical line-value measure, not independently verified accounting revenue.
- Purchase dates are currently stored as raw text and must be normalized before chronological analysis.
- Customer segments are rule-based categories created for this exercise.

## Learning resources
SQLBolt lessons and LeetCode SQL 50 problems completed.

## AI-use log
AI assistance was used to explain SQL structure and help develop queries. The queries were executed and their outputs checked.
