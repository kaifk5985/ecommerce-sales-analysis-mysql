-- E-Commerce Sales Analysis Using MySQL
-- File: 02_data_analysis.sql
-- Purpose: Business analysis queries only.
-- Prerequisite: Run 01_database_setup.sql and 03_sample_data.sql
-- on a fresh/empty database before running these queries.
-- This file does NOT create tables or insert sample data.

USE ecommerce_db;

-- 1. View all customers
SELECT *
FROM customers;

-- 2. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 3. View all products
SELECT *
FROM products;

-- 4. Total number of products
SELECT COUNT(*) AS total_products
FROM products;

-- 5. View all orders with customer names
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
ORDER BY o.order_date, o.order_id;

-- 6. Total value of each order
SELECT
    oi.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM order_items AS oi
GROUP BY oi.order_id
ORDER BY order_total DESC;

-- 7. Spending by customer across all order statuses
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spending DESC;

-- 8. Monthly revenue from delivered orders
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- 9. Top 5 customers by spending on delivered orders
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS delivered_order_spending
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY delivered_order_spending DESC
LIMIT 5;

-- 10. Count orders by status
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 11. Create/update customer_sales view (delivered orders only)
CREATE OR REPLACE VIEW customer_sales AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 12. Use the customer_sales view
SELECT *
FROM customer_sales
ORDER BY total_spent DESC;

-- 13. Products priced above the average product price
SELECT
    product_id,
    product_name,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- 14. Average product price
SELECT AVG(price) AS average_product_price
FROM products;

-- 15. Categorize products by price
SELECT
    product_name,
    price,
    CASE
        WHEN price < 1000 THEN 'Budget'
        WHEN price <= 5000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_category
FROM products
ORDER BY price DESC;

-- 16. CTE: products priced above 5000
WITH expensive_products AS (
    SELECT product_name, price
    FROM products
    WHERE price > 5000
)
SELECT *
FROM expensive_products
ORDER BY price DESC;

-- 17. Rank products by price
SELECT
    product_name,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num,
    RANK() OVER (ORDER BY price DESC) AS product_rank,
    DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank_num
FROM products;

-- 18. Data quality: duplicate non-null emails
SELECT
    email,
    COUNT(*) AS total_records
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- 19. Data quality: customers with missing emails
SELECT *
FROM customers
WHERE email IS NULL;

-- 20. Data quality: invalid product prices
SELECT *
FROM products
WHERE price IS NULL OR price <= 0;

-- 21. Data quality: order items with invalid quantity or price
SELECT *
FROM order_items
WHERE quantity <= 0 OR unit_price <= 0;

-- 22. Data quality: orders referencing missing customers
SELECT
    o.order_id,
    o.customer_id
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 23. Product performance: delivered sales by product
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products AS p
JOIN order_items AS oi
    ON p.product_id = oi.product_id
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

-- 24. Monthly business performance for delivered orders
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- 25. Customer segmentation based on delivered-order spending
WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spending
    FROM customers AS c
    LEFT JOIN orders AS o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'Delivered'
    LEFT JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    customer_name,
    total_spending,
    CASE
        WHEN total_spending > 50000 THEN 'High Value'
        WHEN total_spending >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spending DESC;

-- 26. Top 3 customers by spending on delivered orders
WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, total_spending
FROM customer_spending
ORDER BY total_spending DESC
LIMIT 3;
