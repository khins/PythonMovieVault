CREATE FUNCTION dbo.fn_CalculateMovieAge
(
    @ReleaseYear INT
)
RETURNS INT
AS
BEGIN
    DECLARE @CurrentYear INT;
    DECLARE @Age INT;

    -- 1. Get the current year from the system date
    SET @CurrentYear = YEAR(GETDATE());

    -- 2. Calculate the difference
    SET @Age = @CurrentYear - @ReleaseYear;

    -- 3. Return the final number
    RETURN @Age;
END;
GO

--Why use a Function instead of a Stored Procedure here?
--In-Line Use: You can't put a EXEC sp_GetAge inside a SELECT list, but you can put a function there.

--Join Capability: You can use functions to calculate values across joined tables on the fly.

--Clean Code: It keeps your main queries short and readable.

SELECT 
    Title, 
    year, 
    dbo.fn_CalculateMovieAge(year) AS YearsOld
FROM Movies
ORDER BY YearsOld DESC;

SELECT Title, year
FROM Movies
WHERE dbo.fn_CalculateMovieAge(year) BETWEEN 20 AND 30;