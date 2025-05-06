/*
=========================================================================
This is the documentation of learning journey of 'Functions - Single-Row' 
=========================================================================

< Used Database >:  
    (1) MyDatabase
        >> File Path: datasets/init-sqlserver-mydatabase.sql
    (2) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql

< Function >:
    A built-in SQL code: 
        (1) accepts an input value
        (2) process it
        (3) returns an output value

    >> Topic 1: Single-Row Functions    (Input is a single value)
        - String Functions
        - Number Functions
        - Date & Time Functions
        - NULL Functions
        - Case Functions

    >> Topic 2: Multi-Row Functions     (Inputs are multiple values)  
        - Aggregate
        - Window

< Note >:
    (1) Usually, the usage of Single-Row Functions is to prepare data for the Multi-Row Functions

-----------------------------------------------------------------------------------

======================================================
=================  String Functions  =================
======================================================

>> Manipulation
    - CONCAT:   Combine multiple strings into one
        **[e.g]** CONCAT(col_name_1, '-', col_name_2)

    - UPPER:    Combine all characters to uppercase

    - LOWER:    Combine all characters to lowercase

    - TRIM:     Remove empty spaces at the start & end of strings

    - REPLACE:  Replace a specific character with a new character; 
                Also could be used to remove sth by replaced by ''
        **[e.g]** REPLACE(string, old_value, new_value)

>> Calculation
    - LEN:      Count how many characters

>> String Extraction
    - LEFT:     Extract specific number of characters from the Start
        **[e.g]** LEFT(value, nr_of_character)

    - RIGHT:    Extract specific number of characters from the End
        **[e.g]** RIGHT(value, nr_of_character)

    - SUBSTRING:Extract a part of string at a specified position
        **[e.g]** SUBSTRING(value, start_postion, length)
        ** Notion ** 
            (1) 'start_postion' counts from 1;
            (2) SUBSTRING(value, 3, 4) would get 3rd & 4th characters
            (3) Coule use LEN function to get variable length of substring



======================================================
=================  Number Functions  =================
======================================================

>> ROUND:   Round decimals & keep fixed number of digits
    **[e.g]** ROUND(value, nr_dicimals_to_left)
    **[e.g]** ROUND(3.516, 2)   >> 3.520
    **[e.g]** ROUND(3.516, 1)   >> 3.500
    **[e.g]** ROUND(3.516, 0)   >> 4.000

>> ABS:     Return the absolute value of a number
    **[e.g]** ABS(value)
    **[e.g]** ABS(-10)  >> -10
    **[e.g]** ABS(10)   >> 10



=============================================================
=================  Date and Time Functions  =================
=============================================================

>> 3 Types of data
    (1) DATE:       Year - Month - Day
    (2) TIME:       Hours - Minutes - Seconds
    (3) Datetime2 / Datetime:   DATE + TIME
    
    === Notion ===
        (1) Naming difference: In Oracle, Postgres, MySQL: it's called Timestamp; 
                                In SQL server: it's called DateTime
        (2) Difference between Datetime2 & Datetime:
            `DATETIME2` is a newer, more precise version of `DATETIME` in SQL Server. 
            It supports higher fractional seconds precision (up to 7 digits), 
            a wider date range (year 0001–9999), and uses storage more efficiently. 
            Use `DATETIME2` for better accuracy and future-proofing.

>> 3 Sources to query dates
    (1) Date column from a table
    (2) Hardcoded constant string value
    (3) From function: GETDATE()

>> 4 Types of Date Manupalation
    (1) Part Extraction
    (2) Format & Casting
    (3) Calculation
    (4) Validation

--------------------------------------------------------

>> GETDATE():     Returns current 'Date & Time' at the momnent when the quary is executed

>> Part Extraction
    - DAY:      Return the Day(INT) from a date
    - MONTH:    Return the Month(INT) from a date
    - YEAR:     Return the Year(INT) from a date
        **[e.g]** YEAR(date), MONTH(date), DAY(date)

    - DATEPART: Return a specific part of a date as a number(INT) (e.g., week, quarter)
        **[e.g]** DATEPART(desired_part, given_date)
        **[e.g]** desired_part: 
            year, month / mm, day, hour, quarter, weekday, week

    - DATENAME: Return the Name of a specific part of a date (String)
        **[e.g]**   DATENAME(desired_part, given_date)
        **[e.g]**   desired_part: month, weekday; quarter, day, week
        ** Notion ** 
            (1) year, day, quarter, and week can also be used in DATENAME, however, the data type would be String

    - DATETRUNC:Keep the date to the specific part & reset the following part as 0
                i.e., Drop the too detailed information (from high-level to low-level)
        **[e.g]**   DATETRUNC(desired_part, given_date)
        **[e.g]**   DATETRUNC('2025-08-20 18:55:45', minute)  >> '2025-08-20 18:55:00'
        **[e.g]**   DATETRUNC('2025-08-20 18:55:45', hour)    >> '2025-08-20 18:00:00'
        **[e.g]**   DATETRUNC('2025-08-20 18:55:45', day)     >> '2025-08-20 00:00:00'
        **[e.g]**   DATETRUNC('2025-08-20 18:55:45', month)   >> '2025-08-01 00:00:00'
        **[e.g]**   DATETRUNC('2025-08-20 18:55:45', year)    >> '2025-01-01 00:00:00'
        ** Why it's useful ? **
            Can group by the rows quickly based on any level 

    - EOMONTH:  Return the end day of the month (output data type: DATE)
        **[e.g]** EOMONTH(given_date)
        **[e.g]** EOMONTH('2025-02-01') >> '2025-02-28'
        **[e.g]** EOMONTH('2025-03-31') >> '2025-03-31'
    
    === Notion ===
        (1) The outputs of following Functions are INT:
            YEAR, MONTH, DAY, DATEPART
        (2) The outputs of following Functions are STRING:
            DATENAME
        (3) The outputs of following Functions are DATETIME:
            DATETRUNC
        (4) The outputs of following Functions are DATE:
            EOMONTH


>> Format & Casting

    - FORMAT:   Format a date or time value (change how data looks)
        **[e.g]** FORMAT(value, format [, culture])
        **[e.g]** FORMAT(given_date, 'dd/MM/yyyy')
        **[e.g]** FORMAT('2025-01-10', 'dd')    >> 10
        **[e.g]** FORMAT('2025-01-10', 'ddd')   >> Fri
        **[e.g]** FORMAT('2025-01-10', 'dddd')  >> Friday
        **[e.g]** FORMAT('2025-01-10', 'yy')    >> 25
        **[e.g]** FORMAT('2025-08-20 18:55:45', 'tt')   >> PM

    - CONVERT: Convert a date or time value to a different data type & Format the value by [,style]
        **[e.g]** CONVERT(data_type, value [,style])
        **[e.g]** CONVERT(INT, '124')
        **[e.g]** CONVERT(VARCHAR, given_date, 32) AS [USA Std.]
        **[e.g]** CONVERT(VARCHAR, given_date, 34) AS [EURO Std.]
        **[e.g]** CONVERT(VARCHAR, given_date, 23) AS [International Std.]

    - CAST:  Change the data type 
        **[e.g]**  CAST(value AS data_type)
        **[e.g]**  CAST('123' AS INT)
        **[e.g]**  CAST('2025-08-20' AS DATE)

    === Notion ===  
        (1) Date Time Format: yyyy-MM-dd HH:mm:ss
            Adopted from International Standard (ISO 8601)
            There are other standards: USA: [MM-dd-yyyy]; European: [dd-MM-yyyy]

        (2) Default setting of optional parameters
            -> default of [, culture]:  'en-US'
            -> default of [,style]:     0

        (3) The data type of the output of FORMAT can only be String
    
    === Usage Summary ===
        Casting:    CAST & CONVERT: Any type to Any type
                    FORMAT:         Any type to only string
        Formating:  CAST:           Cannot
                    CONVERT:        Only Date + Time
                    FORMAT:         Both Date + Time & Numbers

>> Calculation
    - DATEADD:  Add or Substract a specific time interval to/from a date
        **[e.g]**   DATEADD(part_to_change, interval, date)
        **[e.g]**   DATEADD(year, 2, '2025-08-01')      >> '2027-08-01'
        **[e.g]**   DATEADD(month, -4, '2025-08-01')    >> '2025-04-01'
        **[e.g]**   DATEADD(day, 1, '2025-08-01')    >> '2025-08-02'

    - DATEDIFF: Find difference between 2 dates
        **[e.g]**   DATEDIFF(part_focused, start_date, end_date)
        **[e.g]**   DATEDIFF(year, '2025-08-20', '2026-02-01')  >> 1
        **[e.g]**   DATEDIFF(month, '2025-08-20', '2026-02-01') >> 6

>> Validation
    - ISDATE:   Check if a value is a date (International Standard Format OR Year)
                Return 1 for Yes & 0 for No
        **[e.g]**   ISDATE(value)
        **[e.g]**   ISDATE('2025-08-20')    >> 1
        **[e.g]**   ISDATE('20-08-2025')    >> 0
        **[e.g]**   ISDATE('2025')          >> 1
        **[e.g]**   ISDATE('08')            >> 0
            


====================================================
=================  NULL Functions  =================
====================================================

>> Insert data into NULL
    - ISNULL:   Replace 'NULL' with a specificed value
        **[e.g]**   ISNULL(value_to_check, value_to_replace_NULLs)
        **[e.g]**   ISNULL(ShippingAddress, 'N/A')
        **[e.g]**   ISNULL(ShippingAddress, BillingAddress)

    - COALESCE: Return the first non-null value from a list
        **[e.g]**   COALESCE(value_1, value_2, value_3, ...)

    === Notion ===
        (1) Naming Difference:
            ISNULL -> SQL Server; NVL -> Oracle; IFNULL -> MySQL
            However, COALESCE is same for all SQL languages
        (2) Running Speed differece: ISNULL is faster than COALESCE
        (3) Suggestions: If COALESCE won't lead to much worse performance, 
                        using COALESCE can keep codes consistent
    
    === Usage ===
        (1) Handle NULL before doing data aggregations
            - Use NULL or other specific value could affect the results of following functions: 
                AVG(), SUM(), MIN(), MAX(), COUNT(col_name)
                ** Note: Won't affect CONUT(*) as it consider rows instead of values

        (2) Handle NULL before doing mathmatical operations
            - NULL + 5      => NULL
            - NULL + 'B'    => NULL

        (3) Handle NULL before doing JOINS
            - What if NULLs are inside keys?
                Then Equal operator cannot able to join tables in case of NULL
                Thus, lose more information.
            - So, how to handle NULL insides keys?
                ISNULL(table_name_1.col_name_1, '') = ISNULL(table_name_2.col_name_2, '')

        (4) Handle NULL before sorting data
            - NULL will be regarded as lowest value in default


>> Replace data with NULL

    - NULLIF:   Compare two expressions, returns
        (1) If they are equal       >>  NULL, 
        (2) if they are not equal   >>  First value
        **[e.g]**   NULLIF(value_1, value_2)
        **[e.g]**   NULLIF(Price, -1)

    === Usage ===
        (1) Prevent the error of dividing by 0


>> Check whether it's NULL or not

    - IS NULL:      Return TRUE if the value is NULL; otherwise, FALSE
        **[e.g]**   value IS NULL

    - IS NOT NULL:  Return TRUE if the value is not NULL; otherwise, FALSE
        **[e.g]**   value IS NOT NULL
    
    === Usage ===
        (1) Filter data that have missing info OR non-missing info
        (2) Do right/left anti JOIN: find the unmatched rows between two tables
            LEFT ANTI JOIN: All rows from the left table without matches in the right


** Notion **
    (1) Difference between NULL, Empty string, Blank spaces
                                NULL                Empty string                Blank spaces
        Representation      NULL                    ''                          ' '
        Meaning             Unknown                 Known, Empty value          Known, it's space value
        Data Type           Special Marker          String (with size 0)        String (with size >=1)
        Storage             Very minimal            use memory                  use memory for each space
        Peformance          Best                    Fast                        Slow
        Comparison          IS NULL                 = ''                        = ' '
        DATALENGTH()        NULL                    0                           >= 1
    
    (2) Use Data Policy to bring standards

        Policy 1: Trim the blank spaces in the begining & end
        Policy 2: Replace empty strings & blanks with NULL
        Policy 3: Use the default value 'unknown' for all NULLs, empty strings, and blank spaces

        Advantages of Policy 2: Druing data preparation in ETL, Optimize storages & performance
        Advantages of Policy 3: If it would be used just before reporting, it could improve readibility & reduce confusion 



====================================================
=================  Case Functions  =================
====================================================

- Aim:  Evaluates a list of conditions and returns the value associated with the first condition that is met.

- Full Format:
    ================ CODE ================
    CASE 
        WHEN condition_1 THEN result_1 
        WHEN condition_2 THEN result_2
        ... 
        ELSE result
    END
    ================ CODE ================

- Quick Format:
    ================ CODE ================
    CASE Col_name
        WHEN Col_value_1 THEN result_1 
        WHEN Col_value_2 THEN result_2
        ... 
        ELSE result
    END
    ================ CODE ================

- Usage: 
    (1) Data Transformation
    (2) Categorizing Data
    (3) Conditional aggregation: Apply aggregation functions only when subset of data fulfill certain conditions

** Notion **
    (1) The data type of results from each condtion should be same

*/

