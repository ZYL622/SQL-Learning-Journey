/*
=========================================================================
This is the documentation of learning journey of 'Combination' 
=========================================================================

< Used Database >:  
    (1) MyDatabase
        >> File Path: datasets/init-sqlserver-mydatabase.sql

< JOIN & SET >
    - Aim:    Combine two tables into one table
    - Difference:     
        If adding Columns a.c.t KEY Column, Then use JOINS
        If adding Rows a.c.t same Columns, Then use SET
        
	  - Usage scenario for JONINS:
		    (1) Combine data to get 'Big Picture'
        (2) Data Enrichment to get 'Extra Info'
        (3) Check existance as 'Filter'

======================================================
=======================  JOIN  =======================
======================================================

>> Inner Join: 
	Return only matching data from both tables on <condition>
	===================== CODE =====================
        SELECT *
        FROM A/B
        INNER JOIN B/A
        ON A.key = B.key
	===================== CODE =====================

>> Left Join: 
        Return all rows from Left and only matching from Right (order-sensitive)
	(non-matching rows will get NULL)
	===================== CODE =====================
        SELECT *
        FROM A
        LEFT JOIN B
        ON A.key = B.key
	===================== CODE =====================

>> FULL JOIN: 
	Return all rows from both tables << In SQL Server: >>
	(non-matching rows will get NULL)
	===================== CODE =====================	
        SELECT *
        FROM A/B
        FULL JOIN B/A
        ON A.key = B.key
	===================== CODE =====================

>> Left ANTI JOIN: 
        Return rows from LEFT that has NO Match in the RIGHT table
	===================== CODE =====================
        SELECT *
        FROM A
        LEFT JOIN B
        ON A.key = B.key
        WHERE B.key IS NULL -- since there is no match data from B
	===================== CODE =====================

>> FULL ANTI JOIN: 
        Return only rows that don't match in either tables
	===================== CODE =====================
        SELECT *
        FROM A
        FULL JOIN B
        ON A.key = B.key
        WHERE A.key IS NULL OR B.key IS NULL
	===================== CODE =====================


>> CROSS JOIN: 
        All possible combination among two tables
	===================== CODE =====================	
        SELECT *
        FROM A
        CROSS JOIN B -- No condition is needed
    	===================== CODE =====================

======================================================
=======================  SET  ========================
======================================================

>> Usage
    (1) SET Operator can be used almost in all clauses: WHERE | JOIN | GROUP BY | HAVING
    (2) ORDER BY is allowed only once at the end of query
    (3) The number of columns in each query must be the same
    (4) The order of the columns in each query must be the same
    (5) The column names in the results are determined by the column names specified in the first query
    (6) Notion: Incorrect column selection leads to inaccurate results

======================================================
======================  UNION  =======================
======================================================

>> UNION
    -- UNION: Return all distinct rows from both queries

    -- UNION ALL: Return all rows from both queries, including duplicates

    -- UNION ALL is faster than UNION -> If no duplicates, then use UNION ALL

======================================================
======================  EXCEPT  ======================
======================================================

>> EXCEPT
    Return all distinct rows from the 1st query that are not found in the 2nd query
    ** Notion **
        (1) query order sensitive
        (2) Use MINUS in other database
    - Data completeness check (EXCEPT use case)
        By using 'EXCEPT' with changing the order of table, we can check whether 2 tables are identical

======================================================
=====================  INTERSECT  ====================
======================================================

>> INTERSECT: 
    Return only the distinct rows that are common in both queries

---------------------------------------------------------------------

** Usages ** 
    (1) Combine similar information before analyzing the data
    (2) Identify the differences or changes between 2 batches of data

** Note ** 
    (1)In practice, Never use '*' to combine tables; list needed columns instead
    (2) Add Source Flag: Include additional column to indicate the source of each row

*/

USE MyDatabase;


/* No Join: Return data from tables without combining them
    Retrieve all data from customers and orders in two different results */
SELECT *
FROM customers;

SELECT *
FROM orders;


/* ===================== INNER JOIN =====================
    Get all customers along with their orders 
    but only for customers who have placed an order */

-- Option 1
SELECT
    customers.id,
    customers.first_name,
    orders.order_id,
    orders.sales
FROM customers
    INNER JOIN orders
    ON customers.id = orders.customer_id;

-- Option 2
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
    INNER JOIN orders AS o
    ON c.id = o.customer_id;

-- Option 3
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
    LEFT JOIN orders AS o
    ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;


