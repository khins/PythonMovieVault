--Table Variables

--A Table Variable is a lightweight, private alternative to a temporary table. It allows you to 
--store a small result set in memory for quick processing within a single "batch" of code. Think
--of it as a standard variable (like an integer or a string), but one that holds an entire table 
--instead of a single value.

--How to Use Them
--The process follows the same logical flow as other temporary storage methods:

--Declare: Define the table name and its columns.

--Insert: Fill it with data (often filtered from a larger table like Movies or Directors).

--Query/Join: Use it in your final SELECT statement or join it to other tables.

-- 1. Declare the table variable with your specific columns
DECLARE @SelectedDirectors TABLE (
    ID INT,
    DirectorName VARCHAR(100),
    TargetMovieID INT
);

-- 2. Populate the variable from your [dbo].[Directors] table
-- Let's say we only want directors associated with movies 1 through 50
INSERT INTO @SelectedDirectors (ID, DirectorName, TargetMovieID)
SELECT director_id, name, movie_id
FROM [dbo].[Directors]
WHERE movie_id BETWEEN 1 AND 50;

-- 3. Use the table variable in a JOIN
-- This keeps your final query focused only on that small subset
SELECT 
    sd.DirectorName, 
    m.title AS MovieTitle,
    m.rating
FROM @SelectedDirectors sd
JOIN Movies m ON sd.TargetMovieID = m.movie_id
ORDER BY sd.DirectorName;

-- Note: No DROP TABLE is needed. 
-- As soon as this batch finishes, @SelectedDirectors is deleted.