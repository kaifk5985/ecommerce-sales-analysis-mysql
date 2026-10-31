CREATE DATABASE ecommerce_db;
USE ecommerce_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    registration_date DATE
);


INSERT INTO customers
(first_name, last_name, email, city, registration_date)
VALUES
('Rahul', 'Sharma', 'rahul@gmail.com', 'Delhi', '2026-01-10'),
('Aman', 'Kumar', 'aman@gmail.com', 'Mumbai', '2026-01-15'),
('Priya', 'Singh', 'priya@gmail.com', 'Delhi', '2026-02-01'),
('Neha', 'Verma', 'neha@gmail.com', 'Bhopal', '2026-02-10'),
('Arjun', 'Patel', 'arjun@gmail.com', 'Jaipur', '2026-03-05'),
('Sneha', 'Gupta', 'sneha@gmail.com', 'Mumbai', '2026-03-12'),
('Rohit', 'Yadav', 'rohit@gmail.com', 'Patna', '2026-04-01'),
('Anjali', 'Mishra', 'anjali@gmail.com', 'Bhopal', '2026-04-15'),
('Vikas', 'Jain', 'vikas@gmail.com', 'Delhi', '2026-05-20'),
('Pooja', 'Das', 'pooja@gmail.com', 'Patna', '2026-06-10');

SELECT * FROM customers;

SELECT COUNT(*) AS total_customers
FROM customers;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

INSERT INTO products
(product_name, category, price, stock_quantity)
VALUES
('Laptop', 'Electronics', 55000.00, 15),
('Smartphone', 'Electronics', 25000.00, 30),
('Headphones', 'Electronics', 1500.00, 50),
('T-Shirt', 'Clothing', 799.00, 100),
('Jeans', 'Clothing', 1499.00, 60),
('Running Shoes', 'Footwear', 2999.00, 40),
('Wrist Watch', 'Accessories', 1999.00, 25),
('Backpack', 'Accessories', 999.00, 35),
('Office Chair', 'Furniture', 6500.00, 12),
('Study Table', 'Furniture', 4500.00, 10);

SELECT * FROM products;

SELECT COUNT(*) AS total_products
FROM products;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
INSERT INTO orders
	(customer_id, order_date, order_status)
VALUES
(1, '2026-07-01', 'Delivered'),
(2, '2026-07-02', 'Delivered'),
(3, '2026-07-03', 'Pending'),
(1, '2026-07-05', 'Delivered'),
(4, '2026-07-06', 'Cancelled'),
(5, '2026-07-08', 'Delivered'),
(6, '2026-07-10', 'Pending'),
(2, '2026-07-12', 'Delivered'),
(7, '2026-07-15', 'Shipped'),
(3, '2026-07-18', 'Delivered');

SELECT * FROM orders;

SELECT
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;
    
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 55000.00),
(1, 3, 2, 1500.00),
(2, 2, 1, 25000.00),
(2, 4, 3, 799.00),
(3, 5, 1, 1499.00),
(4, 3, 1, 1500.00),
(5, 9, 1, 6500.00),
(6, 6, 2, 2999.00),
(7, 7, 1, 1999.00),
(8, 8, 2, 999.00),
(9, 10, 1, 4500.00),
(10, 2, 1, 25000.00);


SELECT
    order_id,
    SUM(quantity * unit_price) AS order_total
FROM order_items
GROUP BY order_id
ORDER BY order_id;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

CREATE VIEW customer_sales AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;
    
SELECT * FROM customer_sales
ORDER BY total_spent DESC;

SELECT
    product_id,
    product_name,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
)
ORDER BY price DESC;

SELECT AVG(price)
FROM products;

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

WITH expensive_products AS (
    SELECT product_name, price
    FROM products
    WHERE price > 5000
)
SELECT *
FROM expensive_products;

SELECT
    product_name,
    price,
    RANK() OVER (ORDER BY price DESC) AS product_rank
FROM products;

SELECT
    product_name,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num,
    RANK() OVER (ORDER BY price DESC) AS product_rank,
    DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank_num
FROM products;

SELECT
    email,
    COUNT(*) AS total_records
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

SELECT *
FROM customers
WHERE email IS NULL;

SELECT *
FROM products
WHERE price <= 0
   OR price IS NULL;
   
SELECT
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'Delivered';

USE ecommerce_db;

USE ecommerce_db;

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

DESCRIBE orders; 

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products AS p
JOIN order_items AS oi
    ON p.product_id = oi.product_id
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;

USE ecommerce_db;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spending,
    CASE
        WHEN COALESCE(SUM(oi.quantity * oi.unit_price), 0) > 50000
            THEN 'High Value'
        WHEN COALESCE(SUM(oi.quantity * oi.unit_price), 0) >= 10000
            THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'Delivered'
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spending DESC;


DESCRIBE customers;

USE ecommerce_db;

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

USE ecommerce_db;

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
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT
    customer_id,
    customer_name,
    total_spending
FROM customer_spending
ORDER BY total_spending DESC
LIMIT 3;

USE ecommerce_db;

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
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC;


USE ecommerce_db;

SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

USE ecommerce_db;

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

USE ecommerce_db;

SELECT
    email,
    COUNT(*) AS total_count
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

SELECT * FROM products
WHERE price IS NULL
   OR price <= 0;
   
   SELECT
    o.order_id,
    o.customer_id
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Level 28: Product Performance Analysis

USE ecommerce_db;

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
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC;

-- Level 29: Order Status Analysis

USE ecommerce_db;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Level 30: Monthly Business Performance

USE ecommerce_db;

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


-- Level 31: Data Quality & Final Validation

-- Check 1: Duplicate Emails

USE ecommerce_db;

SELECT
    email,
    COUNT(*) AS total_records
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- Check 2: Missing Customer Emails

SELECT *
FROM customers
WHERE email IS NULL;

-- Check 3: Invalid Product Prices

SELECT *
FROM products
WHERE price <= 0;

-- Check 4: Invalid Order Item Quantities or Prices

SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price <= 0;
   
   
   
   