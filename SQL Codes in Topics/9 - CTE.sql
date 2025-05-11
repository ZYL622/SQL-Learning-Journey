/* 
=========================================================================
This is the documentation of learning journey of 'Common Table Expression (CTE)' 
=========================================================================

< Used Database >:  
    (1) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql

< Definition >
    - CTE: Temporary, named result set (virtual table), 
        that can be used multiple time within your query to simplify and organize complex query
    - Execution: 
        (1) CTE will be executed at first, and then be stored in Cache
        (2) Afterwards, main query will be executed
        (3) Once the query is finished, the results will be return to database engine and send to
            client side.

< Difference between CTE & Subquery >
    The results from the subquery can only be used for once;
    The results from CTE can be reused for multiple times.

< Why CTE? >
    (1) Reuseability:   Break down complex queries into smaller pieces
    (2) Modularlity:    Pieces are easy to manage, develop, and self-contained
    (3) Reusability:    Reduce redundency
    (4) Recursive:      Allow Iterations & Looping in SQL

< Notion >
    (1) Cannot use ORDER BY directly within the CTE
    (2) Pursue Best Performance: Rethink and refactor your CTEs before starting a new one.
        (Don't use more than 5 CTEs in one query; otherwise, codes will be hard to understand and maintain)

< CTE Types >
    (1) Non-Recursive CTE   >> Executed only once without any repetition
        - Standalone CTE
        - Nested CTE

    (2) Recursive CTE       >> Self-referencing query that repeatedly processes data until a specific condition is met


=================== Standalone CTE  =================== 

- A CTE query that defined and used independently.
    It runs independently as it's self-contained and doesn't rely on other CTEs or queries.

=== Codes - CTE Definition ===
    WITH CTE-Name1 AS
    (
        SELECT ...
        FROM ...
        WHERE ...
    )
    , CTE-Name2 AS
    (
        ...
    )

=== Codes - CTE Usage ===
    SELECT ...
    FROM CTE-Name
    WHERE ...


=================== Nested CTE  =================== 
- CTE inside another CTE
    >> A nested CTE uses the result of another CTE, so it can't run independently

=== Codes ===
    WITH CTE-Name1 AS
    (
        SELECT ...
        FROM ...
        WHERE ...
    )
    , CTE-Name2 AS
    (
        SELECT ...
        FROM CTE-Name1
        WHERE ...
    )
    -- Main Query
    SELECT ...
    FROM CTE-Name
    WHERE ...

=================== Recursive CTE  =================== 
- It consists of 2 different parts: Anchor Query & Recursive Query
    The Anchor Query will be executed at first & only once
    Afterwards, Recursive Query will be iteratively executed until the condition is met
    At last, the iteration stop & return the final result after run the Main Query

=== Codes ===
    WITH CTE-Name AS
    (
        SELECT ...
        FROM ...
        WHERE ...

        UNION / ....

        SELECT ...
        FROM CTE-Name
        WHERE [Break Condition]
    )
    -- Main Query
    SELECT ...
    FROM CTE-Name
    WHERE ...
    OPTION (MAXRECURSION ...) -- Define the maximum number of recursions
*/

USE SalesDB;

-- =================== Standalone CTE  =================== 


/* Join the info about total sales into the customer table */
-- Step 1: Find the total sales per customer 
WITH CTE_SaleCustomer AS
    (SELECT 
        CustomerID
        , SUM(Sales) AS TotalSalesPerCustomer
    FROM Sales.Orders
    GROUP BY CustomerID
    )
-- Main Query: 
SELECT 
    c.CustomerID
    , FirstName
    , LastName
    , s.TotalSalesPerCustomer
FROM Sales.Customers AS c
LEFT JOIN CTE_SaleCustomer AS s
ON s.CustomerID = c.CustomerID;

-- =================== Nested CTE  ===================
/* Multiple Standalone CTE
    - Find the total sales per customer 
    - Find the last order date of each customer
    - Rank Customers based on total sales per customer
*/
-- Step 1: Find the total sales per customer 
WITH CTE_SaleCustomer AS
    (SELECT 
        CustomerID
        , SUM(Sales) AS TotalSalesPerCustomer
    FROM Sales.Orders
    GROUP BY CustomerID)
    -- Step 2: Find the last order date of each customer
    , CTE_LastOrderDate AS
    (SELECT 
        CustomerID
        , MAX(OrderDate) AS LastOrderDate
    FROM Sales.Orders
    GROUP BY CustomerID)
    -- Step 4: Segment customers based on their total sales (> 100 High; > 50 Medium; Else Low)
    , CTE_CustomerSeg AS 
    (SELECT 
        CustomerID
        , CASE 
            WHEN TotalSalesPerCustomer > 100 THEN 'High'
            WHEN TotalSalesPerCustomer > 50 THEN 'Medium'
            ELSE 'Low'
        END AS CustomerSeg
    FROM CTE_SaleCustomer)
-- Main Query
SELECT 
    c.CustomerID
    , c.FirstName
    , c.LastName
    , ct_s.TotalSalesPerCustomer
    -- Step 3: Rank Customers based on total sales per customer
    , RANK() OVER(ORDER BY ct_s.TotalSalesPerCustomer DESC) AS Rank
    -- Inster the result from step 4
    , csg.CustomerSeg
    , ct_t.LastOrderDate
FROM Sales.Customers AS c
LEFT JOIN CTE_SaleCustomer AS ct_s
ON ct_s.CustomerID = c.CustomerID
LEFT JOIN CTE_LastOrderDate AS ct_t
ON ct_t.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerSeg AS csg 
ON csg.CustomerID = c.CustomerID;


-- =================== Recursive CTE  =================== 

/* Generate a Sequence of numbers from 1 to 20 */
WITH Series AS
    -- Anchor Query
    (SELECT 1 AS MyNumber

    UNION ALL
    -- Recursive Query
    SELECT MyNumber + 1 AS MyNumber
    FROM Series
    WHERE MyNumber < 20)
-- Main Query
SELECT * FROM Series;


/* Show the employee hierarchy by displaying each employee's level within the organization 
    Include columns: EmployeeID, FirstName, ManagerID, Level    */

WITH CTE_Emp_Hierarchy AS
    -- Anchor Query
    (SELECT 
        EmployeeID
        , FirstName
        , ManagerID
        , 1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursice Query
    SELECT 
        e.EmployeeID
        , e.FirstName
        , e.ManagerID
        , Level + 1 AS Level        
    FROM Sales.Employees AS e
    INNER JOIN CTE_Emp_Hierarchy AS ceh
    ON e.ManagerID = ceh.EmployeeID
    )
-- Main Query
SELECT *
FROM CTE_Emp_Hierarchy;
