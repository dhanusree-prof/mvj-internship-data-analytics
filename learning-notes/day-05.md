## Day 5 — Online Retail II Data Validation

### 1. Import Summary

The Online Retail II dataset was imported into SQLite as two separate tables.

| Period | Table name | Rows imported |
|---|---|---:|
| 2009–2010 | `retail_2009_2010` | 525,461 |
| 2010–2011 | `retail_2010_2011` | 541,910 |
| **Total** | | **1,067,371** |

Both tables contain eight columns: `Invoice`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `Price`, `Customer ID`, and `Country`.

### 2. Data Quality Findings

| Validation check | 2009–2010 | 2010–2011 |
|---|---:|---:|
| Missing descriptions | 2,928 | 1,454 |
| Missing customer IDs | 107,927 | 135,080 |
| Missing invoice dates | 0 | 0 |
| Missing countries | 0 | 0 |
| Cancellation rows detected | 10,206 | 9,288 |
| Negative quantity rows | 12,326 | 10,624 |
| Zero quantity rows | 0 | 0 |

### 3. Interpretation

- Both periods were imported, and their combined row count is 1,067,371.
- Customer IDs are missing for a substantial number of transactions. These records cannot reliably contribute to customer-level calculations such as repeat purchase rate.
- Cancellation identifiers were detected in both tables. Cancellation transactions must be handled consistently in revenue and order calculations.
- Negative quantities may represent returns or reversals and must be considered when calculating net revenue.
- No missing invoice dates or countries and no zero-quantity rows were detected in the checks performed.

### 4. Next Steps

The next stage is to calculate revenue, order counts, and average order value by month and country. The calculation rules will be documented, and the source data will remain unchanged.

## 5. Initial SQL KPI Findings

### Monthly analysis
- The monthly query groups transactions by year and month.
- December 2009 shows a net line value of 825,685.76, 1,929 distinct non-cancellation invoices, and an average order value of 428.04.
- March 2010 shows a net line value of 833,570.13, 1,960 distinct non-cancellation invoices, and an average order value of 425.29.
- September 2010 shows a net line value of 924,333.01, 2,004 distinct non-cancellation invoices, and an average order value of 461.24.

### Country analysis
- The United Kingdom has the highest displayed line value: 17,712,301.64, with 41,793 distinct non-cancellation invoices and an average order value of 423.81.
- The Netherlands shows an average order value of 2,420.23, with 229 distinct non-cancellation invoices.
- The results indicate that the country with the highest total line value does not necessarily have the highest average order value.

### Calculation notes and limitations
- Line value is calculated as Quantity multiplied by Price.
- Invoice identifiers are cast to text so cancellation identifiers beginning with C can be detected.
- Invoices beginning with C are excluded from the current order count and line-value calculations.
- Negative quantities on other invoices remain included. Therefore, the current revenue measure is provisional and should be described as net line value under the chosen filters, not as fully reconciled accounting revenue.
- Customer IDs are missing in many rows; customer-level metrics require additional handling.
- The monthly and country results should be validated and reconciled before final reporting.
