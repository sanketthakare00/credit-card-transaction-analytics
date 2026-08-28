USE cardcredit;

-- Customer-level summary for approved transactions.
WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(*) AS total_transactions,
        ROUND(SUM(transaction_amount), 2) AS total_spend,
        DATEDIFF(
            (SELECT MAX(transaction_date) FROM cc_transaction WHERE transaction_status = 'Approved'),
            MAX(transaction_date)
        ) AS days_since_last_transaction
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
),
rfm AS (
    SELECT
        customer_id,
        total_transactions,
        total_spend,
        days_since_last_transaction,
        NTILE(5) OVER (ORDER BY days_since_last_transaction DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_transactions DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY total_spend DESC) AS monetary_score
    FROM customer_summary
)
SELECT
    customer_id,
    total_transactions,
    total_spend,
    days_since_last_transaction,
    recency_score,
    frequency_score,
    monetary_score,
    CONCAT(recency_score, frequency_score, monetary_score) AS rfm_score
FROM rfm
ORDER BY total_spend DESC;

-- Example business segmentation built from the RFM scores.
-- Adjust thresholds if you want to reproduce a specific segmentation policy.
WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(*) AS total_transactions,
        SUM(transaction_amount) AS total_spend,
        DATEDIFF(
            (SELECT MAX(transaction_date) FROM cc_transaction WHERE transaction_status = 'Approved'),
            MAX(transaction_date)
        ) AS days_since_last_transaction
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
),
rfm AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY days_since_last_transaction DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY total_transactions DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY total_spend DESC) AS monetary_score
    FROM customer_summary
),
segmented AS (
    SELECT *,
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN monetary_score = 5 AND recency_score >= 3 THEN 'Big Spenders'
            WHEN recency_score >= 3 AND frequency_score >= 4 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score BETWEEN 2 AND 3 THEN 'Potential Loyalists'
            WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
            ELSE 'Lost Customers'
        END AS customer_segment
    FROM rfm
)
SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(total_spend), 2) AS avg_customer_value,
    ROUND(SUM(total_spend), 2) AS total_revenue,
    ROUND(100 * SUM(total_spend) / SUM(SUM(total_spend)) OVER (), 2) AS revenue_rate
FROM segmented
GROUP BY customer_segment
ORDER BY total_revenue DESC;
