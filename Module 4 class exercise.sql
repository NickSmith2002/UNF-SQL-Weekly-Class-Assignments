use classicmodels;

SELECT
    product.product_id,
    product.product_name,
    product.product_category_id AS product_prod_cat_id,
    product_category.product_category_id AS category_prod_cat_id,
    product_category.product_category_name
FROM product
    INNER JOIN product_category
    ON product.product_category_id = product_category.product_category_id;
    
SELECT * FROM ORDERS;
SELECT products.productCode, products.productName , products.quantityInStock FROM PRODUCTS
ORDER BY quantityinStock DESC;

SELECT 
	products.productCode, products.productName , products.quantityInStock,
CASE
	WHEN quantityInStock = 0 
    THEN "Out Of Stock"
    WHEN quantityInStock > 1 AND quantityInStock <= 1000
    THEN "Low Stock" 
    WHEN quantityInStock > 1001 AND quantityInStock <= 5000
    THEN "Moderate Stock" 
    WHEN quantityInStock > 5001
    THEN "High Stock"
    ELSE "NULL"
END AS Inventory_Status
FROM classicmodels.products
ORDER BY quantityInStock DESC;

SELECT 
	products.productCode, products.productName , products.quantityInStock,
CASE
	WHEN quantityInStock = 0 
    THEN "Out Of Stock"
    WHEN quantityInStock > 1 AND quantityInStock <= 1000
    THEN "Low Stock" 
    WHEN quantityInStock > 1001 AND quantityInStock <= 5000
    THEN "Moderate Stock" 
    WHEN quantityInStock > 5001
    THEN "High Stock"
    ELSE "NULL"
END AS Inventory_Status
FROM classicmodels.products
ORDER BY quantityInStock DESC;

SELECT inventory_status, 
	   COUNT(productCode) as product_count, 
       SUM(quantityInStock) AS total_units FROM(
	SELECT 
 productCode,
 productName,
 quantityInStock,
 CASE
 WHEN quantityInStock = 0 THEN 'Out of Stock'
 WHEN quantityInStock BETWEEN 1 AND 1000 THEN 'Low Stock'
 WHEN quantityInStock BETWEEN 1001 AND 5000 THEN 'Moderate Stock'
 ELSE 'High Stock'
 END AS inventory_status
FROM products
) AS x
GROUP BY inventory_status;

/* Task 2*/
SELECT 
	customers.customerName, 
    orders.orderDate, 
    products.productName, 
    orderdetails.quantityOrdered, orderdetails.priceEach
FROM classicmodels.customers

JOIN classicmodels.orders
ON customers.customerNumber = orders.customerNumber
JOIN classicmodels.orderdetails
ON orders.orderNumber = orderdetails.orderNumber
JOIN classicmodels.products
ON orderdetails.productCode = products.productCode

ORDER BY customers.customerName ASC, priceEach DESC;

/* Task 3 */
use sakila;

SELECT 
	film_id, 
	title,
    release_year,
    language_id,
    rating,
    special_features,
    rental_duration, 
    rental_rate,
    replacement_cost,
	CASE
		WHEN rental_rate >= 4.00 AND replacement_cost >= 20.00 THEN 1 
        ELSE 0
	END AS high_value_content
FROM sakila.film
ORDER BY high_value_content DESC;


SELECT
	CASE
	 WHEN rental_rate >= 4.00 AND replacement_cost >= 20.00 THEN 'High-Value'
	 ELSE 'Standard'
	 END AS class_label,
	 COUNT(*) AS film_count,
	 ROUND(AVG(rental_rate),2) AS avg_rate,
	 ROUND(AVG(replacement_cost),2) AS avg_replacement_cost
FROM sakila.film
GROUP BY class_label;
