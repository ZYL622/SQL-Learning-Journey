/* 
=========================================================================
This is the documentation of learning journey of 'Functions - Multi-Row' 
=========================================================================

< Used Database >:  
    (1) MyDatabase
        >> File Path: datasets/init-sqlserver-mydatabase.sql
    (2) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql


< Multi-Row Functions >     
    Defination: Inputs are multiple values, output is a single value 
    Include:
        - Aggregate
        - Window


======================================================
===============  Window Function Basics  =============
======================================================


< Definiation of Window Function >
    Perform calculations on a specific subset of data without losing the level of details of rows.
    (return a result for each row)
    = Aggregation + Keep Details 


>> The difference is that Window Aggregation is composed of two parts:
    (1) Window Function:    Perform calculations within a window
        - Aggregation Functions
        - Ranking Functions
        - Value/Analytics Functions

    (2) OVER Clause:        Define the window
        - Partition Clause
        - Order Clause
        - Frame Clause


>> 4 Rules of window functions
    (1) Window functions can ONLY be used in SELECT & ORDER BY Clauses
        CANNOT be used to filter data
    (2) Nesting Window Functions is not allowed
    (3) SQL execute Window Functions After WHERE Clause
    (4) Window functions can be used together with GROUP BY in the same query, 
        only if the same columns are used.

----------------------------------------

>> Partition Clause
    - Aim:  Divide the dataset into windows/partitions
            = Divide the rows into groups, based on the column(s)

    - Usages: Optional for all Window Functions

    ** e.g ** OVER():                       Calculation is done on the entire dataset
    ** e.g ** OVER(PARTITION BY col_name):  Calcualtion is done individually on each window


>> Order Clause
    - Aim:      Sort the data within a window independently (ASC or DESC)

    - Usage:    Optional for Aggregation Functions
                Required for Rank & Value Functions

    ** e.g ** RANK() OVER(ORDER BY col_name DESC)


>> Frame Clause
    - Aim:  Define a subset of rows WithIN each window that is relevant for the calculation
            (Define some rows that are inside window, as the entire data is divided into several windows)

    - Usage:    
        (1) !!! Frame Clause Can Only be used toghther with ORDER BY clause
        (2) Include 3 stuffs:
            - Frame Types: ROWS, RANGE
            - Frame Boundary (lower value, higher value): 
                CURRENT ROW, N PRECEDING / FOLLOWING, UNBOUNDED PRECEDING / FOLLOWING
        (3) Lower value must be before the higher value
        (4) Default frame: If you use ORDER BY but not Frame, then it will be regarded as 
                BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

    ** e.g **   SUM(Sales)
                OVER(ORDER BY MONTH
                    ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
                >> Only sum up the sales of the current row & sales in the next 2 rows

    ** e.g **   SUM(Sales)
                OVER(ORDER BY MONTH
                    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
                >> Sum up the sales in the current row & also in the following rows until the end

    ** e.g **   SUM(Sales)
                OVER(ORDER BY MONTH
                    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
                >> Sum up the sales in the current row & previous one row

    ** e.g **   SUM(Sales)
                OVER(ORDER BY MONTH
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                >> Sum up the sales in the current row & all rows before

    ** e.g **   SUM(Sales)
                OVER(ORDER BY MONTH
                    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
                >> Sum up the sales in the current row & next row & previous row


======================================================
==================  Window Aggregate  ================
======================================================

>> Basic functions are same as GROUP BY for aggregation:
    COUNT(allType_expr), 
    SUM(numeric_expr), 
    AVG(numeric_expr), 
    MIN(numeric_expr), 
    MAX(numeric_expr)

----------------------------------------

- COUNT()   >> Return the number of rows within a window

    ** e.g **   COUNT(*) / COUNT(1) OVER(PARTITION BY Product)
                >> Find the total nr. of orders for each product (include NULLs, consider by rows)

    ** e.g **   COUNT(Sales) OVER(PARTITION BY Product)
                >> Find the total nr. of valid sales for each product (don't count in NULL values)

    ** Notion **
        (1) If use COUNT(*) / COUNT(1), then only count rows
            Else if use COUNT(col_name), then counts the nr. of non-NULL values in the column

    >> Usage:   
        (1) Overall Analysis                (2) Category Analysis   
        (3) Quality Check: Identify NULLs   (4) Quality Check: Identify Duplicates


- SUM()     >> Return the sum of values within each window (same value for each window)
- AVG()     >> Returns the average of values within a window
- MIN()     >> Returns the lowest value within a window
- MAX()     >> Returns the highest value within a window

----------------------------------------

** Notion ** 
        (1) Above functions only accept Numbers, thus, NULLs will be ignored
            (If the NULLs need to be regard as 0, then should use COALESCE(col_name, 0) at first)

** Usage **
    (1) Comparision Use Cases    
        >> Comapre the current value and aggregated value of window functions
    (2) Running & Rolling total
        >> Aggregate sequence of numbers, and the aggregation is updated each time a new menber is added
        - [Running Total]:    Aggregate all values from the beginning up to the current point 
                            without dropping off older data
            ** e.g **   SUM(Sales) OVER(ORDER BY Month
                                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

        - [Rolling Total]:    Aggregate all values within a fixed time window (e.g. 30 days). 
                            When new data is added, the oldest data point will be dropped.
            ** e.g **   SUM(Sales) OVER(ORDER BY Month
                                        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

        (a) Tracking:    Track current sales with target sales
        (b) Trend Analysis:  Provide insights into historical patterns


=== Summary ===
    (1) Overall Total   >> SUM(col_name) OVER()
    (2) Total per Group >> SUM(col_name) OVER(PARTITION BY col_name)
    (3) Running Total   >> SUM(col_name) OVER(ORDER BY col_name)
    (4) Rollong Total   >> SUM(col_name) OVER(ORDER BY col_name 
                                            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)


======================================================
==================  Window Ranking  ==================
======================================================

>> 2 Types of Ranking
    (1) Integer-based Ranking:      Give discrete integers to show the rank
        - ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()

    (2) Percentage-based Ranking:   Give continuous values from 0 to 1 to show the Cumulative percentage
        - CUME_DIST(), PERCENT_RANK()


>> ROW_NUMBER():    
    - Assign a unique number to each row
    (Two rows with Same info will NOT share same ranks)

>> RANK()
    - Assign a rank to each row 
    (Two rows with Same info will share same ranks & leave gaps in ranking)
    ** e.g **   RANK() OVER(ORDER BY Sales DESC)

>> DENSE_RANK()
    - Assign a rank to each row
    (Two rows with Same info will share same ranks & NOT leaving gaps in ranking)


=== Summary ===
    ROW_NUMBER()                    RANK()                              DENSE_RANK()
    Unique Rank                     Allow Shared Rank                   Allow Shared Rank
    Does NOT handle ties            Handle Ties                         Handle Ties
    No Gaps in Ranks                Allow Gaps in Ranks                 No Gaps in Ranks

** Usage **
    (1) Generate unique IDs by using ROW_NUMBER()
    (2) Identify and remove duplicate rows to improve data quality
    (3) Top-N analysis; Bottom-N analysis

---------------------------------------------------------------------------------------

>> CUME_DIST()
    - Calculate the distribution of data points within a window (same value share same result)
        = Position Nr / Number of rows in the window

    ** e.g **   Codes:       CUME_DIST() OVER (ORDER BY Sales DESC)
                Given sales: 100,     80,     80,     50,     30    
                Output:      1/5,     3/5,    3/5,    4/5,    5/5

>> PERCENT_RANK()
    - Calculate the relative position of each row (if there is ties, then use the position of the first occurance)
        = (Position Nr - 1) / (Number of rows in the window - 1)

    ** e.g **   Codes:       PERCENT_RANK() OVER (ORDER BY Sales DESC)
                Given sales: 100,       80,         80,         50,         30
                Output:      (1-1)/4,   (2-1)/4,    (2-1)/4,    (4-1)/4,    (5-1)/4

- Difference between CUME_DIST() & PERCENT_RANK()
    CUME_DIST():    Inclusive (current row is included)
    PERCENT_RANK(): Exclusive (current row is excluded)

---------------------------------------------------------------------------------------

>> NTILE(numeric_expr)
    - Divide rows into a specified number of approximately equal groups (Buckets)
        (Larger groups come first. => 5 rows divided into 2 groups, then first group will include 3 rows)
    - Usage:
        (1) Data Segmentation:  
            >>  Divide a dataset into distinct subsets based on certain criteria
        (2) Equalizing load processing
            >>  When move the data from one Database into another one, 
                the NTILE() can be used to seperate it into several subset,
                and then UNION it again after loading
    ** e.g **   NTILE(2) OVER (ORDER BY Sales DESC)


** NOTE **
    (1) ORDEY BY (Order Clause) is required for all above Rank Functions
    (2) Frame Clasue is NOT allowed to use in all above Rank Functions
    (3) Partition Clause is optional to use in all above Rank Functions


======================================================
===================  Window Value  ===================
======================================================

Aim:    Access values from other rows in the focused column

How to use:  
    - Expression:       Any data type can be used 
    - Partition Clause: All Optional
    - Order Clause:     All Required 
    - Frame Clause:     LEAD() & LAG() are NOT allowed; 
                        FIRST_VALUE() is Optional
                        LAST_VALUE() is Required

>> LEAD(allType_expr, offset, default)
    - Access a value from the Next row 'offset' within a window; if None, then use 'default' value.
    - Parameters:
        allType_expr    >> (required) The column that you foucused 
        offset          >> (optional) Number of rows forward or backward from current row (default = 1) 
        default         >> (optional) Returns default value if next/previous row is not available (default = NULL) 

>> LAG(allType_expr, offset, default)
    - Access a value from the Previous row within a window

---------------------------------------------------------------------------------------

>> FIRST_VALUE(allType_expr)
    - Access a value from the First row within a window

    - Default Setting for Frame:
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

    ** e.g ** FIRST_VALUE(Sales) OVER (ORDER BY Month)

>> LAST_VALUE(allType_expr)
    - Access a value from the Last row within a window

    - Default Setting for Frame:
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

---------------------------------------------------------------------------------------

- Usages - 
    (1) Time series analysis
        The process of analyzing the data to understand patterns, trends, and behaviors over time
        - YoY (Year-over-Year), MoM (Month-over-Month)
    (2) Customer Retention Analysis
        Measure customer's behavior and loyalty to help business build strong relationship with customers
    (3) Comparision Analysis 
        Compare with extreme value (i.e., highest or lowest values)
*/


