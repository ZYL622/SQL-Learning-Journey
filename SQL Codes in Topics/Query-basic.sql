/* 
=============================================================
This is the learning journey of 'Quary Topic' 
=============================================================

<Used dataset>: MyDatabase
    File Path: datasets/init-sqlserver-mydatabase.sql

<Included 9 Clauses>: (follow coding order)
    SELECT, DISTINCT, TOP, FROM, JOIN, WHERE, GROUP BY, HAVING, ORDER BY

<Involved Function>:
    Extract & Transform the data based on specific requirements
    >> Filter: 
        SELECT:     Filter Columns
        DISTINCT:   Filter Duplicates
        TOP:        Filter Rows
        WHERE:      Filter rows (act requiremnets) Before aggregation
        HAVING:     Filter row (act requiremnets) After aggregation

<Executing Order>: (which is different from coding order)
    (1) FROM ->      Get the focused table;
    (2) WHERE ->     Filter the rows before aggregation
    (3) GROUP BY ->  Aggregate the rows a.c.t the requirements
    (4) HAVING ->    Filter the rows after aggregation
    (5) SELECT ->    Filter the columns & Remove the unwanted 
    (6) DISTINCT ->  Filter Duplicated rows
    (7) ORDER BY ->  Sort the rows 
    (8) TOP ->       Filter fixed number of rows

<Notion>: 
    (1) Difference between SQL server & MySQL: SQL server uses 'TOP', but MySQL use LIMIT;
    (2) Clause 'JOIN' is not shown in this file. Please find in 'JOIN & SET - middle.sql'
*/

USE MyDatabase;

-- ======================================================
-- Use 'Select' & 'From'
-- ======================================================

-- Select Whole Tables
SELECT *
FROM customers;


-- Select specific columns: first_name, score
SELECT
	first_name,
	score
FROM customers;



-- ======================================================
-- FILTER DATA: WHERE
-- ======================================================
 
-- Retrive customers with a score not equal to 0
SELECT *
FROM customers
WHERE score != 0;

-- Retrive customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';



-- ======================================================
-- SORT DATA: ORDER BY
-- ======================================================
 
-- Retrive customers from Germany and
	-- sort the results by the highest score first.
SELECT *
FROM customers
WHERE country = 'Germany'
ORDER BY score DESC;


-- [Nested Sorting]: Sort the records by various variables with different priority
-- Retrive all customers and 
	-- sort the results by the country
    -- and then by the highest score
SELECT *
FROM customers
ORDER BY 
	country ASC,
    score DESC;



-- ======================================================
-- Aggrate DATA: GROUP BY
-- ======================================================
 
-- Find the total score for each country
SELECT 
    country, SUM(score) AS total_score
FROM
    customers
GROUP BY country;

-- Find the total score & total number of customers 
	-- for each country
SELECT 
    country,
    SUM(score) AS total_score,
    COUNT(id) AS total_number
FROM
    customers
GROUP BY country;



-- ======================================================
-- Filter Aggregated DATA: HAVING (after GROUP BY)
-- ======================================================

-- Find the average score for each country
	-- considering only customers with a score not equal to 0
    -- and return only those countries with an average score greater than 430
SELECT 
    country, 
    AVG(score) AS avg_score
FROM
    customers
WHERE
    score != 0
GROUP BY country
HAVING AVG(score) > 430;



-- ======================================================
-- Remove Duplicates: DISTINCT
-- ======================================================
 
-- Return Unique list of all countries
SELECT DISTINCT
    country
FROM
    customers;


-- ======================================================
/* Top / Limit DATA: 
    (1) Limit in MySQL (at last)
    (2) TOP in SQL Server (just after SELECT) */
-- ======================================================

-- Retrive only 3 customers 
    -- (SELECT TOP 3 * FROM customers in <SQL Server>)
    -- Use 'LIMIT 3' at the last in MySQL
SELECT TOP 3 
    *
FROM customers;


-- Retrive the Top 3 customers with highest scores
SELECT TOP 3 
    * 
FROM customers
ORDER BY score DESC;


-- Get the two most recent orders
SELECT TOP 2 
    * 
FROM orders
ORDER BY order_date DESC;



-- ======================================================
-- Add Static Columns
-- ======================================================

SELECT 
	*,
    'New customer' AS customer_type
FROM customers;
