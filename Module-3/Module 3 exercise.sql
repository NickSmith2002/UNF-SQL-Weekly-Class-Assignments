SHOW TABLES;

-- Nicholas Smith Module 3 exercise

USE classicmodels;

-- Return customerNumber, customerName, and country from customers.
SELECT 
    customerNumber, customerName, country
FROM
    customers;

-- Show the same columns but alias them as id, name, and nation
SELECT 
    customerNumber AS 'id',
    customerName AS 'name',
    country AS 'nation'
FROM
    customers;

-- List distinct countries present in customers.
SELECT DISTINCT
    country
FROM
    customers;

-- From products, return productCode, productName, and the expression MSRP - buyPrice aliased as grossMargin
SELECT 
    productCode, productName, (MSRP - buyPrice) AS grossMargin
FROM
    products;


-- Return the full address for customers
SELECT 
    customerName,
    CONCAT(COALESCE(addressLine1, ' '),
            ' ',
            COALESCE(addressLine2, ' '),
            ' ',
            COALESCE(city, ' '),
            ' ',
            COALESCE(state, ' '),
            ' ',
            COALESCE(postalCode, ' '),
            ' ',
            COALESCE(Country, ' ')) AS Full_address
FROM
    classicmodels.customers;


-- List customers in the USA or Canada.
SELECT 
    *
FROM
    classicmodels.customers
WHERE
    country IN ('USA' , 'Canada')
;

-- Return the orders that have been Shipped or Cancelled
SELECT 
    *
FROM
    classicmodels.orders
WHERE
    status IN ('Shipped' , 'Cancelled')
        AND orderDate BETWEEN '2004-01-01' AND '2004-12-31'
ORDER BY orderDate
;

-- Return the customers whose Last Name starts with Smi
SELECT 
    *
FROM
    classicmodels.customers
WHERE
    contactLastName LIKE 'Smi%'
;

-- Return the employees who do not report to anyone
SELECT 
    *
FROM
    classicmodels.employees
WHERE
    reportsTo IS NULL;

-- List the 10 most expensive products by MSRP (show productCode, productName, MSRP)
SELECT 
    productCode, productName, MSRP, buyPrice
FROM
    classicmodels.products;

SELECT 
    productCode, productName, MSRP
FROM
    classicmodels.products
ORDER BY MSRP DESC
LIMIT 10;

-- Show the first 5 orders when sorted descending by orderDate.
SELECT 
    *
FROM
    classicmodels.orders
ORDER BY orderDate DESC
LIMIT 5;

-- Return customers sorted by creditLimit (highest first), but skip the top 5 and show the next 5.
SELECT 
    customerName, creditLimit
FROM
    classicmodels.customers
ORDER BY creditLimit DESC
LIMIT 5 OFFSET 5;
