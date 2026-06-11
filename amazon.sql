-------------------------------------------------------------

-------------------AMAZON SALES ANALYSIS---------------------

-------------------------------------------------------------

---------------CREATING TABLE -------------------------------

CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers(
customer_id INT primary key,
first_name char(100),
last_name char(100),
state char(100)
)

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    stock INT,
    warehouse_id INT,
    last_stock_date DATE
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    total_price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    seller_id INT,
    order_status VARCHAR(30),
    
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_mode VARCHAR(50),
    payment_status VARCHAR(30),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    category_id INT,

    FOREIGN KEY (category_id)
        REFERENCES Category(category_id)
);


CREATE TABLE Seller (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL,
    origin VARCHAR(100)
);

CREATE TABLE Shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT,
    shipping_date DATE,
    shipping_provider VARCHAR(100),
    delivery_status VARCHAR(50),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);


----adding column  customer_id in order_items table 
ALTER TABLE order_items
ADD COLUMN customer_id INT

UPDATE Order_Items oi
SET customer_id = o.customer_id
FROM Orders o
WHERE oi.order_id = o.order_id;


----adding column category_id in order_items

UPDATE Order_Items oi
SET category_id = p.category_id
FROM Product p
WHERE oi.product_id = p.product_id;


----adding seller_id in order_items
ALTER TABLE order_items
ADD COLUMN seller_id INT

UPDATE Order_Items oi
SET seller_id = o.seller_id
FROM orders o
WHERE oi.order_id = o.order_id;



-------------------------------ALL TABLE---------------------------------
SELECT * FROM category
SELECT * FROM customers
SELECT * FROM inventory
SELECT * FROM order_items
SELECT * FROM orders
SELECT * FROM payments
SELECT * FROM seller
SELECT * FROM shipping
SELECT * FROM product

-----------------------------------------------------------------------




---------------------------EDA (BASICS)---------------------------------------

----1.Find the total number of customers.
     SELECT COUNT(*) as total_customers
	 FROM customers
	 
----2.Find the total number of products.
      SELECT COUNT(*) AS total_products
	  FROM product
	  
----3.Find the total number of categories.
      SELECT COUNT(*) AS categories 
	  FROM category

----4.Find the total number of sellers.
      SELECT COUNT(*) AS total_sellers
	  FROM SELLER
	  
----5.Find the total number of orders.
    SELECT COUNT(*) AS total_orders
	FROM orders
	
----6.Find the total revenue generated.
     SELECT SUM(total_price) as total_sales
	 FROM order_items
	 
----7.Display all products with their category names.
      SELECT p.product_name ,c.category_name
	  FROM product p
	  JOIN
	  category c
	  ON p.category_id=c.category_id
	 
----8.List all customers from a particular state.
      SELECT 	first_name as name,
	  state
	  FROM 
	  customers
	  WHERE state ='New York'
	  	          
----9.Find all delivered orders.
      SELECT * FROM orders
	  WHERE order_status='Delivered'

----10.Find all failed payments.
       SELECT * FROM payments
	   WHERE payment_status='Failed'

----11.Find products with stock less than 10.
        SELECT * FROM inventory
	    WHERE stock<10 
		
----12. Display all sellers and their origins.
        SELECT seller_name , origin FROM SELLER
		
----13.Count orders by order status.
        SELECT  order_status, COUNT(*) as total_orders
	    FROM orders
	    GROUP BY order_status
	 
----14.Count payments by payment mode.
       SELECT  payment_mode, COUNT(*) as total_payments
	    FROM payments
	    GROUP BY payment_mode
	  
----15.Count shipments by delivery status.
       SELECT  delivery_status, COUNT(*) as total_shipments
	    FROM shipping
	    GROUP BY delivery_status

-----------------------------------------------------------------------------------


------------------------------INTERMIDIATE QUERIES---------------------------------

----16.Find the top 10 customers by total spending.
     	SELECT o.customer_id,SUM(oi.total_price) as total_spending
		 FROM orders o
		 JOIN 
		 order_items oi
		 ON o.customer_id=oi.customer_id
		 GROUP BY o.customer_id
		 LIMIT 10


----17.Find the top 10 selling products.
         SELECT  p.product_name,SUM(oi.total_price) as total_sales
		 FROM product p
		 JOIN 
		 order_items oi
		 ON p.product_id=oi.product_id
		 GROUP BY product_name
		 ORDER BY total_sales DESC
		 LIMIT 10
 
