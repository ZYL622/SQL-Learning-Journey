/* 
=========================================================================
This is the documentation of learning journey of 'Stored Procedures & Triggers' 
=========================================================================

< Used Database >:  
    (1) SalesDB
        >> File Path: datasets/init-sqlserver-salesdb.sql

< Explaination >
    Put all SQL statements together in one frame or program, which is called Stored Procedure.
    Once it's done, those SQL statements will be stored in Server side of Database.
    Every time you need to run it, a simple command is needed. 
    Thus, it can minimize human error. 


< Stored Procedure vs Query >
    Query
        - One-time request

    Stored Procedure
        - It's more like a program, which can include more complex stuff like
            Loops, control flow, set parameters, handling error, and etc.

< Stored Procedure vs Coding with Python >
    - You can put all SQL statement in Python Code

    >> Disadvantages of Coding with Python
        - If you have Python in different server, then you have to build a connection between it with database server.
            It could lead to slightly worse performance 
        -  The store procedure in the database are all pre-compiled.
            Thus, there is already a check of codes
            Database cannot complie anything until the Python codes are sent to the database.
    
    >> Advantages of Coding with Python
        - Able to build very flexible Python codes
        - Make great version control
        - Allow complex logic way easier than Stored Procedure

< Suggestions >
    - Don't Build Projects using Stored Procedures if there is possibility to have codes in Python
        > Because Stored Procedures easily end in Chaos: 
            hard to debug, hard to test ... (especially in big projects)
    - Styling is very important when the codes are long...


< Triggers >
    - A special stored procedure (set of statements) that Automatically runs 
        in response to a specific event on a table or view

    >> 3 Trigger Types
        (1) DML Trigger     >> INSERT, UPDATE, DELETE
            - AFTER trigger:        Runs after events
            - INSTEAD OF trigger:   Runs during event
        (2) DDL Trigger     >> CREATE, ALTER, DROP
        (3) LOGGIN

< Trigger Use Case >
    (1) Logging
    

--------------------------------------------------------------------------------

=================== Basics - Definition  =================== 

=== Codes === (Create or Alter if alreay existed)
CREATE/ALTER PROCEDURE ProcedureName AS
BEGIN 

    -- SQL Statements GO Here

END


=================== Basics - Execution (Call)  =================== 
=== Codes ===
EXEC ProcedureName


=================== Basics - Drop =================== 
=== Codes ===
DROP PROCEDURE ProcedureName


=================== Parameters  =================== 

- Placeholders used to pass values as input from the caller to the procedure, 
    allowing dynamic data to be processed.
- Advantages
    Aviod Repeated Codes
        If there are repeated codes in your project, then is a sign that your code can be improved.

=== Codes ===
---------- Create ------------
CREATE PROCEDURE ProcedureName @Parameter DataType [= 'default_value']
AS
BEGIN 
    -- SQL Statements GO Here
END
---------- Execution ------------
EXEC ProcedureName @@Parameter = 'value'


=================== Multiple Statements  =================== 

=== Codes === (Create if IS NULL or Alter if alreay existed)
CREATE/ALTER PROCEDURE ProcedureName AS
BEGIN 

    SELECT ...
    FROM ...
    WHERE ....; (Semicolon here is to help reading)

    SELECT ...
    FROM ...
    WHERE ....;

END


=================== Variables  =================== 

- Placeholders used to store values to be used later in the procedure

< Parameters vs Variables >
    - Parameters pass values into a stored procedure or return values back to the caller
    - Variables temporarily store and manipulate data during its execution

=== Codes === Define New Variavle ===

DECLARE @VariableName1 DataType, @VariableName2 DataType;

SELECT 
    @VariableName1 = ...  (alias not allowed here)
    , @VariableName2 = ...
FROM ...


=================== Control Flow - IF ELSE -  =================== 
- For example, it can be used to Handle NULLs before aggregating to ensure accurate results
    => You need to do a pre-step to do data cleaning, afterwards, you generate the reports

=== Codes ===
IF
BEGIN
END

ELSE
BEGIN
END

=================== Error Handling  =================== 
------------------- - TRY CATCH - -------------------

=== Codes ===
BEGIN TRY
    -- SQL statements that might cause an error
END TRY

BEGIN CATCH
    -- SQL statements to handle the error
    PRINT('Error Message:' +  ERROR_MESSAGE());
    PRINT('Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR));
    PRINT('Error Line:' + CAST(ERROR_LINE() AS NVARCHAR));
    PRINT('Error Procedure:' + ERROR_PROCEDURE());
END CATCH

--------------------------------------------------------------------------------

=================== Triggers =================== 

=== Codes ===
CREATE TRIGGER TriggerName ON TableName
AFTER INSERT[or UPDATE or DELETE] AS -- Define when the trigger should work
BEGIN
    -- SQL Statement GO here
END

*/