USE MyDatabase;

-- ======================================================
-- String Function --
-- ======================================================


/* Concatenate first name and country into one column
  Show a list of customers' first names together with their country in one column */
SELECT
    first_name,
    country,
    CONCAT(first_name, '-', country) AS name_country
FROM customers;


-- Convert the first name to lowercase
SELECT
    LOWER(first_name) AS low_name
FROM customers;


-- Find customers whose first name contains leading or trailing spaces
SELECT *
FROM customers
WHERE TRIM(first_name) != first_name;


/* Replace file extence from txt to csv
  old_filename is 'report.txt', and the new one would be '.csv' */
SELECT
    'report.txt' AS old_filename,
    REPLACE('report.txt', '.txt', '.csv') AS new_filename;


-- Calculate the length of each customer's first name
SELECT
    TRIM(first_name) AS first_name,
    LEN(TRIM(first_name)) AS len_name
FROM customers;


-- Retrieve the first & last 2 characters of each first name
SELECT
    TRIM(first_name) AS first_name,
    LEFT(TRIM(first_name), 2) AS first_2_char_name,
    RIGHT(TRIM(first_name), 2) AS last_2_char_name
FROM customers;


-- Retrieve a list of customer's first names after removing the first character
SELECT
    TRIM(first_name) AS first_name_trim,
    SUBSTRING(TRIM(first_name), 2, LEN(TRIM(first_name))) AS after_1_chara