----18.Find the top 5 sellers by revenue.
        SELECT o.seller_id,SUM(oi.total_price) as total_sales
		FROM 
		orders o
		JOIN 
		order_items oi 
		ON o.order_id=oi.order_id
		GROUP BY o.seller_id
		ORDER BY total_sales DESC
		LIMIT 5
 
----19.Calculate revenue generated by each category.
     SELECT c.category_name,SUM(oi.total_price) as total_sales
	 FROM category c
	 JOIN 
	 order_items oi
	 ON oi.category_id=c.category_id
	 GROUP BY category_name
	 
----20.Calculate revenue generated by each seller.
        SELECT s.seller_name,SUM(oi.total_price) as total_sales
		FROM 
		seller s
		JOIN 
		order_items oi 
		ON s.seller_id=oi.seller_id
		GROUP BY s.seller_id
		ORDER BY total_sales DESC
		
----21.Find average order value.
       SELECT ROUND(SUM(total_price)/ count(distinct(order_id))
	   ,2) as AOV
	   FROM order_items
	   
----22.Find customers who placed more than 5 orders.
       SELECT c.first_name,COUNT(oi.order_id)
	   as total_orders
	   FROM 
	   customers c
	   JOIN
	   order_items oi
	   ON c.customer_id=oi.customer_id
	   GROUP BY c.first_name
	   HAVING COUNT(oi.order_id) >5
	   
----23.Find products that were never ordered.
       SELECT p.product_name FROM product p
	   LEFT JOIN 
	   order_items oi
	   ON p.product_id=oi.product_id
	   WHERE oi.product_id is null
	   
----24.Find customers who never placed an order.
      SELECT c.customer_id 
	  FROM customers c
	  LEFT JOIN
	  orders o
	  ON c.customer_id= o.customer_id
	  WHERE o.customer_id is NULL
	  
----25.Find categories with the highest number of products.
      SELECT c.category_name ,COUNT(p.product_id) as total_products
	  FROM 
	  category c
	  JOIN 
	  product p
	  ON c.category_id=p.category_id
	  GROUP BY c.category_name
	  ORDER BY total_products DESC
	  
----26.Find the most used payment method.
       SELECT  payment_mode, COUNT(*) as total_payments
	    FROM payments
	    GROUP BY payment_mode
		ORDER BY total_payments DESC
		LIMIT 1

----27.Find the most used shipping provider.
       SELECT shipping_provider , COUNT(*) AS total_shipping_provider
	   FROM shipping 
	   GROUP BY shipping_provider 
	   ORDER BY total_shipping_provider DESC
	   LIMIT 1
	   
----28.Find the state with the highest number of customers.
       SELECT state,count(customer_id) as total_customers
	   FROM customers
	   GROUP BY state
	   ORDER BY total_customers DESC
	   
       
----29.Find products with inventory below average stock.
        SELECT product_id ,stock
		FROM inventory
		 WHERE stock <(
            SELECT AVG(stock) as average_stock
		 FROM inventory
		 )
		        
----30.Find orders that have failed payments.
       SELECT o.order_id,p.payment_status
	   FROM orders o
	   JOIN
	   payments p
	   ON o.order_id=p.order_id
	   WHERE p.payment_status='Failed'
       
----31.Find total quantity sold for each product.
       SELECT p.product_name, SUM(oi.quantity) as total_qty
	   FROM product p
	   JOIN
	   order_items oi
	   ON p.product_id=oi.product_id
	   GROUP BY p.product_name
	   ORDER BY total_qty DESC
	   
----32.Find total profit generated by each product.
     SELECT p.product_name, SUM((p.price-p.cogs) *oi.quantity) as total_profit
	   FROM product p
	   JOIN
	   order_items oi
	   ON p.product_id=oi.product_id
	   GROUP BY p.product_name
	   ORDER BY total_profit DESC
	   
----33.Find total profit generated by each category.      
       SELECT c.category_name,SUM((p.price-p.cogs) *oi.quantity) as total_profit
	   FROM category c
	   JOIN
	   product p
	   ON c.category_id=p.category_id
	   JOIN
	   order_items oi
	   ON p.product_id=oi.product_id
	   GROUP BY c.category_name
	   ORDER BY total_profit DESC

      