USE MyDatabase;

-- ======================================================
-- Window Function Basics --
-- ======================================================

/*
    Find the total number of orders in table Orders
    Find the total sales of all order   
    Find the average sales of all orders
    Find the highest sales of all orders    
    Find the lowest sales of all orders    */
SELECT 
    COUNT(*)                AS total_nr_orders,
    SUM(Sales)              AS total_sales,
    AVG(COALESCE(Sales, 0)) AS avg_sales,
    MAX(Sales)              AS max_sales,
    MIN(Sales)              AS min_sales
FROM Orders;


-- Find the previous information for each customer
SELECT 
    customer_id,
    COUNT(*)                AS total_nr_orders,
    SUM(Sales)              AS total_sales,
    AVG(COALESCE(Sales, 0)) AS avg_sales,
    MAX(Sales)              AS max_sales,
    MIN(Sales)              AS min_sales
FROM Orders
GROUP BY customer_id;


USE SalesDB;


/*  Find the total sales across all orders
    Find the total sales for each products    
    Additionally provide details: OrderID, OrderDate (in table Sales.Orders)   */
SELECT 
    ProductID,
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER() AS Total_sales,
    SUM(Sales) OVER(PARTITION BY ProductID) AS Total_sales_by_product
FROM Sales.Orders;


