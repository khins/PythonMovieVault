CREATE PROCEDURE sp_GetTopMoviesByGenreAndYear
    @GenreName VARCHAR(50),
    @StartYear SMALLINT,
    @EndYear SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        m.title,
        m.year,
        m.rating,
        g.name AS genre,
        m.revenue_generated
    FROM Movies m
    INNER JOIN Genres g
        ON m.genre_id = g.genre_id
    WHERE g.name = @GenreName
      AND m.year BETWEEN @StartYear AND @EndYear
      AND m.rating IN (4, 5)
    ORDER BY m.rating DESC, m.year DESC;
END;
GO

EXEC sp_GetTopMoviesByGenreAndYear 'Sci-Fi', 1990, 2015;