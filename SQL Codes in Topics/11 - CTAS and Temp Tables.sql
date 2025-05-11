/*
=========================================================================
This is the documentation of learning journey of 'CTAS & Temp Tables' 
=========================================================================

< Used Database >:  
    (1) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql

< Table Types >
    (1) Permanent Table
        >> 2 Ways to Create:
            - CREATE / INSERT
            - CTAS (Create table as select)

    (2) Temporary Table
        > Stores intermediate results in temporary storage within the database during the session
        > The database will drop all temporary tables once the Session ends

< CREATE / INSERT vs CTAS >
    CREATE / INSERT:
        - Step 1: You need to use CREATE to define the structure of table (a empty table)
        - Step 2: You use INSERT to insert data into the table

    CTAS: 
        - Create a new table directly based on the result of an SQL query
        > Always need a database table in order to execute the query

< CTAS vs VIEWS >
    VIEWS:
        - The query if view has not yet been executed 
        - No data is stored; tiny memory is needed
        - Every time you use VIEWS, the codes in VIEW will be executed to reach the lateset database
            - Querying views is slower than querying CTAS tables
            - When there is update in the original database, you always can obtain fresh data by using VIEWS 

    CTAS:
        - The query of CTAS has been executed already (data is prepared already)
        - Result of query is stored already; Certain Memory is needed to store the table
        - Every time you use CTAS, the data in CTAS can be used directly
            - When there is update in the original database, you cannot get fresh data directly
            - You need to re-execute the CTAS query to get updated
            - Therefore, the table from CTAS is harder to maintain (than VIEWS)


< Use Cases of CTAS >
    (1) When the VIEWS query takes long time to run, then it's not resonalbe to keep it as VIEWS.

        Because all the users need to take same long time to wait to get the results.
        Therefore, change the VIEWS into CTAS, which means the time-consuming VIEWS query only needed to be run 
            from one side. Once it's done, other users can use it and save a lot of time.

    (2) Create a Snapshot

        Create a persistent snapshot of data at specific time in order to analy
        When you want to analyze where data quality issue happened, however, the data in original database is keeping
            changing, casuing it's hard to find the issue.
        Therefore, by creating a fixed persisted snapshot of the data in another separate table using CTAS, you can
            do analysis on the same data.

    (3) Make Phycial Data Mart

        Persisting the Data Marts of a DWH improves the speed of data retrival compared to using VIEWS


< Use Cases of Temporary Table >
    During prepare high-quality data into DWH from source database:
        After Extraction, during the Transformation, you will get a lot of Intermediate Results. 
        If those Intermediate Results are not that important, then there is no need to keep them as Permanent tables.
        Therefore, the Intermediate tables can be stored as Temporary Tables, which will be automaticly cleanup when the session ends.
    
    -- Note --
        However, when the debug is needed, the Temporary Tables are not so friendly.
        You can use VIEWS or CTE or CTAS to meet your requirements.

-------------------------------------------------------------------------------------

< Subquery vs CTE vs VIEW vs CTAS vs Temp >

                    Subquery            CTE               TMP                 CTAS            VIEW
    Storage Type    [-------- Memory (Cache)--------]     [------------ Disk ----------]      No Storage
    Life Time       [--------------------- Temporary --------------------]    [--- Permanent(If no Drop) --]
    When Delete     [--------- End of Query --------]     End of Session      [-------- DDL - DROP --------]
    Access Scope    [--------- Single Query --------]     [----------------- Multi Queires ----------------]
    Reusability     [------------ Limit ------------]     [--- Medium ---]    [----------- High -----------]
                    1 place in          Multi places in    Multi Queries               Multi Queries
                       1 query             1 query         during session              Multi sessions
    Up-to-Date      [------------- Yes -------------]     [------------ No ------------]       Yes

=== Preference ===
  VIEW
> CTE (no more than 5 in one query)
> Subquery
> CTAS (When VIEWS are slow)
> TMP



=================== Create CTAS  =================== 

=== Codes === MySQL | Postgres | Oracle ===
CREATE TABLE TableName AS 
(
    SELECT ...
    FROM ...
    WHERE ...
)

=== Codes === SQL Server === 
SELECT ...
INTO TableName
FROM ...
WHERE ...


=================== Drop CTAS  =================== 
- Same as droping any tables
=== Codes ===
DROP TABLE TableName


=================== Refresh CTAS  =================== 

=== Codes ===
IF OBJECT_ID('TableName', 'U') IS NOT NULL
    DROP TABLE TableName
GO 
SELECT ...
INTO TableName
FROM ...
WHERE ...

    - Notes: 'U': user-defined table


=================== Temporary Table  =================== 

=== Codes === SQL Server === 
SELECT ...
INTO #TableName
FROM ...
WHERE ...

== Use Temporary Table ==
SELECT ...
FROM #TableName


*/


/* Create a table by CTAS that show the toal number of orders for each month */
SELECT 
    DATETRUNC(month, OrderDate) AS OrderMonth
    , COUNT(OrderID) AS NrOrders
INTO Sales.TB_Monthly_NrOrders
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate);

SELECT * 
FROM Sales.TB_Monthly_NrOrders;
