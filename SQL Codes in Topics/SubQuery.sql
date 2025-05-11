/* 
=========================================================================
This is the documentation of learning journey of 'SubQuery' 
=========================================================================

< Used Database >:  
    (1) MyDatabase
        >> File Path: datasets/init-sqlserver-mydatabase.sql
    (2) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql

< Note >
    (1) The results from Subquery can only be used by the Main Query
    (2) Main Query can have 2 sources: Original database; Results from Subquery

< Category >
    - Dependency between Main Query & SubQuery
        (1) Non-correlated Subquery
            - A subquery that can run independently from the Main Query
            > Subquery will be executed before the main query
            > Both Subquery can Main query will only be executed once
            > Lead to better performance
            > Usage: Static comparison, Filter with constants

        (2) Correlated Subquery
            - A subquery that relays on values from the Main Query
            > Subquery will be executed for each row by the main query
            > Subquery cannot be executed by its own
            > Executed multiple times and Lead to bad performance
            > Usage: Row-by-Row comparison, Dynamic filtering
            

    - Result Types
        (1) Scalar Subquery >> Only return single value
        (2) Row Subquery    >> Return multiple rows (single column)
        (3) Table Subquery  >> Return as table (multiple rows & multiple columns)

    - Location & Clauses:  
        Where the subquery will be used in the main query
        (1) SELECT; (2) FROM; (3) JOIN; 
        (4) WHERE
            - Comparision Operators
            - Logical Operators: IN, ANY, ALL, EXISTS


=================== FROM Subquery  ===================   

- Used as temporary table for the main query

=== Codes ===
    SELECT column_1, column2, ...
    FROM (
        SELECT column FROM table_1 WHERE condition
    ) AS alias


=================== SELECT Subquery  ===================   

- Used to aggregate data side by side with the main query's data,
    allowing for direct comparsion

=== Codes ===
    SELECT column_1,
    (SELECT column FROM table_1 WHERE condition) AS alias
    FROM table_1

** Notion **
    (1) The results from SELECT Subquery have to be a single value


=================== JOIN Subquery  =================== 

- Used to prepare the data (filtering or aggregation) before joining it with other tables

=================== WHERE Subquery  =================== 

- Used for complex filtering logic and makes query more flexible and dynamic

=== Codes ===
    SELECT column1, column2, ...
    FROM table1
    WHERE column = (SELECT column FROM table2 WHERE condtion)

** Notion **    The results from SELECT Subquery have to be a single value


=================== IN Operator Subquery  ===================

- Check whether a value matches any value from a list

=== Codes ===
    SELECT column1, column2, ...
    FROM table1
    WHERE column IN (SELECT column FROM table2 WHERE condtion)


=================== ANY / ALL Operator Subquery  ===================

- ANY   >> Check if a value matches ANY value within a list
- ALL   >> Check if a value matches ALL values with in a list

=== Codes ===
    SELECT column1, column2, ...
    FROM table1
    WHERE column ANY / ALL (SELECT column FROM table2 WHERE condtion)


=================== EXISTS Operator - Correlated Subquery  ===================

- Check if a subquery returns any rows
    - If No results from subquery, then row of main query is Excluded
    - If there are values returned from subquery, then row of main query is Included

=== Codes ===
    SELECT column1, column2, ...
    FROM table2
    WHERE EXISTS (SELECT 1
                FROM table1
                WHERE table1.col_name = table2.col_name)

--------------------------------------------------------------------
=== Usage Summary ===
    (1) Create temporary result set
    (2) Prepare data before Joining tables
    (3) Dynamic & Complex Filtering
    (4) Check the existance of rows from another table (EXISTS)
    (5) Row by row comparison (Correlated subquery)

*/

USE SalesDB;


-- =================== FROM Subquery  ===================

/* Find the products that have a price higher than the average price of all products (in table Sales.Products)*/

-- Main Query
SELECT  
    ProductID
    , Price
    , AvgPrice
