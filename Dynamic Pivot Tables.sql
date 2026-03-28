--Dynamic Pivot Tables
--A Dynamic Pivot Table is the advanced evolution of the standard PIVOT operator. While a regular
--PIVOT requires you to manually list every column header (like [Action], [Comedy]), a Dynamic Pivot 
--uses a script to "read" the database and build those headers automatically. This ensures your reports
--never break or miss data when new categories (like a new movie genre) are added.

--The Core Mechanism
--Building a dynamic pivot involves three distinct phases:

--Column Generation: Using STRING_AGG and QUOTENAME to create a comma-separated string of all 
--unique values (e.g., [Action],[Comedy],[Drama]).

--String Construction: Writing the SQL query as a long text string (NVARCHAR(MAX)), leaving a
--placeholder where the column names should go.

--Execution: Using sp_executesql to turn that text string into a live, runnable command.
-- 1. Declare variables to hold the dynamic parts of our query
DECLARE @Columns NVARCHAR(MAX);
DECLARE @DynamicSQL NVARCHAR(MAX);

-- 2. Automatically get all unique Genre names from your Genres table
-- STRING_AGG joins them with commas, QUOTENAME adds the [brackets]
SELECT @Columns = STRING_AGG(QUOTENAME(name), ',')
FROM Genres;

-- 3. Build the full SQL string
-- We join Movies, Genres, and Directors to get the names for our report
SET @DynamicSQL = N'
SELECT * FROM 
(
    SELECT 
        d.name AS DirectorName, 
        g.name AS GenreName, 
        m.Movie_ID
    FROM Movies m
    JOIN Genres g ON m.genre_id = g.genre_id
    JOIN Directors d ON m.movie_id = d.movie_id -- Using your specific schema
) AS BaseData
PIVOT (
    COUNT(Movie_ID) 
    FOR GenreName IN (' + @Columns + ')
) AS PivotTable
ORDER BY DirectorName;';

-- 4. Execute the constructed string
EXEC sp_executesql @DynamicSQL;