-- Find the total sales for each combination of product and order status (in table Sales.Orders) 
SELECT 
    ProductID,
    OrderID,
    OrderDate,
    Sales,
    OrderStatus,
    SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS Total_sales_prd_orderStatus
FROM Sales.Orders;


-- Rank each order based on their sales from highest to lowest (in table Sales.Orders) 
-- Include OrderID, OrderDate
SELECT 
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER(ORDER BY Sales DESC) AS SaleRank
FROM Sales.Orders;


/* Find the total sales for each order status,
    only for two products 101 and 102 (in table Sales.Orders) */
SELECT 
    OrderID,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSalesByStatus
FROM Sales.Orders
WHERE ProductID in (101, 102);


-- Rank customers based on their total sales
SELECT 
    CustomerID,
    SUM(Sales) AS CustomerSales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS SalesRank
FROM Sales.Orders 
GROUP BY CustomerID;


-- ======================================================
-- Window Aggregate --
-- ======================================================


-- Find the total number of orders (in table Sales.Orders)
SELECT 
    COUNT(OrderID) AS NrOrders
FROM Sales.Orders;


/* Find the total number of orders (in table Sales.Orders)
    Additionally provide details about OrderID, OrderDate   */
SELECT
    OrderID,
    OrderDate,
    COUNT(OrderID) OVER() AS NrOrders