----34.Find revenue generated by each state.
        SELECT c.state,SUM(oi.total_price) as total_sales
		FROM customers c
		JOIN
		order_items oi
		ON c.customer_id=oi.customer_id
		GROUP BY c.state
		ORDER BY  total_sales DESC
		
----35.Find monthly sales revenue.
       SELECT   TO_CHAR(o.order_date,'Month') as months,
	   SUM(oi.total_price) as total_sales
	   FROM orders o
	   JOIN
	   order_items oi 
	   ON o.order_id=oi.order_id
	   GROUP BY months
	   ORDER BY MIN(o.order_date)
	   
--------------------------------------------------------------------------

---------------------ADVANCED QUERIES-------------------------------------

----36.Find complete order details (Customer, Product, Seller, Payment, Shipping).
         	SELECT concat(c.first_name,' ',c.last_name) AS customer_name,
			 p.product_name,ct.category_name,py.payment_mode,py.payment_status,
			 s.shipping_date,o.order_date,sp.seller_name
			 FROM 
			 order_items oi
			 JOIN customers c
			 ON c.customer_id=oi.customer_id
			 JOIN 
			 product p
			 ON oi.product_id=p.product_id
			 JOIN 
			 category ct
			 ON oi.category_id=ct.category_id
			 JOIN
			 payments py
			 ON oi.order_id=py.order_id
			 JOIN
			 shipping s
			 ON oi.order_id=s.order_id
			 JOIN
			 orders o
			 ON o.order_id=oi.order_id
			 JOIN
			 seller sp
			 ON o.seller_id=sp.seller_id			 

----37.Find top 3 products in each category.
        WITH  total_sales_p AS(
        SELECT p.product_name ,c.category_name,SUM(oi.total_price) as total_sales
		FROM 
		product p
		JOIN
		category c
		ON p.category_id=c.category_id
		JOIN
		order_items oi
		ON p.product_id=oi.product_id
		GROUP BY 2,1
		),top_3 AS(
		
		 SELECT *,DENSE_RANK() OVER( PARTITION BY category_name ORDER BY total_sales desc) as rk
		 FROM total_sales_p
		 )
		 SELECT * FROM top_3
		 where rk <=3	
       
----38.Find second highest revenue-generating seller.
        WITH seller_name AS(
          SELECT s.seller_id, s.seller_name,SUM(oi.total_price) AS total_sales
		  FROM orders o
		  JOIN
		  seller s
		  ON o.seller_id=s.seller_id
		  JOIN
		  order_items oi
		  ON oi.order_id=o.order_id
		  GROUP BY  s.seller_id,s.seller_name
		),seller_rank AS(
          SELECT *, DENSE_RANK() OVER(ORDER BY total_sales DESC) AS ranking
		  FROM seller_name
		)
		SELECT * FROM seller_rank
		WHERE ranking =2

		
----39.Find second highest spending customer.
       WITH customer_name AS(
         SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) as customer_name,
		         SUM(oi.total_price) as total_sales
				 FROM customers c
				 JOIN
				 order_items oi
				 ON c.customer_id=oi.customer_id
				 GROUP BY 1,2
		 ),ranking AS(
                    SELECT *,DENSE_RANK() 
					OVER(ORDER BY total_sales DESC) AS ranking
					FROM customer_name
		 ) 
		       SELECT * FROM ranking
			   WHERE ranking =2
			   
----40.Find the most profitable category.
       SELECT p.product_name ,c.category_name,SUM(oi.total_price) as total_sales
		FROM 
		product p
		JOIN
		category c
		ON p.category_id=c.category_id
		JOIN
		order_items oi
		ON p.product_id=oi.product_id
		GROUP BY 2,1
		ORDER BY total_sales DESC
		limit 1
		
----41.Find products contributing more than 5% of total revenue.
       
----42.Find customers whose spending is above average.
       	WITH customers_total AS(
                SELECT  c.customer_id, CONCAT(c.first_name,' ',c.last_name) as customer_name,
		         SUM(oi.total_price) AS total_Spending
		         FROM orders o
				 JOIN
				 order_items oi
				 ON o.order_id=oi.order_id
				 JOIN
				 customers c
				 ON o.customer_id=c.customer_id
				  GROUP BY customer_name,c.customer_id	         
		), Average_spending AS(		
                SELECT  
		         AVG(total_Spending) AS Average_spending
		         FROM customers_total
					)
		SELECT ct.* FROM 
		      customers_total ct
			  JOIN
			  Average_spending a
			  ON ct.total_Spending > a.Average_spending

	   