FROM customers;



-- ======================================================
-- Date and Time Function --
-- ======================================================

USE SalesDB;

-- Get the Year & Month & Day of CreationTime in table Sales.Orders

-- == Option 1 ==
SELECT
    OrderID,
    CreationTime,
    YEAR(CreationTime) AS 'Year',
    MONTH(CreationTime) AS 'Month',
    DAY(CreationTime) AS 'Day'
FROM Sales.Orders;

-- == Option 2 ==
SELECT
    OrderID,
    CreationTime,
    DATEPART(year, CreationTime) AS 'Year',
    DATEPART(month, CreationTime) AS 'Month',
    DATEPART(day, CreationTime) AS 'Day'
FROM Sales.Orders;


-- Get the Quarter & Weekday & Week as Numbers of CreationTime in table Sales.Orders
SELECT
    OrderID,
    CreationTime,
    DATEPART(quarter, CreationTime) AS 'Quarter',
    DATEPART(weekday, CreationTime) AS 'Weekday',
    DATEPART(week, CreationTime) AS 'Week'
FROM Sales.Orders;


-- Get the Month & Weekday as Names of CreationTime in table Sales.Orders
SELECT
    OrderID,
    CreationTime,
    DATENAME(month, CreationTime) AS 'Month',
    DATENAME(weekday, CreationTime) AS 'Weekday'
