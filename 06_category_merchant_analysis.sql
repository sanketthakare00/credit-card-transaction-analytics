USE cardcredit;

-- Approved revenue by category
SELECT
    category,
    COUNT(*) AS approved_transactions,
    ROUND(SUM(transaction_amount), 2) AS approved_revenue
FROM cc_transaction
WHERE transaction_status = 'Approved'
GROUP BY category
ORDER BY approved_revenue DESC;

-- Decline rate by category
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(transaction_status = 'Declined') AS declined_transactions,
    ROUND(100 * SUM(transaction_status = 'Declined') / COUNT(*), 2) AS decline_rate_percent
FROM cc_transaction
GROUP BY category
ORDER BY decline_rate_percent DESC;

-- Merchants with the highest decline rates
SELECT
    merchant_name,
    COUNT(*) AS total_transactions,
    SUM(transaction_status = 'Declined') AS declined_transactions,
    ROUND(100 * SUM(transaction_status = 'Declined') / COUNT(*), 2) AS decline_rate_percent
FROM cc_transaction
GROUP BY merchant_name
HAVING COUNT(*) >= 100
ORDER BY decline_rate_percent DESC, total_transactions DESC;

-- Decline reasons
SELECT
    decline_reason,
    COUNT(*) AS declined_transactions,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM cc_transaction WHERE transaction_status = 'Declined'), 2) AS share_of_declines
FROM cc_transaction
WHERE transaction_status = 'Declined'
GROUP BY decline_reason
ORDER BY declined_transactions DESC;
