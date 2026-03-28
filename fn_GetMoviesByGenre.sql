CREATE FUNCTION dbo.fn_GetMoviesByGenre
(
    @TargetGenreID INT
)
RETURNS TABLE
AS
RETURN 
(
    -- The logic is a single SELECT statement
    SELECT 
        m.Title, 
        m.year, 
        g.[name] AS GenreName,
        dbo.fn_CalculateMovieAge(m.year) AS MovieAge -- Using our previous scalar function!
    FROM [dbo].[Movies] AS m
    INNER JOIN [dbo].[Genres] AS g ON m.genre_id = g.genre_id
    WHERE m.genre_id = @TargetGenreID
);
GO

-- Get all Sci-Fi movies (assuming Sci-Fi is ID 5)
SELECT * FROM dbo.fn_GetMoviesByGenre(5);

CREATE TABLE [dbo].[Actors](
    [actor_id] [int] IDENTITY(1,1) NOT NULL,
    [name] [varchar](100) NOT NULL,
    [date_of_birth] [date] NULL,
    [gender] [char](1) NULL,
PRIMARY KEY CLUSTERED ([actor_id] ASC)
) ON [PRIMARY];
GO


CREATE TABLE [dbo].[MovieActors](
    [movie_id] [int] NOT NULL,
    [actor_id] [int] NOT NULL,
    [role_name] [varchar](100) NULL,
    
    PRIMARY KEY CLUSTERED ([movie_id] ASC, [actor_id] ASC),

    -- This will now work because dbo.Movies and dbo.Actors both exist
    CONSTRAINT FK_MovieActors_Movies FOREIGN KEY ([movie_id]) 
    REFERENCES [dbo].[Movies] ([movie_id]),

    CONSTRAINT FK_MovieActors_Actors FOREIGN KEY ([actor_id]) 
    REFERENCES [dbo].[Actors] ([actor_id])
) ON [PRIMARY];
GO

INSERT INTO [dbo].[Actors] ([name], [date_of_birth], [gender])
VALUES 
('Tim Robbins', '1958-10-16', 'M'),          -- The Shawshank Redemption
('Morgan Freeman', '1937-06-01', 'M'),       -- The Shawshank Redemption
('Marlon Brando', '1924-04-03', 'M'),        -- The Godfather
('Al Pacino', '1940-04-25', 'M'),            -- The Godfather / Part II
('Robert De Niro', '1943-08-17', 'M'),       -- The Godfather Part II / GoodFellas
('Christian Bale', '1974-01-30', 'M'),       -- The Dark Knight / The Prestige
('Heath Ledger', '1979-04-04', 'M'),         -- The Dark Knight
('Henry Fonda', '1905-05-16', 'M'),          -- 12 Angry Men
('Elijah Wood', '1981-01-28', 'M'),          -- Lord of the Rings
('Liam Neeson', '1952-06-07', 'M'),          -- Schindler's List
('John Travolta', '1954-02-18', 'M'),        -- Pulp Fiction
('Samuel L. Jackson', '1948-12-21', 'M'),    -- Pulp Fiction
('Clint Eastwood', '1930-05-31', 'M'),       -- The Good, the Bad and the Ugly
('Tom Hanks', '1956-07-09', 'M'),            -- Forrest Gump / Saving Private Ryan
('Brad Pitt', '1963-12-18', 'M'),            -- Fight Club / Se7en
('Edward Norton', '1969-08-18', 'M'),        -- Fight Club / American History X
('Leonardo DiCaprio', '1974-11-11', 'M'),    -- Inception / The Departed
('Mark Hamill', '1951-09-25', 'M'),          -- Star Wars
('Keanu Reeves', '1964-09-02', 'M'),         -- The Matrix
('Matthew McConaughey', '1969-11-04', 'M'),  -- Interstellar
('Jack Nicholson', '1937-04-22', 'M'),       -- One Flew Over the Cuckoo's Nest
('Jodie Foster', '1962-11-19', 'F'),         -- The Silence of the Lambs
('Anthony Hopkins', '1937-12-31', 'M'),      -- The Silence of the Lambs
('Toshiro Mifune', '1920-04-01', 'M'),       -- Seven Samurai
('Michael Clarke Duncan', '1957-12-10', 'M'),-- The Green Mile
('Roberto Benigni', '1952-10-27', 'M'),      -- Life Is Beautiful
('Arnold Schwarzenegger', '1947-07-30', 'M'),-- Terminator 2
('Michael J. Fox', '1961-06-09', 'M'),       -- Back to the Future
('Russell Crowe', '1964-04-07', 'M'),        -- Gladiator
('Song Kang-ho', '1967-01-17', 'M'),         -- Parasite
('Anthony Perkins', '1932-04-04', 'M'),      -- Psycho
('Kevin Spacey', '1959-07-26', 'M'),         -- The Usual Suspects
('Jean Reno', '1948-07-30', 'M'),            -- Léon: The Professional
('Natalie Portman', '1981-06-09', 'F'),      -- Léon: The Professional
('Viggo Mortensen', '1958-10-20', 'M'),      -- The Green Book
('Humphrey Bogart', '1944-01-14', 'M');      -- Casablanca

select * from Actors

-- 1. Inception -> Leonardo DiCaprio
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'Inception'),
    (SELECT actor_id FROM Actors WHERE name = 'Leonardo DiCaprio'),
    'Cobb';

-- 2. The Dark Knight -> Christian Bale
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'The Dark Knight'),
    (SELECT actor_id FROM Actors WHERE name = 'Christian Bale'),
    'Bruce Wayne';

-- 3. The Godfather -> Marlon Brando
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'The Godfather'),
    (SELECT actor_id FROM Actors WHERE name = 'Marlon Brando'),
    'Vito Corleone';

-- 4. Pulp Fiction -> John Travolta
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'Pulp Fiction'),
    (SELECT actor_id FROM Actors WHERE name = 'John Travolta'),
    'Vincent Vega';

-- 5. Forrest Gump -> Tom Hanks
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'Forrest Gump'),
    (SELECT actor_id FROM Actors WHERE name = 'Tom Hanks'),
    'Forrest Gump';

-- 6. The Matrix -> Keanu Reeves
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'The Matrix'),
    (SELECT actor_id FROM Actors WHERE name = 'Keanu Reeves'),
    'Neo';

-- 7. Gladiator -> Russell Crowe
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'Gladiator'),
    (SELECT actor_id FROM Actors WHERE name = 'Russell Crowe'),
    'Maximus';

-- 8. The Silence of the Lambs -> Anthony Hopkins
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'The Silence of the Lambs'),
    (SELECT actor_id FROM Actors WHERE name = 'Anthony Hopkins'),
    'Hannibal Lecter';

-- 9. Fight Club -> Brad Pitt
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'Fight Club'),
    (SELECT actor_id FROM Actors WHERE name = 'Brad Pitt'),
    'Tyler Durden';

-- 10. Schindler''s List -> Liam Neeson
-- Note: Use double single-quotes for apostrophes in SQL strings
INSERT INTO [dbo].[MovieActors] (movie_id, actor_id, role_name)
SELECT 
    (SELECT movie_id FROM Movies WHERE Title = 'Schindler''s List'),
    (SELECT actor_id FROM Actors WHERE name = 'Liam Neeson'),
    'Oskar Schindler';

SELECT 
    f.Title, 
    f.MovieAge, 
    a.name
FROM dbo.fn_GetMoviesByGenre(3) AS f
JOIN MovieActors AS ma ON f.Movie_ID = ma.Movie_ID
JOIN Actors AS a ON ma.actor_id = a.actor_id;

select title from Movies