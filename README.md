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
erations.
