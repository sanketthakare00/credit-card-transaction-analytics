USE cardcredit;

-- Monthly customer cohorts based on each customer's first approved transaction.
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(transaction_date) AS first_purchase_date
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
),
activity AS (
    SELECT DISTINCT
        t.customer_id,
        DATE_FORMAT(fp.first_purchase_date, '%Y-%m') AS cohort_month,
        TIMESTAMPDIFF(MONTH, fp.first_purchase_date, t.transaction_date) AS month_number
    FROM cc_transaction t
    JOIN first_purchase fp ON t.customer_id = fp.customer_id
    WHERE t.transaction_status = 'Approved'
),
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_customers
    FROM activity
    WHERE month_number = 0
    GROUP BY cohort_month
)
SELECT
    a.cohort_month,
    a.month_number,
    COUNT(DISTINCT a.customer_id) AS active_customers,
    cs.cohort_customers,
    ROUND(100 * COUNT(DISTINCT a.customer_id) / cs.cohort_customers, 2) AS retention_percent
FROM activity a
JOIN cohort_size cs ON a.cohort_month = cs.cohort_month
GROUP BY a.cohort_month, a.month_number, cs.cohort_customers
ORDER BY a.cohort_month, a.month_number;
