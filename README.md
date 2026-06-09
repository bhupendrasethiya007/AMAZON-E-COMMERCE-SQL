<p align="center">
  <img src="AMAZON.png" alt="AMAZON" width="60%">
</p>

## Overview

This project focuses on analyzing Amazon E-Commerce transactional data using PostgreSQL. The dataset contains information related to customers, products, categories, sellers, orders, payments, inventory, and shipping operations.

The database consists of 9 interconnected tables that simulate real-world e-commerce business processes. Through SQL-based Exploratory Data Analysis (EDA), this project uncovers valuable business insights regarding customer behavior, sales performance, product demand, inventory management, payment trends, and shipping operations.



## Database Schema

### 1. Category

| Column Name   | Description                |
| ------------- | -------------------------- |
| category_id   | Unique category identifier |
| category_name | Category name              |

---

### 2. Customers

| Column Name | Description                |
| ----------- | -------------------------- |
| customer_id | Unique customer identifier |
| first_name  | Customer first name        |
| last_name   | Customer last name         |
| state       | Customer state             |

---

### 3. Inventory

| Column Name     | Description                 |
| --------------- | --------------------------- |
| inventory_id    | Unique inventory identifier |
| product_id      | Product identifier          |
| stock           | Available stock quantity    |
| warehouse_id    | Warehouse identifier        |
| last_stock_date | Last stock update date      |

---

### 4. Order_Items

| Column Name    | Description                  |
| -------------- | ---------------------------- |
| order_item_id  | Unique order item identifier |
| order_id       | Order identifier             |
| product_id     | Product identifier           |
| quantity       | Quantity ordered             |
| price_per_unit | Price per unit               |
| total_price    | Total price                  |

---

### 5. Orders

| Column Name  | Description             |
| ------------ | ----------------------- |
| order_id     | Unique order identifier |
| order_date   | Date of order           |
| customer_id  | Customer identifier     |
| seller_id    | Seller identifier       |
| order_status | Status of order         |

---

### 6. Payments

| Column Name    | Description               |
| -------------- | ------------------------- |
| payment_id     | Unique payment identifier |
| order_id       | Order identifier          |
| payment_date   | Date of payment           |
| payment_mode   | Payment method            |
| payment_status | Payment status            |

---

### 7. Product

| Column Name  | Description               |
| ------------ | ------------------------- |
| product_id   | Unique product identifier |
| product_name | Product name              |
| price        | Selling price             |
| cogs         | Cost of Goods Sold        |
| category_id  | Category identifier       |

---

### 8. Seller

| Column Name | Description              |
| ----------- | ------------------------ |
| seller_id   | Unique seller identifier |
| seller_name | Seller name              |
| origin      | Seller location/origin   |

---

### 9. Shipping

| Column Name       | Description                |
| ----------------- | -------------------------- |
| shipping_id       | Unique shipping identifier |
| order_id          | Order identifier           |
| shipping_date     | Shipping date              |
| shipping_provider | Shipping company           |
| delivery_status   | Delivery status            |


# SQL Business Questions & Analysis

## Basic Exploratory Data Analysis (EDA)

### 1. Find the Total Number of Customers

```sql
SELECT COUNT(*) AS total_customers
FROM customers;
```

---

### 2. Find the Total Number of Products

```sql
SELECT COUNT(*) AS total_products
FROM product;
```

---

### 3. Find the Total Number of Categories

```sql
SELECT COUNT(*) AS categories
FROM category;
```

---

### 4. Find the Total Number of Sellers

```sql
SELECT COUNT(*) AS total_sellers
FROM seller;
```

---

### 5. Find the Total Number of Orders

```sql
SELECT COUNT(*) AS total_orders
FROM orders;
```

---

### 6. Find the Total Revenue Generated

```sql
SELECT SUM(total_price) AS total_sales
FROM order_items;
```

---

### 7. Display All Products with Their Category Names

```sql
SELECT
    p.product_name,
    c.category_name
FROM product p
JOIN category c
ON p.category_id = c.category_id;
```

---

### 8. List All Customers from a Particular State

```sql
SELECT
    first_name AS name,
    state
FROM customers
WHERE state = 'New York';
```

---

### 9. Find All Delivered Orders

```sql
SELECT *
FROM orders
WHERE order_status = 'Delivered';
```

---

### 10. Find All Failed Payments

```sql
SELECT *
FROM payments
WHERE payment_status = 'Failed';
```

---

### 11. Find Products with Stock Less Than 10

```sql
SELECT *
FROM inventory
WHERE stock < 10;
```

---

### 12. Display All Sellers and Their Origins

```sql
SELECT
    seller_name,
    origin
FROM seller;
```

---

### 13. Count Orders by Order Status

```sql
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;
```

---

### 14. Count Payments by Payment Mode

```sql
SELECT
    payment_mode,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_mode;
```

---

### 15. Count Shipments by Delivery Status

```sql
SELECT
    delivery_status,
    COUNT(*) AS total_shipments
FROM shipping
GROUP BY delivery_status;
```

---
# Intermediate SQL Business Questions & Analysis

## 16. Find the Top 10 Customers by Total Spending

```sql
SELECT
    o.customer_id,
    SUM(oi.total_price) AS total_spending
FROM orders o
JOIN order_items oi
ON o.customer_id = oi.customer_id
GROUP BY o.customer_id
LIMIT 10;
```

