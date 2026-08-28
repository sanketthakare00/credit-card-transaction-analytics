USE cardcredit;

-- 1. Overall portfolio KPIs
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(CASE WHEN transaction_status = 'Approved' THEN transaction_amount ELSE 0 END), 2) AS approved_revenue,
    ROUND(AVG(CASE WHEN transaction_status = 'Approved' THEN transaction_amount END), 2) AS avg_approved_transaction_value,
    SUM(transaction_status = 'Approved') AS approved_transactions,
    SUM(transaction_status = 'Declined') AS declined_transactions,
    ROUND(100 * SUM(transaction_status = 'Declined') / COUNT(*), 2) AS decline_rate_percent
FROM cc_transaction;

-- 2. Transaction status mix
SELECT
    transaction_status,
    COUNT(*) AS txn_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM cc_transaction), 2) AS txn_percentage
FROM cc_transaction
GROUP BY transaction_status;

-- 3. Transaction amount by status
SELECT
    transaction_status,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM cc_transaction
GROUP BY transaction_status;