FROM Sales.Orders;


-- Get the number of orders based on each month a.c.t CreationTime
SELECT
    DATETRUNC(month, CreationTime) AS creation_month,
    COUNT(*) AS Nr_Order
FROM Sales.Orders
GROUP BY DATETRUNC(month, CreationTime);


-- Get the first date and the end date of the month in CreationTime
SELECT
    OrderID,
    CreationTime,
    CAST(DATETRUNC(month, CreationTime) AS DATE) AS first_date_month,
    EOMONTH(CreationTime) AS end_date_month
FROM Sales.Orders;


-- How many orders were placed in each year in Sales.Orders
SELECT
    YEAR(OrderDate) AS 'Year',
    COUNT(*) AS Nr_Orders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);


-- How many orders were placed in each month in Sales.Orders
SELECT
    DATENAME(month, OrderDate) AS 'Month',
    COUNT(*) AS Nr_Orders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);


-- == Filter Data ==
-- Show all orders that were placed during the month of february
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;


-- Get the day of CreationTime in both number and characters (Abbr. & full name)
SELECT
    OrderID,
    CreationTime,
    FORMAT(CreationTime, 'dd') AS day_nr,
    FORMAT(CreationTime, 'ddd') AS day_abb,
    FORMAT(CreationTime, 'dddd') AS day_full
