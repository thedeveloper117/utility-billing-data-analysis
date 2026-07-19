# Utility Billing Data Analysis — Data Analyst Portfolio Project

## Overview
This project simulates a real-world data analyst workflow for a **utility bills management company**, covering electricity, water, gas, and telecom billing. It mirrors the type of work described in the "Data Analyst" experience on my resume: collecting, cleaning, validating, and analyzing billing data to catch discrepancies, track KPIs, and support business decisions.

## Objective
- Identify billing discrepancies between expected and actual billed amounts
- Track consumption and revenue trends across utility types and regions
- Build a KPI dashboard for management reporting
- Monitor payment status (Paid / Pending / Overdue) for collections follow-up

## Dataset
A synthetic dataset of **2,451 billing records** across 120 customers, 5 regions, 4 utility types, and 6 months (Jan–Jun 2024). Fields include customer ID, region, utility type, billing month, units consumed, rate per unit, expected amount, billed amount, payment status, and due/paid dates. A controlled ~12% error rate was injected into billed amounts to simulate real billing discrepancies.

> Note: This is synthetic data generated for portfolio/demonstration purposes — it does not represent any real company's records.

## Tools Used
| Tool | Purpose |
|---|---|
| **Microsoft Excel** (Pivot-style SUMIFS/COUNTIFS tables, Power Query-style structured tables, charts) | Data cleaning, KPI summaries, dashboard |
| **SQL** | Data extraction, discrepancy detection, trend & collections queries |
| **Python (pandas)** | Synthetic dataset generation |

## Files in This Project
```
utility-billing-analysis/
├── README.md                                # This file
├── data/
│   └── utility_billing_raw.csv              # Raw dataset (2,451 records)
├── Utility_Billing_Analysis.xlsx            # Excel workbook (see sheets below)
└── sql/
    └── utility_billing_queries.sql          # SQL schema + analysis queries
```

### Excel workbook sheets
1. **Raw Data** – full billing dataset as a structured Excel table
2. **Summary by Utility** – bills, consumption, billed amount, and discrepancy rate per utility type (SUMIFS/COUNTIFS formulas)
3. **Summary by Region** – bills, billed amount, and payment status breakdown per region
4. **KPI Dashboard** – key metrics plus a bar chart (billed amount by utility) and pie chart (payment status distribution)
5. **Discrepancy Report** – filtered, filterable list of all flagged billing discrepancies

All summary figures are live formulas linked to the Raw Data sheet — updating the raw data recalculates every table and chart automatically.

## Key Insights (from this dataset)
- **8.8%** of bills (216 of 2,451) had a discrepancy between expected and billed amount, totaling **₹13,261.74** in over/under-billing
- **Electricity** had the highest discrepancy rate at **12.7%**, making it the top priority for billing process review
- **294 bills** were in Overdue status — flagged in the Discrepancy Report / Summary sheets for collections follow-up
- Regional billed amounts were fairly evenly distributed, with no single region driving cost overruns

## How to Reproduce
1. Load `data/utility_billing_raw.csv` into Excel, Power BI, or a SQL database
2. Run the queries in `sql/utility_billing_queries.sql` to reproduce the discrepancy and trend analysis
3. Open `Utility_Billing_Analysis.xlsx` to explore the pre-built summaries, KPI dashboard, and discrepancy report
