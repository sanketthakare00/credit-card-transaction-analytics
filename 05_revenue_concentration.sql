USE cardcredit;

-- Rank customers by approved spend and calculate cumulative revenue share.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(transaction_amount) AS total_spend
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_spend,
        SUM(total_spend) OVER (ORDER BY total_spend DESC, customer_id) AS cumulative_revenue,
        SUM(total_spend) OVER () AS portfolio_revenue
    FROM customer_revenue
),
scored AS (
    SELECT
        customer_id,
        total_spend,
        cumulative_revenue,
        portfolio_revenue,
        100 * cumulative_revenue / portfolio_revenue AS cumulative_revenue_percent
    FROM ranked
)
SELECT *
FROM scored
ORDER BY total_spend DESC;

-- Number of customers required to reach 80% of approved revenue.
WITH customer_revenue AS (
    SELECT customer_id, SUM(transaction_amount) AS total_spend
    FROM cc_transaction
    WHERE transaction_status = 'Approved'
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        total_spend,
        SUM(total_spend) OVER (ORDER BY total_spend DESC, customer_id) AS cumulative_revenue,
        SUM(total_spend) OVER () AS portfolio_revenue
    FROM customer_revenue
),
threshold AS (
    SELECT
        COUNT(*) AS customers_needed_for_80_percent_revenue
    FROM ranked
    WHERE cumulative_revenue <= portfolio_revenue * 0.80
)
SELECT
    customers_needed_for_80_percent_revenue + 1 AS customers_needed_for_80_percent_revenue
FROM threshold;
