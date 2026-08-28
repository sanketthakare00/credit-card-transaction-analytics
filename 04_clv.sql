USE cardcredit;

-- Historical CLV proxy for a one-year transaction dataset.
-- This is not a contractual/lending CLV model; it is a portfolio analytics proxy.
WITH customer_metrics AS (
    SELECT
        customer_id,
        COUNT(*) AS transactions,
        SUM(transaction_amount) AS total_spend,
        AVG(transaction_amount) AS avg_transaction_value,
        COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
)
SELECT
    customer_id,
    transactions,
    ROUND(total_spend, 2) AS historical_customer_value,
    ROUND(avg_transaction_value, 2) AS avg_transaction_value,
    active_months,
    ROUND(total_spend / NULLIF(active_months, 0), 2) AS avg_monthly_spend,
    ROUND((total_spend / NULLIF(active_months, 0)) * 12, 2) AS annualized_spend_proxy
FROM customer_metrics
ORDER BY annualized_spend_proxy DESC;

-- Portfolio-level CLV proxy summary
WITH customer_metrics AS (
    SELECT
        customer_id,
        SUM(transaction_amount) AS total_spend,
        COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
)
SELECT
    ROUND(AVG(total_spend), 2) AS avg_historical_customer_value,
    ROUND(AVG((total_spend / NULLIF(active_months, 0)) * 12), 2) AS avg_annualized_spend_proxy
FROM customer_metrics;
