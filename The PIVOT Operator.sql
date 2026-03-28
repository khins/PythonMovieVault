--The PIVOT Operator
--The PIVOT operator in SQL Server is a powerful tool used to rotate data from a row-based 
--orientation into a column-based orientation. Much like a Pivot Table in Excel, it allows 
--you to transform unique values from one column into multiple new columns, aggregating data
--(like counts or sums) to make summaries easier to read side-by-side.

--Vertical vs. Horizontal Data
--Standard GROUP BY: Produces a vertical list (e.g., one row for "Action," one row for "Comedy").
--This is great for data processing but harder to compare at a glance.

--PIVOT: Reshapes that same data horizontally. Categories become headers (e.g., a column for "Action,"
--a column for "Comedy"), which is ideal for high-level reporting.

--How to Build a PIVOT Query
--A PIVOT operation generally requires three parts:

--The Base Data: A subquery or CTE that provides the raw columns (the values to group by,
--the values to aggregate, and the values that will become headers).

--The Aggregate Function: Usually COUNT, SUM, or AVG to populate the new cells.

--The FOR Clause: Defines which column's unique values will turn into the new column headers.
SELECT * FROM 
(
    SELECT genre_id, movie_id FROM Movies -- Base Data
) AS BaseData
PIVOT (
    COUNT(movie_id) 
    FOR genre_id IN ([1], [2], [3]) -- Manually listing Genre IDs
) AS PivotTable;