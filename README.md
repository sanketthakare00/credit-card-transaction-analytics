# Credit Card Transaction & Customer Analytics

An end-to-end **synthetic credit card analytics project** using MySQL for portfolio and customer analysis and Tableau Public for visualization.

## Project Overview

This project analyzes **60,000 synthetic credit card transactions** across **7,995 unique customers** to evaluate transaction performance, revenue trends, customer value, revenue concentration, customer segmentation, and transaction decline patterns.

The analysis was designed to demonstrate practical SQL skills that are relevant to Data Analyst / Business Analyst roles in banking and financial services.

> **Data note:** All data is synthetic and created for portfolio/learning purposes. It does not represent a real bank, real customer, or confidential financial dataset.

## Business Questions

- What is the overall transaction approval/decline performance?
- How does approved revenue change month to month?
- Which customers generate the most value?
- How can customers be segmented using RFM behavior?
- Which customers represent retention or reactivation opportunities?
- How concentrated is portfolio revenue among customers?
- Which categories and merchants show elevated decline rates?
- How can customer activity be evaluated across cohorts?

## Dataset

| Metric | Value |
|---|---:|
| Total transactions | 60,000 |
| Approved transactions | 57,569 |
| Declined transactions | 2,431 |
| Approval rate | 95.95% |
| Decline rate | 4.05% |
| Approved transaction revenue | ₹530.23M |
| Declined transaction amount | ₹21.13M |
| Unique customers | 7,995 |
| Average approved transaction value | ₹9,210.36 |
| Transaction period | 2023 |

## Tools & Technologies

- **MySQL** — data loading, aggregation, window functions and analytical queries
- **SQL** — CTEs, `LAG()`, `NTILE()`, `RANK`/ranking logic, conditional aggregation, date analysis
- **Tableau Public** — dashboard and business visualization
- **CSV / Excel** — data preparation and visualization source

## SQL Analysis

### 1. Portfolio KPIs

Calculated transaction volume, approval/decline rates, approved revenue, declined transaction value, customer count and average transaction value.

### 2. Monthly Revenue & MoM Growth

Used monthly aggregation and `LAG()` to calculate month-over-month revenue changes and cumulative revenue.

### 3. RFM Customer Segmentation

Built customer-level recency, frequency and monetary measures and used `NTILE(5)` to create directional quintile scores. Customers were then grouped into business-oriented segments.

### 4. Customer Lifetime Value

Created a **historical CLV proxy** using customer spend, transaction frequency, average transaction value and active months. This is an analytical proxy, not a production banking CLV model.

### 5. Revenue Concentration

Ranked customers by approved spend and calculated cumulative revenue to identify the number of customers required to reach 80% of portfolio revenue.

### 6. Category & Merchant Analysis

Compared approved revenue across categories and calculated transaction decline rates by category and merchant.

### 7. Cohort Analysis

Grouped customers by first approved transaction month and tracked subsequent monthly activity to evaluate retention patterns.

## Key Business Insights

### Revenue concentration

**4,287 customers** are required to account for 80% of approved revenue. Against 7,995 unique customers, this is approximately **53.62% of the customer base**.

This indicates that retention and value-management initiatives can have a disproportionate impact when focused on higher-value customers.

### Customer segmentation

| Segment | Customers | Revenue | Revenue Share |
|---|---:|---:|---:|
| Champions | 1,063 | ₹127.62M | 24.07% |
| Lost Customers | 2,889 | ₹119.22M | 22.48% |
| Big Spenders | 1,036 | ₹114.51M | 21.60% |
| Loyal Customers | 1,454 | ₹101.20M | 19.09% |
| Potential Loyalists | 833 | ₹36.58M | 6.90% |
| At Risk | 720 | ₹31.11M | 5.87% |

A particularly important finding is that **Lost Customers contribute 22.48% of revenue** in the segmentation output. This suggests a meaningful reactivation opportunity rather than treating the segment as simply low-value churn.

**Champions + Big Spenders contribute 45.67% of revenue**, making retention of these groups strategically important.

### Monthly performance

Approved monthly revenue remained relatively stable throughout 2023, with the highest monthly revenue at approximately **₹45.93M** and the lowest at approximately **₹43.17M**.

The SQL MoM analysis is useful for identifying short-term changes that are hidden by a stable annual total.

## Business Recommendations

1. **Protect high-value customers** — prioritize Champions and Big Spenders for retention and personalized offers.
2. **Reactivate valuable inactive customers** — investigate Lost Customers by historical spend and recency before designing win-back campaigns.
3. **Create early-warning rules** — monitor declining recency/frequency to identify customers moving toward At Risk or Lost segments.
4. **Investigate decline concentration** — break declines down by category, merchant, geography, transaction size and decline reason.
5. **Prioritize using revenue concentration** — use customer value tiers to focus retention resources where the revenue impact is greatest.
6. **Monitor monthly volatility** — use MoM reporting to detect abrupt changes early.

## Tableau Dashboard

The Tableau layer includes:

- Portfolio KPI cards
- Monthly approved transaction revenue
- Month-over-month revenue growth
- Approved revenue by category
- Decline rate by category
- Merchant decline-rate analysis

![Tableau Dashboard](tableau/dashboard_screenshot.png)

> **Tableau source note:** the current screenshot was produced from a different imported Excel/CSV data state, so its displayed KPI values do not exactly reconcile with the MySQL source-of-truth figures above. The final portfolio version should refresh Tableau against the canonical dataset in `data/credit_card_transactions.csv`.

## Repository Structure

```text
credit-card-transaction-analytics/
├── README.md
├── data/
│   ├── credit_card_transactions.csv
│   └── credit_card_dataset_full.sql
├── sql/
│   ├── 00_schema.sql
│   ├── 01_kpis.sql
│   ├── 02_monthly_analysis.sql
│   ├── 03_rfm_segmentation.sql
│   ├── 04_clv.sql
│   ├── 05_revenue_concentration.sql
│   ├── 06_category_merchant_analysis.sql
│   └── 07_cohort_analysis.sql
├── tableau/
│   ├── dashboard_screenshot.png
│   └── README.md
└── report/
    └── credit_card_transaction_analytics_final_report.pdf
```
