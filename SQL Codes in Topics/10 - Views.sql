/* 
=========================================================================
This is the documentation of learning journey of 'VIEWS' 
=========================================================================

< Used Database >:  
    (1) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql

< Definitation >
    -  Virtual table based on the result set of a query, without storing data in database
    -> Views are persisted SQL queries in the database.

< VIEW vs TABLE >
            VIEW                                    TABLE
            No persistance                          Persisted Data
            Easy to Maintain & Change               Hard to Maintain & Change
            Slow response                           Fast response
            Read                                    Read / Write

< VIEW vs CTE >
            VIEW                                            CTE
            Reduce redundancy in multiple queries           Reduce redundancy in 1 query
            Improve reusability in multiple queries         Improve reusability in 1 query
            Persisted logic                                 Temporary Logic on thr fly
            Need to maintain (create/drop)                  No maintainance (auto cleanup)

< Use Case >
    (1) Sotre Central Complex Query Logic to be reused 
        - Store central, complex query logic in the database for access by multiple queries, 
            reducing project complexity
    (2) Hide Complexity
        - Views can be use to hide the complexity of database tables and 
            offer users more friendly and easy-to-consume object
    (3) Data Security
        - Use views to enforce security and protect sensitive data,
            by hiding columns or rows from tables
    (4) Flexibility & Dynamic
        - Users can have freedom to change column names & make changes
    (5) Multiple Languages
        - Provide customerized views to different clients
    (6) Virtual Data Marts in DWH
        - Views can be used as Data Marts in Data Warehouse System because they provide a flexible
            and efficient way to present data.
        {Data marts}: are specialized subsets of data warehouses that are focused on a specific business line, 
                        department, or function—such as sales, finance, or marketing.
     
----------------------------------------------------------------------------------------

< CREATE / UPDATE / DROP >

=================== Create View  =================== 

=== Codes ===
CREATE VIEW SchemaName.ViewName AS
(
    SELECT ...
    FROM ...
    WHERE ...
)


=================== Drop View  =================== 

=== Codes ===
DROP VIEW SchemaName.ViewName


=================== Update View  =================== 

First Drop, then Create it
=== Codes ===
IF OBJECT_ID ('SchemaName.ViewName', 'V') IS NOT NULL
    DROP VIEW SchemaName.ViewName;
GO
CREATE VIEW SchemaName.ViewName AS
(
    SELECT ...
    FROM ...
    WHERE ...
)


*/


USE SalesDB;

/* Find the running total of sales for each month (in table Sales.Orders)
    Include the columns: OrderMonth, TotalSales, RuningTotal
    Task 1: Realize it by using CTE
    Task 2: Realize it by using View    */

-- === Task 1 ===
-- CTE: calculate TotalSales in each month
WITH CTE_Monthly_Summary AS
    (SELECT 
        DATETRUNC(month, OrderDate) AS OrderMonth
        , SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate))
-- Main Query
SELECT 
    OrderMonth
    , TotalSales
    , SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary;


-- === Task 2 ===
-- Create View
CREATE VIEW Sales.V_Monthly_Summary AS
    (SELECT 
        DATETRUNC(month, OrderDate) AS OrderMonth
        , SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate));
-- Use View
SELECT 
    OrderMonth
    , TotalSales
    , SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM Sales.V_Monthly_Summary;


-- =================== Hide Complexity  ===================

/* Provide a view that combines details from 
    orders, products, customers, and employees */
CREATE VIEW Sales.V_OrderDetails AS
    (SELECT 
        o.OrderID
        , o.OrderDate
        , p.Product
        , p.Category
        , p.Price
        , o.Sales
        , o.Quantity
        , TRIM(COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '')) AS CustomerName
        , c.Country AS CustomerCountry
        , TRIM(COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '')) AS SalesName
        , e.Department
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
    LEFT JOIN Sales.Products AS p 
    ON o.ProductID = p.ProductID
    LEFT JOIN Sales.Employees AS e 
    ON o.SalesPersonID = e.EmployeeID)

SELECT * 
FROM Sales.V_OrderDetails;


-- =================== Data Security  =================== 

/* Provide a view for the EU Sales Team that 
    combines details from all tables and excludes data related to the USA */
-- Only difference with previous one: Add WHERE to filter out rows that customers from USA

CREATE VIEW Sales.V_EU_OrderDetails AS
    (SELECT 
        o.OrderID
        , o.OrderDate
        , p.Product
        , p.Category
        , p.Price
        , o.Sales
        , o.Quantity
        , TRIM(COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '')) AS CustomerName
        , c.Country AS CustomerCountry
        , TRIM(COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '')) AS SalesName
        , e.Department
    FROM Sales.Orders AS o 
    LEFT JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
    LEFT JOIN Sales.Products AS p 
    ON o.ProductID = p.ProductID
    LEFT JOIN Sales.Employees AS e 
    ON o.SalesPersonID = e.EmployeeID
    WHERE c.Country != 'USA');

SELECT *
FROM Sales.V_EU_OrderDetails;