----43.Find sellers whose revenue is above average.
       WITH CT AS(
       SELECT s.seller_id,s.seller_name,SUM(oi.total_price) as total
	      FROM seller s
		  JOIN 
		  orders o
		  ON s.seller_id=o.seller_id
		  JOIN
		  order_items oi
		  ON o.order_id=oi.order_id
		  GROUP BY s.seller_id,s.seller_name)
		 ,avg_total AS(
                      SELECT avg(total) AS average_total
					  FROM CT
		 )
		  
		     SELECT t.*
			 FROM 
			 CT t
			 JOIN avg_total a
			 ON t.total>a.average_total
			 
         
----44.Find the highest revenue product in each category.
        WITH  total_sales_p AS(
        SELECT p.product_name ,c.category_name,SUM(oi.total_price) as total_sales
		FROM 
		product p
		JOIN
		category c
		ON p.category_id=c.category_id
		JOIN
		order_items oi
		ON p.product_id=oi.product_id
		GROUP BY 2,1
		),top_3 AS(
		
		 SELECT *,DENSE_RANK() OVER( PARTITION BY category_name ORDER BY total_sales desc) as rk
		 FROM total_sales_p
		 )
		 SELECT * FROM top_3
		 where rk =1
	 
----45.Find repeat customers.
       SELECT c.customer_id,COUNT(order_id) as total_orders
	   FROM customers c
	   JOIN orders o
	   ON c.customer_id=o.customer_id
	   GROUP BY c.customer_id
	   HAVING COUNT(order_id) >1
	   
----46.Find average products purchased per order.
       

----47.Find order status-wise revenue.
       SELECT o.order_status ,SUM(oi.total_price) as total_sales
	   FROM orders o
	   JOIN order_items oi
	   ON o.order_id=oi.order_id
	   GROUP BY o.order_status
	   ORDER BY total_sales DESC
----48.Find payment mode-wise revenue.
       SELECT p.payment_status ,SUM(oi.total_price) as total_sales
	   FROM payments p
	   JOIN order_items oi
	   ON p.order_id=oi.order_id
	   GROUP BY p.payment_status
	   ORDER BY total_sales DESC

----49.Find delivery status-wise revenue.
       SELECT s.delivery_status ,SUM(oi.total_price) as total_sales
	   FROM shipping s
	   JOIN order_items oi
	   ON s.order_id=oi.order_id
	   GROUP BY s.delivery_status
	   ORDER BY total_sales DESC
	   
----50.Find customer lifetime value (CLV).
       SELECT  c.customer_id, CONCAT(c.first_name,' ',c.last_name) as customer_name,
	   SUM(oi.total_price) AS lifetime_value
		FROM orders o
	    JOIN
	    order_items oi
        ON o.order_id=oi.order_id
		JOIN
	   customers c
	   ON o.customer_id=c.customer_id
	   GROUP BY customer_name,c.customer_id

----------------------------------------------------------------------------------
					  
-------------------Window Function Questions-------------------------------------


----51.Rank customers based on spending.
        WITH customer_name AS(
         SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) as customer_name,
		         SUM(oi.total_price) as total_sales
				 FROM customers c
				 JOIN
				 order_items oi
				 ON c.customer_id=oi.customer_id
				 GROUP BY 1,2
		 ),ranking AS(
                    SELECT *,DENSE_RANK() 
					OVER(ORDER BY total_sales DESC) AS ranking
					FROM customer_name
		 ) 
		       SELECT * FROM ranking

----52.Rank sellers based on revenue.
         WITH seller_name AS(
          SELECT s.seller_id, s.seller_name,SUM(oi.total_price) AS total_sales
		  FROM orders o
		  JOIN
		  seller s
		  ON o.seller_id=s.seller_id
		  JOIN
		  order_items oi
		  ON oi.order_id=o.order_id
		  GROUP BY  s.seller_id,s.seller_name
		),seller_rank AS(
          SELECT *, DENSE_RANK() OVER(ORDER BY total_sales DESC) AS ranking
		  FROM seller_name
		)
		SELECT * FROM seller_rank
			