FROM Sales.Orders;


/* Find the total number of orders for each customers (in table Sales.Orders)
    Additionally provide details about OrderID, OrderDate   */
SELECT
    OrderID,
    OrderDate,
    CustomerID,
    COUNT(OrderID) OVER(PARTITION BY CustomerID) AS NrOrdersByCustomer
FROM Sales.Orders;


/* Find the total number of Customers
    Find the total number of scores for the customers
    Additionally provide all customers details (in table Sales.Customers) */
SELECT 
    *,
    COUNT(CustomerID) OVER() AS NrCustomers,
    COUNT(Score) OVER() AS NrScores
FROM Sales.Customers;


/* Check whether table 'Sales.OrdersArchive' contains any duplicate rows
    >> Check the total number of OrderID of each one
    Then filter out the duplicate OrderID */

SELECT *
FROM
    (SELECT 
        OrderID,
        COUNT(OrderID) OVER(PARTITION BY OrderID) AS CheckPY
    FROM Sales.OrdersArchive)t 
WHERE CheckPY > 1;


/* Find the total sales across all orders (in table Sales.Orders)
    and the total sales for each product.
    Also provide details such as OrderID and OrderDate */
SELECT 
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER() AS TotalSales,
    SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders;


-- Find the percentage contribution of each product's sales to the total sales
SELECT 
    OrderID,
    Sales,
    SUM(Sales) OVER() AS TotalSales,
    CONCAT(ROUND(CAST(Sales AS FLOAT)/ SUM(Sales) OVER() * 100, 2), '%') AS PercentOfTotal
FROM Sales.Orders;


/* Find all orders where sales are higher than the average sales across all orders 
    (regard NULLs as 0) */
SELECT *
FROM 
    (SELECT 
        OrderID,
        Sales,
        AVG(COALESCE(Sales, 0)) OVER() AS AvgSales
    FROM Sales.Orders)t 
WHERE Sales > AvgSales;


-- Find the deviation of each sales from the minimum and maximum sales amount (in table Sales.Orders)
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MIN(COALESCE(Sales, 0)) OVER() AS MinSales,
    MAX(COALESCE(Sales, 0)) OVER() AS MaxSales,
    Sales - MIN(COALESCE(Sales, 0)) OVER() AS DeviationFromMin,
    MAX(COALESCE(Sales, 0)) OVER() - Sales AS DeviationFromMax
FROM Sales.Orders;


/* (1) Calculate the moving average of sales for each product over time (in table Sales.Orders)
    (2) Calculate the moving average of sales for each product over time, including only the next order */
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MovingAvg,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
                    ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAvg
FROM Sales.Orders;



-- ======================================================
-- Window Ranking --
-- ======================================================


/* Rank the orders based on their sales from highest to lowest (in table Sales.Orders): 
    (1) SaleRank_Row:   No same rank
    (2) SaleRank_Rank:  Same rank for same sales; Allow gaps if there are same sales
    (3) SaleRank_Dense: Same rank for same sales; No gaps in the ranking
*/
SELECT
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SaleRank_Row,
    RANK() OVER(ORDER BY Sales DESC) AS SaleRank_Rank,
    DENSE_RANK() OVER(ORDER BY Sales DESC) AS SaleRank_Dense
FROM Sales.Orders;


-- Find the top highest sales for each product (in table Sales.Orders)
SELECT *
FROM
    (SELECT
        OrderID,
        ProductID,
        Sales,
        RANK() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS RankByProduct
    FROM Sales.Orders)t 
WHERE RankByProduct = 1;