USE SalesDB;

/*  Step 1: 
        Find the total number of US customers & their average score 
    Step 2:
        Turning the query into a stored procedure 
    Step 3:
        Execute the stored procedure 
*/
CREATE PROCEDURE P_USA_Customer_Info AS 
BEGIN

SELECT 
    COUNT(CustomerID) AS TotalNrCustomer
    , AVG(COALESCE(Score, 0)) AS AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

END

EXEC P_USA_Customer_Info


/* Tiny change of the previous task: USA -> Germany 
    Besides, Find the total Nr. of Orders and Total Sales 
    Also, Print Total Customer & Average Score  */

ALTER PROCEDURE P_GetCustomerSummary @Country NVARCHAR(50) AS 
BEGIN

DECLARE @TotalCustomer INT, @AvgScore FLOAT;

    SELECT 
        @TotalCustomer = COUNT(CustomerID)
        , @AvgScore = AVG(COALESCE(Score, 0))
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomer AS NVARCHAR);
    PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR);

    SELECT 
        COUNT(OrderID) AS TotalNrOrder
        , SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
    WHERE c.Country = @Country;

END

EXEC P_GetCustomerSummary @Country = 'USA'



-- =================== Control Flow - IF ELSE -  =================== 

ALTER PROCEDURE P_GetCustomerSummary @Country NVARCHAR(50) AS 
BEGIN
    BEGIN TRY
        -- Declare variables
        DECLARE @TotalCustomer INT, @AvgScore FLOAT;

        -- =========================================================
        -- Prepare & Cleanup Data: Convert NULLs in Scores into zero
        -- =========================================================
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL)
        BEGIN
            PRINT('Updating NULLs in Score in Country ' + @Country)
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END

        ELSE
        BEGIN
            PRINT('No NUlls found in Score in Country ' + @Country)
        END;

        -- ================
        -- Gnerate Reports
        -- ================
        SELECT 
            @TotalCustomer = COUNT(CustomerID)
            , @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT ('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomer AS NVARCHAR));
        PRINT ('Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR));

        SELECT 
            COUNT(OrderID) AS TotalNrOrder
            , SUM(Sales) AS TotalSales
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
        ON o.CustomerID = c.CustomerID
        WHERE c.Country = @Country;
    END TRY

    -- ================
    -- Error Handling
    -- ================
    BEGIN CATCH
        PRINT('Error Message:' +  ERROR_MESSAGE());
        PRINT('Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Line:' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure:' + ERROR_PROCEDURE());
    END CATCH
END
GO

EXEC P_GetCustomerSummary @Country = 'USA'


-- =================== Triggers =================== 
/* Maintain and audit logs of table Sales.Employees 
    Task: Every time there is a new insert into this table, 
            then it will trigger an event: the change will be tracked in audit logs.
*/

-- Step 1: Create Log Table
CREATE TABLE Sales.EmployeeLogs (
    LogID INT IDENTITY(1, 1) PRIMARY KEY
    , EmployeeID INT NOT NULL 
    , LogMessage VARCHAR(255)
    , LogDate DATE
);

-- Step 2: Create Trigger on Employees Table
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT AS
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT 
        EmployeeID
        , 'Add new employee = ' + CAST(EmployeeID AS NVARCHAR)
        , GETDATE()
    FROM INSERTED
END

-- Step 3: Insert new employee into Sales.Employees

INSERT INTO Sales.Employees (EmployeeID, FirstName, Department, BirthDate, Gender, ManagerID)
    VALUES (6, 'Maria', 'HR', '1998-09-28', 'F', 3);

-- Check Step: Check the current table Sales.EmployeeLogs
SELECT *
FROM Sales.EmployeeLogs;
