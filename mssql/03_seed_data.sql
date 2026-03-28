USE MovieVault;
GO

INSERT INTO dbo.Genres (GenreName)
VALUES
    ('Action'),
    ('Adventure'),
    ('Drama'),
    ('Sci-Fi'),
    ('Comedy'),
    ('Thriller');
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
VALUES
    ('Inception', 2010, 4, 'Christopher Nolan', 148, 8.8),
    ('The Dark Knight', 2008, 1, 'Christopher Nolan', 152, 9.0),
    ('Interstellar', 2014, 4, 'Christopher Nolan', 169, 8.7),
    ('The Martian', 2015, 4, 'Ridley Scott', 144, 8.0),
    ('Top Gun: Maverick', 2022, 1, 'Joseph Kosinski', 130, 8.2),
    ('Knives Out', 2019, 6, 'Rian Johnson', 130, 7.9),
    ('The Grand Budapest Hotel', 2014, 5, 'Wes Anderson', 99, 8.1);
GO

INSERT INTO dbo.Watchlist (MovieId, IsWatched)
VALUES
    (4, 0),
    (6, 1),
    (7, 0);
GO

