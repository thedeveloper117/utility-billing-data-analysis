/* =====================================================================
   Utility Billing Data Analysis – SQL Queries
   Project: Utility Billing Data Analysis (Data Analyst Portfolio Project)
   Author : Surya
   Notes  : Written for MySQL / PostgreSQL syntax. Minor syntax
            adjustments may be needed depending on your RDBMS.
   ===================================================================== */

-- ---------------------------------------------------------------------
-- 1. Table structure
-- ---------------------------------------------------------------------
CREATE TABLE utility_billing (
    bill_id            VARCHAR(15) PRIMARY KEY,
    customer_id        VARCHAR(15) NOT NULL,
    region             VARCHAR(20),
    utility_type       VARCHAR(20),
    bill_month         VARCHAR(10),
    units_consumed     DECIMAL(10,2),
    rate_per_unit      DECIMAL(10,2),
    expected_amount    DECIMAL(12,2),
    billed_amount      DECIMAL(12,2),
    payment_status     VARCHAR(15),
    due_date           DATE,
    paid_date          DATE
);

-- ---------------------------------------------------------------------
-- 2. Data extraction & cleaning checks
-- ---------------------------------------------------------------------

-- 2a. Check for missing / null values in key columns
SELECT *
FROM utility_billing
WHERE customer_id IS NULL
   OR units_consumed IS NULL
   OR billed_amount IS NULL;

-- 2b. Check for duplicate bill records
SELECT bill_id, COUNT(*) AS occurrences
FROM utility_billing
GROUP BY bill_id
HAVING COUNT(*) > 1;

-- ---------------------------------------------------------------------
-- 3. Billing discrepancy analysis
-- ---------------------------------------------------------------------

-- 3a. Flag bills where billed amount differs from expected amount
SELECT
    bill_id,
    customer_id,
    utility_type,
    bill_month,
    expected_amount,
    billed_amount,
    (billed_amount - expected_amount) AS discrepancy
FROM utility_billing
WHERE ABS(billed_amount - expected_amount) > 1
ORDER BY ABS(billed_amount - expected_amount) DESC;

-- 3b. Discrepancy rate by utility type
SELECT
    utility_type,
    COUNT(*) AS total_bills,
    SUM(CASE WHEN ABS(billed_amount - expected_amount) > 1 THEN 1 ELSE 0 END) AS flagged_bills,
    ROUND(
        SUM(CASE WHEN ABS(billed_amount - expected_amount) > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS discrepancy_rate_pct
FROM utility_billing
GROUP BY utility_type
ORDER BY discrepancy_rate_pct DESC;

-- ---------------------------------------------------------------------
-- 4. Consumption & revenue trends
-- ---------------------------------------------------------------------

-- 4a. Monthly consumption trend by utility type
SELECT
    bill_month,
    utility_type,
    SUM(units_consumed) AS total_units,
    SUM(billed_amount)  AS total_billed
FROM utility_billing
GROUP BY bill_month, utility_type
ORDER BY bill_month, utility_type;

-- 4b. Total billed amount and average consumption by region
SELECT
    region,
    COUNT(*) AS total_bills,
    ROUND(AVG(units_consumed), 2) AS avg_units_consumed,
    SUM(billed_amount) AS total_billed_amount
FROM utility_billing
GROUP BY region
ORDER BY total_billed_amount DESC;

-- ---------------------------------------------------------------------
-- 5. Payment status & collections monitoring
-- ---------------------------------------------------------------------

-- 5a. Count of bills by payment status
SELECT payment_status, COUNT(*) AS bill_count
FROM utility_billing
GROUP BY payment_status;

-- 5b. Overdue bills requiring follow-up (oldest first)
SELECT
    bill_id, customer_id, region, utility_type,
    billed_amount, due_date
FROM utility_billing
WHERE payment_status = 'Overdue'
ORDER BY due_date ASC;

-- ---------------------------------------------------------------------
-- 6. Cost-saving / high-consumption insights
-- ---------------------------------------------------------------------

-- 6a. Top 10 customers by total consumption (candidates for usage review)
SELECT
    customer_id,
    SUM(units_consumed) AS total_units_consumed,
    SUM(billed_amount)  AS total_billed_amount
FROM utility_billing
GROUP BY customer_id
ORDER BY total_units_consumed DESC
LIMIT 10;

-- 6b. Average bill amount per utility type (baseline for anomaly detection)
SELECT
    utility_type,
    ROUND(AVG(billed_amount), 2) AS avg_billed_amount
FROM utility_billing
GROUP BY utility_type;
