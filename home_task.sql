--1
SELECT * FROM customers
WHERE city = 'Минск';

--2
SELECT product_name, price FROM products
ORDER BY price DESC;

--3
SELECT COUNT(*) FROM customers;

--4
SELECT SUM(total_amount)
FROM orders;


--5
SELECT customers.customer_id, customers.customer_name, orders.order_date FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.order_id;


--6
SELECT customers.customer_id, customer_name, SUM(orders.total_amount) FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customer_name;

--7
customers.customer_id, customer_name, orders.order_date FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.order_id
WHERE orders.order_date > '2023-10-01';

--8
SELECT customers.customer_id, customer_name, sum(orders.total_amount) FROM customers
JOIN orders 
ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customer_name
HAVING sum(orders.total_amount) > 10000;

--9
SELECT customers.customer_id, customer_name, orders.order_date,
ROW_NUMBER() OVER (PARTITION BY customers.customer_id ORDER BY orders.order_date)
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id;

--10
SELECT customers.customer_id, customer_name, orders.order_date,
LAG(orders.order_date) OVER (PARTITION BY customers.customer_id  ORDER BY orders.order_date)
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id;
--11
SELECT customer_name, city, COUNT(*) FROM customers
GROUP BY customer_name, city
HAVING COUNT(*) > 1;

--12
SELECT TO_CHAR(order_date, 'YYYY-MM') AS order_month,
SUM(total_amount) AS monthly_total,
SUM(SUM(total_amount)) OVER (ORDER BY TO_CHAR(order_date, 'YYYY-MM')) AS total_sum
FROM orders
GROUP BY order_month
ORDER BY order_month;

--13
SELECT customers.customer_id, customer_name
FROM customers
WHERE NOT EXISTS (SELECT * FROM products
  WHERE category = 'Электроника'
  AND NOT EXISTS (SELECT * FROM orders
    LEFT JOIN order_items 
	ON orders.order_id = order_items.order_id
    WHERE orders.customer_id = customers.customer_id
    AND order_items.product_id = products.product_id
  )
);

--14
SELECT DISTINCT ON (category) product_id, product_name, category,total_quantity
FROM (
SELECT products.product_id, products.product_name, products.category,
  SUM(order_items.quantity) AS total_quantity
  FROM products
  LEFT JOIN order_items ON products.product_id = order_items.product_id
  GROUP BY products.product_id, products.product_name, products.category
) AS total_sellaris
ORDER BY category, total_quantity DESC;