----53.Rank products based on quantity sold.
        WITH total_sold AS(
        SELECT p.product_name ,SUM(oi.quantity) AS total_sold
		FROM 
		product p
		JOIN
		order_items oi
		ON p.product_id=oi.product_id
		GROUP BY p.product_name)
		SELECT product_name , total_sold,
		dense_rank() OVER(order by total_sold DESC) AS rnk
		FROM total_sold
		    
----54.Calculate cumulative revenue over time.
        SELECT o.order_date,oi.total_price,SUM(oi.total_price) 
		OVER( ORDER BY o. order_date rows between unbounded preceding and current row) 
		 as running_sum		 
		FROM order_items oi
		JOIN
		orders o
		ON oi.order_id=o.order_id
				
----55.Calculate running total of orders.
     WITH daily_orders AS (
    SELECT
        order_date,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY order_date
)
SELECT
    order_date,
    total_orders,
    SUM(total_orders) OVER (
        ORDER BY order_date
    ) AS running_total_orders
FROM daily_orders
ORDER BY order_date;
         
-----56.Compare current month's sales with previous month using LAG().
          WITH monthly_sales AS(
          SELECT 
		  TO_CHAR(o.order_date,'Month') AS months,
		  EXTRACT(month from o.order_date) as month_num,
		  SUM(oi.total_price) AS total_sales 
		  FROM order_items oi
		  JOIN
		  orders o
		  ON oi.order_id=o.order_id
		  GROUP BY months ,month_num
		  )
		  SELECT months,month_num,total_sales,
		  LAG(total_sales) OVER(ORDER BY month_num)
		  AS previous_month_sales
		  FROM monthly_sales
		
----57.Find month-over-month revenue growth.
        WITH monthly_sales AS(
          SELECT 
		  EXTRACT(year from o.order_date) as years,
		  TO_CHAR(o.order_date,'Month') AS months,
		  EXTRACT(month from o.order_date) as month_num,
		  SUM(oi.total_price) AS total_sales 
		  FROM order_items oi
		  JOIN
		  orders o
		  ON oi.order_id=o.order_id
		  GROUP BY years,month_num,months
		  ), 
		  pre_sales AS(
		  SELECT years, months,month_num,total_sales,
		  LAG(total_sales) 
		  OVER(ORDER BY years,month_num)
		  AS  
		  previous_month_sales
		  FROM monthly_sales
		  )
		  SELECT years,months,month_num,
		  total_sales,previous_month_sales,
		  ROUND(((total_sales - previous_month_sales)/
		  NULLIF(previous_month_sales,0)) 
		  * 100.0
		  ,2) 
		  AS MOM
		  FROM pre_sales

----58.Find each customer's first order date.	         
         WITH first_order AS (
         SELECT
        c.customer_id,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.order_date 
        ) AS rn
        FROM customers c
         JOIN orders o
        ON c.customer_id = o.customer_id
)
       SELECT
    customer_id,
    order_id,
    order_date AS first_order_date
     FROM first_order
     WHERE rn = 1;


----59.Find each customer's latest order date.
                 WITH first_order AS (
         SELECT
        c.customer_id,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.order_date DESC
        ) AS rn
        FROM customers c
         JOIN orders o
        ON c.customer_id = o.customer_id
)
       SELECT
    customer_id,
    order_id,
    order_date AS first_order_date
     FROM first_order
     WHERE rn = 1;

----60.Year over Year growth by total_sales
          WITH yearly_sales AS(
          SELECT 
		  EXTRACT(year from o.order_date) as years,
		  SUM(oi.total_price) AS total_sales 
		  FROM order_items oi
		  JOIN
		  orders o
		  ON oi.order_id=o.order_id
		  GROUP BY years
		  ), 
		  pre_sales AS(
		  SELECT years,total_sales,
		  LAG(total_sales) 
		  OVER(ORDER BY years)
		  AS  
		  previous_year_sales
		  FROM yearly_sales
		  )
		  SELECT years,
		  total_sales,previous_year_sales,
		  ROUND(((total_sales - previous_year_sales)/
		  NULLIF(previous_year_sales,0)) 
		  * 100.0
		  ,2) 
		  AS YOY
		  FROM pre_sales