-- Find the lowest 2 customers based on their total sales (in table Sales.Orders)
SELECT *
FROM
    (SELECT 
        CustomerID,
        SUM(Sales) AS TotalSalesByProduct,
        RANK() OVER(Order BY SUM(Sales) ASC) AS Rank
    FROM Sales.Orders
    GROUP BY CustomerID)t 
WHERE Rank <= 2; 


-- Assign unique IDs to the rows in the table Sales.OrdersArchive
SELECT 
    ROW_NUMBER() OVER(ORDER BY OrderID) AS UniqueID,
    *
FROM Sales.OrdersArchive;


/* Identify duplicate rows in the table Sales.OrdersArchive
    and return a clean result without any duplicates 
    (If any duplicates, use the latest one) */
SELECT *
FROM 
    (SELECT
        ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS NrDupilate,
        *
    FROM Sales.OrdersArchive)t 
WHERE NrDupilate = 1;


/* Divide the orders in the table Sales.Orders into
    OneBucket, TwoBucket, ThreeBucket, FourBucket Separately
    a.c.t Sales DESC */
SELECT
    OrderID,
    Sales,
    NTILE(1) OVER(ORDER BY Sales DESC) AS OneBucket,
    NTILE(2) OVER(ORDER BY Sales DESC) AS TwoBucket,
    NTILE(3) OVER(ORDER BY Sales DESC) AS ThreeBucket,
    NTILE(4) OVER(ORDER BY Sales DESC) AS FourBucket
FROM Sales.Orders; 


-- Segment all orders into 3 categories: high, medium, low sales
SELECT 
    OrderID,
    CustomerID,
    Sales,
    -- NTILE(3) OVER (ORDER BY Sales DESC) AS ThreeBucket,
    CASE NTILE(3) OVER (ORDER BY Sales DESC)
        WHEN 1 THEN 'High'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'LOW'
    END AS SaleCategory
FROM Sales.Orders;


-- Find the products that fall within the top 40% considering the prices 
SELECT *
FROM
    (SELECT
        *,
        CUME_DIST() OVER(ORDER BY Price DESC) AS PriceDist
    FROM Sales.products)t 
WHERE PriceDist <= 0.4



-- ======================================================
-- Window Value --
-- ======================================================

/* Analyze the month-over-month (MoM) performance
    By finding the percentage change in sales
    between the current and previous month */
SELECT 
    *,
    CurrentMonthSales - PreviousMonthSales AS MoM_Change,
    ROUND((CAST(CurrentMonthSales AS FLOAT) - PreviousMonthSales) / PreviousMonthSales * 100
            , 1) AS MoM_Percant
FROM
    (SELECT
        Month(OrderDate) AS OrderMonth,
        SUM(Sales) AS CurrentMonthSales,
        LAG(SUM(Sales)) OVER (ORDER BY Month(OrderDate)) AS PreviousMonthSales
    FROM Sales.Orders
    GROUP BY Month(OrderDate))t;


/* Analyze customer loyalty by ranking customers based on the average number of days between orders */
SELECT 
    CustomerID
    , OrderDate
    , LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrderDate
    , DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS OrderDayGap 
FROM Sales.Orders; -- First Step to get OrderDayGap for each order grouping by customers 

SELECT
    CustomerID
    , AVG(OrderDayGap) AS CustomerOrderGapDay
    , Rank() OVER(ORDER BY COALESCE(AVG(OrderDayGap), 99999)) AS LoyaltyRank
FROM
    (SELECT 
        CustomerID
        ,OrderDate
        ,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrderDate
        ,DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS OrderDayGap
    FROM Sales.Orders)t -- Get the OrderDayGap for each order
GROUP BY CustomerID;


/* Find the lowest and highest sales for each product (in table Sales.Orders)
    Find the difference in sales between the current and the lowest & highest sales */
SELECT 
    OrderID
    , ProductID
    , Sales
    , MAX(Sales) OVER(PARTITION BY ProductID)                               AS MaxSalesByProduct
    , MIN(Sales) OVER(PARTITION BY ProductID)                               AS MinSalesByProduct
    , FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC)   AS MaxSalesByProduct2
    , FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ASC)    AS MinSalesByProduct2
    , Sales - MIN(Sales) OVER(PARTITION BY ProductID)                       AS DiffWithMin
    , MAX(Sales) OVER(PARTITION BY ProductID) - Sales                       AS DiffWithMax
FROM Sales.Orders;
