CREATE PROCEDURE sp_GetTopRatedMovies
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        title,
        year,
        rating,
        revenue_generated
    FROM Movies
    WHERE rating IN (4, 5)
    ORDER BY rating DESC, year DESC;
END;
GO

EXEC sp_GetTopRatedMovies;