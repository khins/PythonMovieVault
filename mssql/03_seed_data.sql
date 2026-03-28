USE MovieVault;
GO

INSERT INTO dbo.Genres (GenreName)
SELECT genre_name
FROM
(
    VALUES
        ('Action'),
        ('Adventure'),
        ('Drama'),
        ('Sci-Fi'),
        ('Comedy'),
        ('Thriller')
) AS source (genre_name)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Genres AS g
    WHERE g.GenreName = source.genre_name
);
GO

INSERT INTO dbo.Movies
(
    Title,
    ReleaseYear,
    GenreId,
    DirectorName,
    RuntimeMinutes,
    AverageRating
)
SELECT
    source.Title,
    source.ReleaseYear,
    g.GenreId,
    source.DirectorName,
    source.RuntimeMinutes,
    source.AverageRating
FROM
(
    VALUES
        ('Inception', 2010, 'Sci-Fi', 'Christopher Nolan', 148, CAST(8.8 AS DECIMAL(3,1))),
        ('The Dark Knight', 2008, 'Action', 'Christopher Nolan', 152, CAST(9.0 AS DECIMAL(3,1))),
        ('Interstellar', 2014, 'Sci-Fi', 'Christopher Nolan', 169, CAST(8.7 AS DECIMAL(3,1))),
        ('The Martian', 2015, 'Sci-Fi', 'Ridley Scott', 144, CAST(8.0 AS DECIMAL(3,1))),
        ('Top Gun: Maverick', 2022, 'Action', 'Joseph Kosinski', 130, CAST(8.2 AS DECIMAL(3,1))),
        ('Knives Out', 2019, 'Thriller', 'Rian Johnson', 130, CAST(7.9 AS DECIMAL(3,1))),
        ('The Grand Budapest Hotel', 2014, 'Comedy', 'Wes Anderson', 99, CAST(8.1 AS DECIMAL(3,1)))
) AS source (Title, ReleaseYear, GenreName, DirectorName, RuntimeMinutes, AverageRating)
INNER JOIN dbo.Genres AS g
    ON g.GenreName = source.GenreName
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Movies AS m
    WHERE m.Title = source.Title
      AND m.ReleaseYear = source.ReleaseYear
);
GO

INSERT INTO dbo.Watchlist (MovieId, IsWatched)
SELECT m.MovieId, source.IsWatched
FROM
(
    VALUES
        ('The Martian', 2015, CAST(0 AS BIT)),
        ('Knives Out', 2019, CAST(1 AS BIT)),
        ('The Grand Budapest Hotel', 2014, CAST(0 AS BIT))
) AS source (Title, ReleaseYear, IsWatched)
INNER JOIN dbo.Movies AS m
    ON m.Title = source.Title
   AND m.ReleaseYear = source.ReleaseYear
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Watchlist AS w
    WHERE w.MovieId = m.MovieId
);
GO