---

## 17. Find the Top 10 Selling Products

```sql
SELECT
    p.product_name,
    SUM(oi.total_price) AS total_sales
FROM product p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
```

---

## 18. Find the Top 5 Sellers by Revenue

```sql
SELECT
    o.seller_id,
    SUM(oi.total_price) AS total_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.seller_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

## 19. Calculate Revenue Generated by Each Category

```sql
SELECT
    c.category_name,
    SUM(oi.total_price) AS total_sales
FROM category c
JOIN order_items oi
ON oi.category_id = c.category_id
GROUP BY category_name;
```

---

## 20. Calculate Revenue Generated by Each Seller

```sql
SELECT
    s.seller_name,
    SUM(oi.total_price) AS total_sales
FROM seller s
JOIN order_items oi
ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_sales DESC;
```

---

## 21. Find Average Order Value (AOV)

```sql
SELECT
    ROUND(
        SUM(total_price) / COUNT(DISTINCT(order_id)),
        2
    ) AS AOV
FROM order_items;
```

---

## 22. Find Customers Who Placed More Than 5 Orders

```sql
SELECT
    c.first_name,
    COUNT(oi.order_id) AS total_orders
FROM customers c
JOIN order_items oi
ON c.customer_id = oi.customer_id
GROUP BY c.first_name
HAVING COUNT(oi.order_id) > 5;
```

---

## 23. Find Products That Were Never Ordered

```sql
SELECT
    p.product_name
FROM product p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
```

---

## 24. Find Customers Who Never Placed an Order

```sql
SELECT
    c.customer_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

---

## 25. Find Categories with the Highest Number of Products

```sql
SELECT
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM category c
JOIN product p
ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_products DESC;
```

---

## 26. Find the Most Used Payment Method

```sql
SELECT
    payment_mode,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_mode
ORDER BY total_payments DESC
LIMIT 1;
```

---

## 27. Find the Most Used Shipping Provider

```sql
SELECT
    shipping_provider,
    COUNT(*) AS total_shipping_provider
FROM shipping
GROUP BY shipping_provider
ORDER BY total_shipping_provider DESC
LIMIT 1;
```

---

## 28. Find the State with the Highest Number of Customers

```sql
SELECT
    state,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC;
```

---

## 29. Find Products with Inventory Below Average Stock

```sql
SELECT
    product_id,
    stock
FROM inventory
WHERE stock < (
    SELECT AVG(stock)
    FROM inventory
);
```

---

## 30. Find Orders That Have Failed Payments

```sql
SELECT
    o.order_id,
    p.payment_status
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
WHERE p.payment_status = 'Failed';
```

---

## 31. Find Total Quantity Sold for Each Product

```sql
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_qty
FROM product p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_qty DESC;
```

---

## 32. Find Total Profit Generated by Each Product

```sql
SELECT
    p.product_name,
    SUM((p.price - p.cogs) * oi.quantity) AS total_profit
FROM product p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;
```

---

## 33. Find Total Profit Generated by Each Category

```sql
SELECT
    c.category_name,
    SUM((p.price - p.cogs) * oi.quantity) AS total_profit
FROM category c
JOIN product p
ON c.category_id = p.category_id
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_profit DESC;
```

---

## 34. Find Revenue Generated by Each State

```sql
SELECT
    c.state,
    SUM(oi.total_price) AS total_sales
FROM customers c
JOIN order_items oi
ON c.customer_id = oi.customer_id
GROUP BY c.state
ORDER BY total_sales DESC;
```

---

## 35. Find Monthly Sales Revenue

```sql
SELECT
    TO_CHAR(o.order_date, 'Month') AS months,
    SUM(oi.total_price) AS total_sales
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY months
ORDER BY MIN(o.order_date);
```

---
  ## 36. Find Top 3 Best-Selling Products in Each Category

Objective: Identify the highest-performing products within each product category based on revenue generated.
```sql
WITH total_sales_p AS (
    SELECT
        p.product_name,
        c.category_name,
        SUM(oi.total_price) AS total_sales
    FROM product p
    JOIN category c
        ON p.category_id = c.category_id
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY 1,2
),
top_3 AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY category_name
               ORDER BY total_sales DESC
           ) AS rk
    FROM total_sales_p
)
SELECT *
FROM top_3
WHERE rk <= 3;
```
## 37. Find Complete Order Details (Customer, Product, Seller, Payment & Shipping Information)

### Objective
Generate a comprehensive order report by combining customer, product, category, seller, payment, shipping, and order information into a single view.

### SQL Query

```sql
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    ct.category_name,
    py.payment_mode,
    py.payment_status,
    s.shipping_date,
    o.order_date,
    sp.seller_name
FROM order_items oi
JOIN customers c
    ON c.customer_id = oi.customer_id
JOIN product p
    ON oi.product_id = p.product_id
JOIN category ct
    ON oi.category_id = ct.category_id
JOIN payments py
    ON oi.order_id = py.order_id
JOIN shipping s
    ON oi.order_id = s.order_id
JOIN orders o
    ON o.order_id = oi.order_id
JOIN seller sp
    ON o.seller_id = sp.seller_id;
```


