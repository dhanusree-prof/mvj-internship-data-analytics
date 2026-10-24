# Day 4 — Excel What-If Analysis and Forecasting

**Date:** 20 October 2026  
**Track:** Data Analytics  
**Focus:** Excel 2 — What-if analysis and forecasting

## 1. Learning Objectives

- Understand how price, customer footfall and operating days affect monthly revenue.
- Explore Goal Seek, Data Tables and Scenario Manager concepts.
- Build a simple sales forecast using historical monthly sales.
- Begin Project 1 using the Online Retail II dataset.

## 2. What-If Revenue Model

Created `Day_04_What_If_and_Forecasting.xlsx` with a revenue model using:

- Selling price per customer
- Daily customer footfall
- Operating days per month
- Expected monthly revenue
- Monthly revenue target
- Difference between expected revenue and target

**Test case:** At a selling price of ₹150, 100 customers per day and 30 operating days, monthly revenue is ₹450,000.

## 3. What-If Analysis

Because the work was completed in Excel Online, formula-based alternatives were used where the native What-If Analysis tools were unavailable.

- **Goal Seek alternative:** Calculated the required footfall and price to reach the revenue target.
- **Data Table alternative:** Created a price-and-footfall sensitivity grid.
- **Scenario Manager alternative:** Compared low, normal and high footfall scenarios.

Scenario results at ₹150 per customer and 30 operating days:

| Scenario | Daily footfall | Monthly revenue |
|---|---:|---:|
| Low footfall | 60 | ₹270,000 |
| Normal footfall | 80 | ₹360,000 |
| High footfall | 100 | ₹450,000 |

These are formula-based comparisons, not scenarios saved using Excel's native Scenario Manager.

## 4. Forecasting Exercise

Added a `Forecasting` sheet to `Day_03_Coffee_Shop_KPI_Analysis.xlsx`.

- Linked historical monthly sales.
- Used `FORECAST.LINEAR` to estimate the next three months.
- Created a line chart comparing actual sales and forecast sales.

The forecast is a basic linear-trend estimate and should not be interpreted as guaranteed future sales. Excel's native Forecast Sheet feature was not used.

## 5. Project 1 Initiation

Started Project 1: Online Retail II KPI Analysis.

- Downloaded the dataset from the UCI Machine Learning Repository.
- Stored the dataset locally in the `project1/data` folder.
- Began preparing the project documentation and folder structure.

Official source: https://archive.ics.uci.edu/dataset/502/online+retail+ii

## 6. Limitations and Next Steps

- Formula-based alternatives were used for the what-if exercises because the required native tools were not available in Excel Online.
- Forecast accuracy has not been evaluated against future actual sales.
- Next steps: inspect the dataset, load it into SQLite or DuckDB, calculate revenue, order count and average order value by month and country, and validate the results.

## 7. AI Assistance and Validation

AI assistance was used to explain spreadsheet formulas, structure the what-if analysis, and troubleshoot the chart. Formulas, scenario values and chart structure were checked in Excel. The work should be described as formula-based analysis rather than use of unavailable native Excel features.