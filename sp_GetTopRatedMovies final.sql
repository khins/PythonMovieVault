--drop sp_GetTopRatedMovies

-- 1. Create the Stored Procedure
CREATE PROCEDURE sp_GetTopRatedMovies
AS
BEGIN
    -- This query selects the specific columns requested
    SELECT 
        title, 
        year, 
        rating, 
        revenue_generated
    FROM Movies
    WHERE rating IN (4, 5) -- Only include ratings of 4 or 5
    ORDER BY rating DESC;   -- Optional: Sort by rating to see the 5s first
END;
GO

-- 2. Execute the procedure to test it
EXEC sp_GetTopRatedMovies;