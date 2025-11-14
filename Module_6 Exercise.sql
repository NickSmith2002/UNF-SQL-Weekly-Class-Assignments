/* Task 1 */

USE sakila;

/*Write an SQL query to display a list of customers who rented movies, 
including the rental date, customer ID, and the customer’s first and last name. 
Retrieve the rental_date, customer_id, first_name, and last_name
*/

USE sakila;

SELECT 
	r.rental_date,
	c.customer_id,
    c.first_name,
    c.last_name
FROM sakila.customer AS c
JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY 
	r.rental_date, r.customer_id
ORDER BY 
	r.rental_date, r.customer_id;

-- Task 2

/*Write a SQL query to display the total number of products ordered for each customer on each order date. 
Retrieve the customerNumber, orderDate, and the total quantity of products ordered (as total_products). 
Order the results by orderDate and customerNumber. Limit the output to the top 10 records.
*/

USE classicmodels;

SELECT 
	c.customerNumber,
    o.orderDate,
    Sum(od.quantityOrdered) AS total_products
FROM classicmodels.customers as c
JOIN classicmodels.orders AS o
ON c.customerNumber = o.customerNumber
JOIN classicmodels.orderdetails AS od
ON o.orderNumber = od.orderNumber 
GROUP BY o.orderNumber, c.customerNumber, o.orderDate
ORDER BY o.orderDate, c.customerNumber
LIMIT 10;
;

-- Task 3

/* Write an SQL query to display the total population for each continent, along with the total land area. 
Only include continents where the total population is at least 500 million. 
Retrieve the continent, the sum of population as total_population, and the sum of SurfaceArea as total_land_area. 
Limit the output to the top 10 records.
*/

USE world;

SELECT 
    Continent,
    SUM(Population) AS Total_Population,
    SUM(SurfaceArea) AS Total_Land_Area
FROM
    world.country
GROUP BY Continent
HAVING Total_Population > 500000000
LIMIT 10;

-- Task 4

/* As a data analyst at a film rental company (using the Sakila database), 
you've been assigned to generate insights that will help optimize the rental pricing strategy. 
Your goal is to prepare data for a machine learning model that predicts the ideal rental duration and rate for each film. 
To achieve this, analyze rental activity across different film categories using SQL aggregation functions.

*/

USE sakila; 

-- Group by Genre Rental Duration
SELECT 
    c.name, 
    SUM(f.rental_duration) AS Total_Rental_Duration,
    SUM(f.rental_rate) AS Total_Rate
FROM
    sakila.film AS f
        JOIN
    sakila.film_category AS fc ON f.film_id = fc.film_id
        JOIN
    sakila.category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY Total_Rental_Duration DESC;

SELECT 
    c.name, 
    AVG(f.rental_duration) AS Average_Rental_Duration,
    AVG(f.rental_rate) AS Average_Rate
FROM
    sakila.film AS f
        JOIN
    sakila.film_category AS fc ON f.film_id = fc.film_id
        JOIN
    sakila.category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY Average_Rental_Duration DESC;


USE sakila;
SELECT
	cat.name,
    AVG(f.rental_duration) AS avg_rental_duration,
    AVG(f.rental_rate) AS avg_rental_rate,
    COUNT(f.film_id) AS total_films_in_category,     -- total of films
    COUNT(r.rental_id) AS total_rentals              -- to mesure popularity
FROM category AS cat
INNER JOIN
	film_category AS fc ON cat.category_id = fc.category_id
INNER JOIN
	film AS f ON f.film_id = fc.film_id
LEFT JOIN
    inventory AS i ON f.film_id = i.film_id
LEFT JOIN
    rental AS r ON i.inventory_id = r.inventory_id
GROUP BY
    cat.name
ORDER BY
    total_rentals DESC;
    
-- Task 5
SELECT 
    AVG(rental_rate) AS Average_Rental_Rate,
    MIN(rental_rate) AS Min_Rental_Rate,
    MAX(rental_rate) AS Max_Rental_Rate,
    AVG(rental_duration) AS Average_Rental_Duration,
    MIN(rental_duration) AS Min_Rental_Duration,
    MAX(rental_duration) AS Max_Rental_Duration
FROM
    sakila.film;

-- Task 6

/* 
Population density is a critical metric in census studies, as it helps understand how population distribution varies across land areas. 
By classifying countries by population density, policymakers and researchers can gain insight into urban planning, resource allocation, socio-economic policies, and environmental impacts.
In a project aimed at Understanding Population Distribution, your task is to compare two methods for ranking countries by population density and classifying them accordingly. 
These approaches provide different perspectives on population distribution and density.
*/
USE world;


/* 
APPROACH A
This method calculates population density by considering each country as a whole:
- Formula: Population Density = Total Population / Surface Area
- Classification:
   - High Density: 100 people per unit area or more
   - Medium Density: Between 50 and 100 people per unit area
   - Low Density: Less than 50 people per unit area
This approach is helpful for national-level policies and understanding the broad population spread.
*/
SELECT 
    Name,
    (Population / SurfaceArea) AS Population_Density,
    CASE
        WHEN (Population / SurfaceArea) >= 100 THEN 'High Density'
        WHEN (Population / SurfaceArea) BETWEEN 50 AND 100 THEN 'Medium Density'
        WHEN (Population / SurfaceArea) < 50 THEN 'Low Density'
        ELSE NULL
    END AS Population_Density_Cat
FROM
    world.country
ORDER BY 
	Population_Density_Cat, Name;



/*
APPROACH B
This method focuses on the average population of cities within each country:
- Formula: Average City Population = Average of City Populations within the Country
- Classification:
   - High Density: Average city population of 500,000 or more
   - Medium Density: Average city population between 100,000 and 500,000
   - Low Density: Average city population below 100,000
This approach provides insights into urban density, crucial for urban planning and resource allocation.

*/

SELECT 
    c.Continent AS continent,
    c.Name AS country_name,
    AVG(city.Population) AS avg_city_population,
    CASE
        WHEN AVG(city.Population) >= 500000 THEN 'High'
        WHEN AVG(city.Population) BETWEEN 100000 AND 500000 THEN 'Medium'
        WHEN AVG(city.Population) < 100000 THEN 'Low'
    END AS population_density_class
FROM
    world.country AS c
        JOIN
    world.city AS city ON c.Code = city.CountryCode
GROUP BY c.Continent , c.Name
ORDER BY avg_city_population DESC;
 