/* ===================== LEFT JOIN =====================
    Get all customers along with their orders, including those without orders */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
    LEFT JOIN orders AS o
    ON c.id = o.customer_id;


SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o
    RIGHT JOIN customers AS c -- Not recomment to use RIGHT JOIN
    ON c.id = o.customer_id;


/* ===================== FULL JOIN =====================
    Get all customers and all orders enven if there's no match */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
    FULL JOIN orders AS o
    ON c.id = o.customer_id;


/*  ===================== LEFT ANTI JOIN =====================
    Get all customers who haven't placed any order */
SELECT *
FROM customers AS c
    LEFT JOIN orders AS o
    ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

SELECT *
FROM orders AS o
    RIGHT JOIN customers AS c
    ON o.customer_id = c.id
WHERE o.customer_id IS NULL;

-- Get all orders without matching customers
SELECT
    *
FROM orders AS o
    LEFT JOIN customers AS c
    ON o.customer_id = c.id
WHERE c.id IS NULL;


/* ===================== FULL ANTI JOIN =====================
    Find customers without orders and orders without customers */
SELECT *
FROM customers AS c
    FULL JOIN orders AS o
    ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;


/* ===================== CROSS JOIN =====================
    Generate all possible combinations of customers and orders */

SELECT *
FROM customers 
CROSS JOIN orders;


/* General Task:
    Using SalesDB, retrieve a list of all orders, along with the related customers, products, and employee details
*/
-- >> Build a Entity Relationship Model (ER Model)
USE SalesDB;

SELECT TOP 3
    *
FROM Sales.Orders;

SELECT TOP 3
    *
FROM Sales.Products;

SELECT TOP 3
    *
FROM Sales.Employees;

SELECT
    *
FROM Sales.Customers;

SELECT
    o.OrderID AS 'OrderID',
    TRIM(ISNULL(c.FirstName, '') + ' ' + ISNULL(c.LastName, '')) AS "Customer's name",
    p.Product AS 'Product name',
    o.Sales AS 'Sales Amount',
    p.Price AS 'Product Price',
    TRIM(ISNULL(e.FirstName, '') + ' ' + ISNULL(e.LastName, '')) AS "Saleperso's name"

FROM Sales.Orders AS o
    LEFT JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
    LEFT JOIN Sales.Products AS p
    ON o.ProductID = p.ProductID
    LEFT JOIN Sales.Employees AS e
    ON o.SalesPersonID = e.EmployeeID;



/* Combine the data from employees and customers into one table (exclude duplicates)
    extract FirstName, LastName */

    SELECT
        FirstName,
        LastName
    FROM Sales.Employees
UNION
    SELECT
        FirstName,
        LastName
    FROM Sales.Customers;


-- Find employees who are not customers at the same time
-- extract FirstName, LastName
    SELECT
        FirstName,
        LastName
    FROM Sales.Employees
EXCEPT
    SELECT
        FirstName,
        LastName
    FROM Sales.Customers;


SELECT e.*
FROM Sales.Employees AS e
    INNER JOIN
    (
                                SELECT
            FirstName,
            LastName
        FROM Sales.Employees
    EXCEPT
        SELECT
            FirstName,
            LastName
        FROM Sales.Customers
    ) AS non_c_e
    ON e.FirstName = non_c_e.FirstName AND e.LastName = non_c_e.LastName
ORDER BY e.EmployeeID;



-- Find employees who are also customers
-- Extract all employees' info
    SELECT
        FirstName,
        LastName
    FROM Sales.Employees
INTERSECT
    SELECT
        FirstName,
        LastName
    FROM Sales.Customers;


/* Combine all orders into one report without duplicates
    orders data are stored in separate tables (Orders & OrdersArchive) */
    SELECT
        [OrderID],
        [ProductID],
        [CustomerID],
        [SalesPersonID],
        [OrderDate],
        [ShipDate],
        [OrderStatus],
        [ShipAddress],
        [BillAddress],
        [Quantity],
        [Sales],
        [CreationTime],
        'Sales.Orders' AS SourceTable
    FROM Sales.Orders
UNION
    SELECT
        [OrderID],
        [ProductID],
        [CustomerID],
        [SalesPersonID],
        [OrderDate],
        [ShipDate],
        [OrderStatus],
        [ShipAddress],
        [BillAddress],
        [Quantity],
        [Sales],
        [CreationTime],
        'Sales.OrdersArchive'
    FROM Sales.OrdersArchive
ORDER BY OrderID;
