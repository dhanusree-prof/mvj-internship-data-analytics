# Namma Metro KPI Tree

## 1. Project Overview

**Objective:** Develop a KPI framework to understand Namma Metro's
ridership, peak-hour demand and revenue performance.

**Business question:** How can Namma Metro monitor passenger demand,
understand peak-hour patterns and assess fare revenue performance
to support better operational decisions?

**Scope:** This document defines proposed KPIs and their formulas.
It does not claim to contain measured or verified operational results.

## 2. KPI Tree

Namma Metro Performance
|
+-- A. Ridership
|   |
|   +-- Total passenger journeys
|   +-- Average daily ridership
|   +-- Ridership growth (%)
|   +-- Station-wise ridership
|   +-- Line-wise ridership
|
+-- B. Peak Share
|   |
|   +-- Peak-hour ridership
|   +-- Peak share (%)
|   +-- Off-peak ridership
|   +-- Peak-to-off-peak ratio
|   +-- Peak demand by station or line
|
+-- C. Revenue Proxies
    |
    +-- Estimated fare revenue
    +-- Average revenue per journey
    +-- Fare revenue growth (%)
    +-- Non-fare revenue
    +-- Revenue per operating day

## 3. KPI Definitions and Formulas

### A. Ridership

**1. Total Ridership**
- Definition: Total passenger journeys during a selected period.
- Formula: Sum of passenger journeys.
- Purpose: Measures overall demand for metro services.

**2. Average Daily Ridership**
- Formula: Total passenger journeys / number of operating days.
- Purpose: Enables comparisons across periods of different lengths.

**3. Ridership Growth (%)**
- Formula: ((Current period ridership - Previous period ridership)
  / Previous period ridership) * 100.
- Purpose: Measures growth or decline in passenger demand.
- Note: Handle a zero previous-period value separately.

**4. Station-wise Ridership**
- Definition: Passenger journeys grouped by station.
- Purpose: Identifies stations with relatively high or low demand.

**5. Line-wise Ridership**
- Definition: Passenger journeys grouped by metro line.
- Purpose: Compares demand across lines.

### B. Peak Share

**1. Peak-hour Ridership**
- Definition: Passenger journeys during predefined peak hours.
- Purpose: Measures demand during busy periods.

**2. Peak Share (%)**
- Formula: (Peak-hour passenger journeys / Total passenger journeys)
  * 100.
- Purpose: Measures the share of total journeys occurring during
  peak hours.

**3. Off-peak Ridership**
- Definition: Passenger journeys outside the selected peak hours.
- Purpose: Measures demand outside busy periods.

**4. Peak-to-off-peak Ratio**
- Formula: Peak-hour passenger journeys / Off-peak passenger journeys.
- Purpose: Compares peak demand with off-peak demand.
- Note: Handle a zero off-peak value separately.

**5. Peak Demand by Station or Line**
- Definition: Peak-hour journeys grouped by station or line.
- Purpose: Helps identify locations where capacity and crowding
  require further investigation.

### C. Revenue Proxies

**1. Estimated Fare Revenue**
- Formula: Passenger journeys * assumed average fare per journey.
- Purpose: Provides a rough estimate when actual fare revenue
  is unavailable.
- Limitation: This is an estimate, not actual revenue.

**2. Average Revenue per Journey**
- Formula: Actual fare revenue / Passenger journeys.
- Purpose: Measures realised fare revenue per journey.
- Requirement: Actual fare revenue and comparable ridership data.

**3. Fare Revenue Growth (%)**
- Formula: ((Current period fare revenue - Previous period fare revenue)
  / Previous period fare revenue) * 100.
- Purpose: Tracks changes in fare revenue over time.
- Note: Handle a zero previous-period value separately.

**4. Non-fare Revenue**
- Definition: Revenue from sources such as advertising, rentals,
  commercial activities and sponsorships, where applicable.
- Measurement: Sum of recorded non-fare revenue.
- Purpose: Monitors revenue beyond passenger fares.
- Requirement: Financial or operational revenue records.

**5. Revenue per Operating Day**
- Formula: Revenue / Number of operating days.
- Purpose: Compares revenue across periods of different lengths.

## 4. Four Types of Analytics

### Descriptive Analytics - What happened?
Summarises historical ridership, peak share and revenue trends.

Example: Calculate average daily ridership for each month.

### Diagnostic Analytics - Why did it happen?
Investigates factors associated with changes in performance.

Example: Investigate a ridership decline by station, line, weekday
or time of day.

### Predictive Analytics - What might happen next?
Uses historical data and suitable explanatory variables to forecast
future demand.

Example: Forecast passenger demand for upcoming peak periods.

### Prescriptive Analytics - What should we do?
Evaluates possible actions based on analysis and operational
constraints.

Example: Assess whether changing train frequency during busy
periods could help manage passenger demand.

## 5. Questions for Management

1. Is total ridership increasing or decreasing?
2. Which stations and lines record the highest passenger demand?
3. What proportion of journeys occurs during peak hours?
4. Which stations or lines show concentrated peak-hour demand?
5. How does fare revenue change over time?
6. How much revenue comes from fares compared with non-fare sources?
7. What operational actions could improve service and manage demand?

## 6. Data Requirements

Potential data fields include:
- Date and time
- Station and metro line
- Passenger journey or entry/exit counts
- Peak/off-peak classification
- Fare revenue
- Ticket or fare category, where available
- Non-fare revenue, where available
- Operating-day status

Possible starting point: BMRCL official annual reports.
https://www.bmrc.co.in/annual-reports/

The availability and level of detail of these fields must be checked
before calculating the KPIs.

## 7. Assumptions and Limitations

- The KPIs in this document are proposed measures, not verified
  operational results.
- Peak hours must be defined consistently using a suitable source
  or an explicitly documented analytical assumption.
- Passenger journeys and unique passengers are not interchangeable.
- Estimated fare revenue must not be reported as actual collections.
- Ridership alone cannot establish actual fare revenue or profitability.
- Revenue comparisons should use consistent reporting periods and
  clearly defined revenue categories.
- Forecasts require historical data and appropriate validation.
- Recommendations must consider safety, capacity, costs and
  operational feasibility.

## 8. Next Steps

1. Identify suitable public ridership and financial data.
2. Check the source, licence, reporting period and available fields.
3. Calculate the KPIs that the data supports.
4. Compare trends across periods, stations and lines.
5. Develop evidence-based recommendations.

## 9. AI Use and Verification

AI assistance was used to help structure the KPI framework,
explain KPI definitions and organise the documentation.

The formulas and assumptions should be reviewed before use.
No KPI values have been presented as verified measurements in
this document.

## 10. References

- MVJ Degree College, BCA (Data Science) Internship 2026-27,
  Data Analytics Track handbook, Day 2 plan.
- Bangalore Metro Rail Corporation Limited (BMRCL), official
  annual reports: https://www.bmrc.co.in/annual-reports/
