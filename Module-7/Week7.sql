-- WEEK 7 Exercise 

/*For each customer in the classicmodels dataset, list all payments they have made along with a
ranking that indicates the order of each payment by amount, with 1 representing the highest
payment */
SELECT
	customerNumber,
	paymentDate,
	amount,
	ROW_NUMBER() OVER (PARTITION BY customerNumber ORDER BY amount DESC) AS payment_rank
FROM classicmodels.payments;

/*Knowing a customer’s running total of payments across time can help track their engagement
and spending patterns. Calculate the cumulative sum of each customer’s payments over time,
keeping all original data rows */
SELECT
	customerNumber,
    paymentDate, 
    amount,
    SUM(amount) OVER (PARTITION BY customerNumber ORDER BY amount DESC) AS cumulative_payment
FROM classicmodels.payments;

/*Dividing cities into population quartiles helps analyze population density distribution and
capture urbanization levels. Write a query to assign each city to one of four population quartiles,
with Quartile 1 representing the highest population cities and Quartile 4 the lowest.
Goal: Assign each city to a quartile based on population*/
SELECT 
	name, 
    Population,
    NTILE(4) OVER (ORDER BY Population DESC) AS population_quartile
FROM world.city;

SELECT 
	Name, 
    Population,
    CASE
		WHEN city_row <= total_count * 0.25 THEN 1
		WHEN city_row <= total_count * 0.5 THEN 2
		WHEN city_row <= total_count * 0.75 THEN 3
		ELSE 4
	END AS city_rank
FROM (SELECT
	Name,
    Population,
    ROW_NUMBER() OVER (ORDER BY Population DESC) as city_row,
    COUNT(*) OVER () AS total_count
FROM world.city) AS x
ORDER BY city_rank;

SELECT
	Name,
    Population,
    ntile(4) OVER (ORDER BY Population DESC) as city_rank
FROM world.city;

/*Identify the highest credit limit customer in each country to target potential high-value clients.
Write a query to filter the top-ranked customer based on the credit limit*/
SELECT
	country,
    customerNumber,
    customerName,
    creditLimit
FROM (
    SELECT
	country,
    customerNumber,
    customerName,
    creditLimit,
    ROW_NUMBER() OVER (Partition BY country order by creditLimit DESC) as credit_rank
FROM classicmodels.customers) as ranked_customers
WHERE credit_rank = 1;

/*By analyzing the orders data in classicmodels we want to identify newly engaged customers. In
particular, we want to find customers who placed additional orders within 30 days of their first
order. Find unique customers who have placed at least one follow-up order within 30 days of
their first order. Note that you must exclude customers who only placed a single orde*/
SELECT
	DISTINCT customerNumber,
    orderDate,
    first_order_date,
    days_since_first_order
FROM (SELECT
	customerNumber,
    orderDate,
    FIRST_VALUE(orderDate) OVER (PARTITION BY customerNumber ORDER BY orderDate) as first_order_date,
    DATEDIFF(orderDate, FIRST_VALUE(orderDate) OVER (PARTITION BY customerNumber ORDER BY orderDate)) AS days_since_first_order
FROM classicmodels.orders) AS first_customer_orders
WHERE days_since_first_order < 30 AND days_since_first_order <> 0;
