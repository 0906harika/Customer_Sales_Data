SELECT * FROM customer_data;

SELECT * FROM sales_data;

--Step one: Clean the data--
CREATE Or REPLACE TABLE 'sales_customer_data' AS (
SELECT 
  s.customer_id
  , s.category
  , s.quantity
  , s.price
  , s.quantity * s.price AS total_price
  , s.invoice_date
  , s.shopping_mall
  , c.gender
  , c.age
  , c.payment_method
FROM sales_data AS s
INNER JOIN customer_data AS c
ON c.customer_id = s.customer_id);

SELECT *
FROM sales_customer_data
WHERE total_price IS NULL;

--Step two: Analyse the data--
--What is the total revenue generated in the year 2022?--

SELECT SUM(total_price) AS total_revenue
FROM sales_customer_data
WHERE EXTRACT(year FROM invoice_date) = 2022;

--What is the most popular product category in terms of sales?--
SELECT
  SUM(quantity) AS total_quantity, category
FROM sales_customer_data
GROUP BY category
ORDER BY total_quantity DESC;

--What are the three top shopping malls in terms of sales revenue?--
SELECT
  shopping_mall, ROUND(SUM(total_price),2) AS total_price
  FROM sales_customer_data
  GROUP BY shopping_mall
  ORDER BY total_price DESC
  LIMIT 3;

--What is the gender distribution across different product categories?--
SELECT
  category, gender, COUNT(*) AS count
  FROM sales_customer_data
GROUP BY gender, category
 ORDER BY count DESC;

--What is the age distribution of customers who prefer each payment method?--
SELECT
  CASE WHEN age BETWEEN 0 AND 25 THEN '0-25'
       WHEN age BETWEEN 26 AND 50 THEN '26-50'
       WHEN age BETWEEN 51 AND 75 THEN '51-75'
       WHEN age BETWEEN 76 AND 100 THEN '76-100'
       ELSE 'other' 
       END AS age_range
  ,payment_method 
  ,COUNT(*) AS count
  FROM sales_customer_data
 GROUP BY age_range, payment_method
 ORDER BY count DESC;