FROM Sales.Orders


-- Show CreationTime using the following format: Day Wed Jan Q1 2025 12:34:56 PM
SELECT
    OrderID,
    CreationTime,
    'Day ' + FORMAT(CreationTime, 'ddd MMM Q') + 
        DATENAME(QUARTER, CreationTime) + 
        FORMAT(CreationTime, ' yyyy HH:mm:ss tt') AS Custom_Format
FROM Sales.Orders;


--  Get the DATE ('yyyy-MM-dd') of CreationTime
SELECT
    OrderID,
    CONVERT(DATE, CreationTime) AS [Date_convert],
    FORMAT(CreationTime, 'yyyy-MM-dd') AS [Date_format],
    CONVERT(DATE, CreationTime, 23) AS [Date_convert]
FROM Sales.Orders;


-- Calculate the age of employees in the table Sales.Employees
SELECT
    EmployeeID,
    BirthDate,
    DATEDIFF(year, BirthDate, GETDATE()) AS Age
FROM Sales.Employees;


-- Find the average shipping duration in days for each month (in table Sales.Orders)
SELECT
    DATENAME(month, OrderDate) AS Order_Month,
    AVG(DATEDIFF(day, OrderDate, ShipDate)) AS Avg_ship_days
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);



-- ======================================================
-- NULL Function --
-- ======================================================

-- Find the average scores of the customers in table Sales.Customers (1) ignore NULL (2) regard NULL as 0
/* OVER () 
    -- is part of window functions. 
    -- It tells the database to perform the calculation across the entire table without grouping the rows. */
SELECT
    Score,
    COALESCE(Score, 0) AS Score2,
    AVG(Score) OVER () AS AvgScore,
    AVG(COALESCE(Score, 0)) OVER () AS AvgScore2
FROM Sales.Customers;


-- Display the full name of customers in a single field by merging their first & last name in table Sales.Customers
-- and add 10 bonus points to each customers' score (include NULL scenario)
SELECT
    CustomerID,
    FirstName,
    LastName,
    TRIM(COALESCE(TRIM(FirstName), '') + ' ' + COALESCE(TRIM(LastName), '')) AS FullName,
    Score,
    COALESCE(Score, 0) + 10 AS Score_with_Bonous
FROM Sales.Customers;


-- Sort the customers (in table Sales.Customers) from lowest to highest scores with NULLs appearing last
-- == Option 1 ==
SELECT
    CustomerID,
    Score