FROM
    -- Subquery: Calcualte average price
    (SELECT 
        *
        , AVG(Price) OVER() AS AvgPrice
    FROM Sales.Products)t 
WHERE Price > AvgPrice;


-- Rank customers based on their total amount of sales (in table Sales.Orders)
SELECT DISTINCT
    CustomerID
    , TotalSalesByCustomer
    , DENSE_RANK() OVER(ORDER BY TotalSalesByCustomer DESC) AS CustomerRank
FROM
    -- Subquery: Calcualte sum of sales of each CustomerID
    (SELECT 
        OrderID
        , CustomerID
        , Sales
        , SUM(Sales) OVER(PARTITION BY CustomerID) AS TotalSalesByCustomer
    FROM Sales.Orders)t;

-- == Quick ==
SELECT 
    CustomerID
    , TotalSalesByCustomer
    , RANK() OVER(ORDER BY TotalSalesByCustomer DESC) AS CustomerRank
FROM
    -- Subquery: Calcualte sum of sales of each CustomerID
    (SELECT
        CustomerID
        , SUM(Sales) AS TotalSalesByCustomer
    FROM Sales.Orders
    GROUP BY CustomerID)t;


-- =================== SELECT Subquery  ===================  

/* Show the product IDs, names, prices, and total number of orders (Sales.Orders) */
SELECT 
    ProductID
    , Product AS ProductName
    , Price
    -- Sunquery: Calculate total number of orders
    , (SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;


-- =================== JOIN Subquery  =================== 

/* Show all customer details and find the total orders for each customer (Sales.Orders) */

-- == Option 1 ==
-- Main Query
SELECT 
    c.*,
    o.TotalOrdersByCustomer
FROM
    -- SubQuery: calculate total orders for each customer
    (SELECT 
        CustomerID
        , COUNT(*) TotalOrdersByCustomer
    FROM Sales.Orders
    GROUP BY CustomerID) AS o
LEFT JOIN
    Sales.Customers AS c
    ON o.CustomerID = c.CustomerID;

-- == Option 2 ==
-- Main Query
SELECT 
    c.*
    , o.TotalOrdersByCustomer
FROM Sales.Customers AS c
LEFT JOIN
    -- SubQuery: calculate total orders for each customer
    (SELECT 
            CustomerID
            , COUNT(*) TotalOrdersByCustomer
        FROM Sales.Orders
        GROUP BY CustomerID) AS o
    ON o.CustomerID = c.CustomerID
WHERE o.CustomerID IS NOT NULL;


-- =================== WHERE Subquery  =================== 

/* Find the products that have a price higher than the average price of all products (in table Sales.Products)*/
SELECT *
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);


-- =================== IN Operator Subquery  ===================

/* Show the details of orders made by customers in Germany */
SELECT *
FROM Sales.Orders
WHERE CustomerID IN 
        -- Subquery: Select the CustomerID in in Germany
        (SELECT CustomerID
        FROM Sales.Customers
        WHERE Country = 'Germany'); 


-- =================== ANY / ALL Operator Subquery  ===================

/* Find female employees whose salaries are greater than the salaries of Any male employees */
SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND 
        Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


/* Find female employees whose salaries are greater than the salaries of All male employees */
SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND 
        Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


-- =================== Correlated Subquery ===================

/* Show all customer details and find the total orders for each customer */
SELECT 
    *
    , (SELECT COUNT(*) FROM Sales.Orders AS o WHERE o.CustomerID = c.CustomerID) AS TotoalOrderByCustomer
FROM Sales.Customers AS c;

-- =========== EXISTS Operator - Correlated Subquery  ===========

/* Show the order details for customers in Germany */
SELECT * 
FROM Sales.Orders AS o
WHERE EXISTS (SELECT 1 FROM Sales.Customers AS c 
                WHERE o.CustomerID = c.CustomerID AND c.Country = 'Germany');

SELECT *
FROM Sales.Customers
WHERE Country = 'Germany'
