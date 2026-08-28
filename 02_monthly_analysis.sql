USE cardcredit;

-- Monthly approved transaction revenue
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS month,
        SUM(transaction_amount) AS monthly_revenue
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
)
SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY month), 2) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;

-- Month-over-month revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS month,
        SUM(transaction_amount) AS monthly_revenue
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
),
with_previous AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(100 * (monthly_revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0), 2) AS mom_growth_percent
FROM with_previous
ORDER BY month;