FROM Sales.Customers
ORDER BY COALESCE(Score, MAX(Score) OVER()+1) ASC;

-- == Option 2 ==
SELECT
    CustomerID,
    Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END ASC,
        Score ASC;


-- Find the sales price for each order (in table Sales.Orders)
SELECT
    OrderID,
    Quantity,
    Sales,
    Sales /  NULLIF(Quantity, 0) AS Price
FROM Sales.Orders;


-- Identify the customers who have no scores (in table Sales.Customers)
SELECT *
FROM Sales.Customers
WHERE Score IS NULL;


-- == Left Anti JOIN ==
-- List all details for customers who have not placed any orders
SELECT c.*
FROM Sales.Customers AS c
    LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;


-- == Showing of 3 different data policies == 
/* Bring Standards
Policy 1: Trim the blank spaces in the begining & end
Policy 2: Replace empty strings & blanks with NULL
Policy 3: Use the default value 'unknown' for all NULLs, empty strings, and blank spaces

Advantages of Policy 2: Druing data preparation in ETL, Optimize storages & performance
Advantages of Policy 3: If it would be used just before reporting, it could improve readibility & reduce confusion 
*/
WITH Orders AS (
    SELECT 1 AS ID, 'A' AS Category UNION
    SELECT 2,       NULL            UNION
    SELECT 3,       ''              UNION
    SELECT 4,       ' '            
)
SELECT
    *,
    DATALENGTH(Category)                   AS len_Category,
    TRIM(Category)                         AS Policy_1,
    NULLIF(TRIM(Category), '')             AS Policy_2,
    COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy_3
FROM Orders;



-- ======================================================
-- CASE Function --
-- ======================================================


/* Generate a report showing the total sales for each category (in table Sales.Orders):
    High if the sales higher than 50
    Medium if the sales between 20 and 50 (boundary inclusive)
    Low if the sales equal or lower than 20 
Sort the result from lowest to highest  */

SELECT 
    Category,
    SUM(Sales) AS Total_sales
FROM
    (SELECT 
        OrderID,
        Sales,
        CASE 
            WHEN Sales > 50     THEN 'High'
            WHEN Sales >= 20    THEN 'Medium'
            ELSE                     'Low'
        END AS Category
    FROM Sales.Orders
    )t
GROUP BY Category
ORDER BY SUM(Sales) ASC;


-- Retrive employee details with gender displayed as full text
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    CASE 
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
        ELSE                   'Not Available'
    END AS Gender_full
FROM Sales.Employees;


-- Retrive customers details with abbreviated country code
SELECT DISTINCT Country 
FROM Sales.Customers;

SELECT 
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA'     THEN 'US'
        ELSE                          'n/a'
    END AS CountryAbbr
FROM Sales.Customers;


/* Find the average scores of customers and treat NULLs as 0 (in table Sales.Customers) by using CASE statement
    Addtionally provide details such as CustomerID and LastName */
SELECT 
    CustomerID,
    FirstName,
    LastName,
    Score,
    AVG(
        CASE 
            WHEN Score IS NULL THEN 0
            ELSE Score
        END) OVER () AS Avg_score
FROM Sales.Customers;


/* Conditional aggregation (in table Sales.Orders)
    Count how many times each customers has made an order with sales greater than 30 
    Also count the number of total orders for each customer */
SELECT
    CustomerID,
    SUM(Count_times) AS Total_high_orders,
    COUNT(*) AS Total_orders
FROM
(    SELECT 
        OrderID,
        CustomerID,
        Sales,
        CASE 
            WHEN Sales > 30 THEN 1
            ELSE                 0
        END AS Count_times
    FROM Sales.Orders)t 
GROUP BY CustomerID;

-- Then, the previous codes can be simplified as:
SELECT 
    CustomerID,
    SUM(
        CASE 
            WHEN Sales > 30 THEN 1
            ELSE                 0
        END) AS Total_high_orders,
    COUNT(*) AS Total_orders
FROM Sales.Orders
GROUP BY CustomerID;
