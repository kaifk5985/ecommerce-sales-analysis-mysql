-- E-Commerce Sales Analysis Project
-- Purpose: Insert sample data into ecommerce_db.
-- IMPORTANT: Run only on a fresh database after 01_database_setup.sql.
-- Do not rerun on a database that already contains data.
USE ecommerce_db;

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

-- Customers sample data
INSERT INTO customers
    (first_name, last_name, email, city, registration_date)
VALUES
    ('Rahul', 'Sharma', 'rahul@example.com', 'Bhopal', '2026-06-01'),
    ('Priya', 'Verma', 'priya@example.com', 'Indore', '2026-06-05'),
    ('Aman', 'Khan', 'aman@example.com', 'Gaya', '2026-06-10'),
    ('Sneha', 'Patel', 'sneha@example.com', 'Delhi', '2026-06-15'),
    ('Rohit', 'Singh', 'rohit@example.com', 'Jaipur', '2026-06-20'),
    ('Neha', 'Gupta', 'neha@example.com', 'Bhopal', '2026-06-22'),
    ('Arjun', 'Kumar', 'arjun@example.com', 'Patna', '2026-06-25');

-- Orders sample data
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

-- Order items sample data
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
