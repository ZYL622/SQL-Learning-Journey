# SQL-Learning-Journey

These are the record files of Yulin Zhou's learning journey in SQL.

========================================================================

## What SQL topics you can find here?
<pre>
(1) Query;       (2) Data Definition Language(DDL); (3) Data Manipulation Language(DML); (4) Data Filter
(5) Combination; (6) Single-row Function;           (7) Multi-row Function
</pre>


### (1) Query
<pre>
SELECT, DISTINCT, TOP, FROM, JOIN, WHERE, GROUP BY, HAVING, ORDER BY (follow coding order)
</pre>


### (2) Data Definition Language
<pre>
CREATE, ALTER, DROP
</pre>

<pre>
===== CREATE =====
CREATE TABLE table_name (
  key_col INT NOT NULL,
	col_name_1 VARCHAR(50) NOT NULL,
	col_name_2 DATE,
	col_name_3 VARCHAR(15) NOT NULL,
	CONSTRAINT pk_key_name PRIMARY KEY (key_col)
	);
</pre>

<pre>
===== ALTER & DROP =====
ALTER TABLE table_name
ADD col_name VARCHAR(50) NOT NULL;

ALTER TABLE table_name
DROP COLUMN col_name;

ALTER TABLE table_name
ALTER COLUMN column_name datatype;
</pre>


### (3) Data Manipulation Language
<pre>
INSERT, Update, Delete, Truncate
</pre>

<pre>
===== INSERT =====
INSERT INTO table_name (column1, column2, column3,…)
VALUES (value1, value2, value3,…),
      (value1, value2, value3,…)

INSERT INTO table_name (column1, column2, column3,…)
SELECT * FROM table_name
</pre>

<pre>
===== Update =====
UPDATE table_name
  SET column1 = value1,
    column2 = value2
  WHERE <condition>
</pre>

<pre>
===== Delete =====
DELETE FROM table_name
WHERE <condition>
</pre>

<pre>
===== Truncate =====
TRUNCATE TABLE table_name
</pre>

### (4) Data Filter
<pre>
  Comparison Operators:  =, !=, <>, >, >=, <=, <
  Logical Operators:     AND, OR, NOT
  Range Operators:       BETWEEN
  Membership Operators:  IN, NOT IN
  Search Operators:      LIKE
</pre>            


### (5) Combination
<pre>
- Direct Joins  >> INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN
- Anti Joins    >> Use WHERE table_name.key IS NULL to realize LEFT/RIGHT Anti JOIN
- SET, EXCEPT, INTERSECT
- UNIONs        >> UNION, UNION ALL
</pre>


### (6) Single-row Function
- String Functions
<pre>
  Manipulation  >> CONCAT(), UPPER(), LOWER(), TRIM(), REPLACE()
  Calculation   >> LEN()
  Extraction    >> LEFT(), RIGHT(), SUBSTRING()
</pre>
    
- Number Functions
<pre>
ROUND(), ABS()
</pre>

- Date & Time Functions
<pre>
  GETDATE()
  [Extraction]  >> DAY(), MONTH(), YEAR(), DATEPART(), DATENAME(), DATETRUNC(), EOMONTH()
  [Format]      >> FORMAT(), CONVERT(), CAST()
  [Calculation] >> DATEADD(), DATEDIFF()
  [Validation]  >> ISDATE()
</pre>
    
- NULL Functions
<pre>
  [NULL -> Data]  >> ISNULL(), COALESCE()
  [Data -> NULL]  >> NULLIF()
  [Check NULLs]   >> IS NULL, IS NOT NULL
</pre>
  
- Case Functions
<pre>
  CASE
        WHEN condition_1 THEN result_1 
        WHEN condition_2 THEN result_2
        ... 
        ELSE result
  END 
</pre>

### (7) Multi-row Function

- Window Function
  <pre>
  Aggregation Fun      >> COUNT(), SUM(), AVG(), MAX(), MIN()
  Ranking Fun          >> ROW_NUMBER(), RANK(), DENSE_RANK(), CUME_DIST(), PERCENT_RANK(), NTILE()
  Value/Analytics Fun  >> LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE()
  </pre>

- OVER Clause OVER()
  <pre>
  Partition Clause  >> OVER(PARTITION BY col_name)
  Order Clause      >> OVER(ORDER BY col_name DESC/ASC)
  Frame Clause      >> Frame Types:     ROWS, RANGE
                    >> Frame Boundary:  CURRENT ROW, N PRECEDING / FOLLOWING, UNBOUNDED PRECEDING / FOLLOWING
  </pre>










