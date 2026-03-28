-- Create the database
CREATE DATABASE MovieIntelligenceDB;
GO

-- Switch to the new database
USE MovieIntelligenceDB;
GO

-- Create the Movies table
CREATE TABLE Movies (
    movie_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    year SMALLINT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    revenue_generated DECIMAL(12,2) NULL
);
GO

INSERT INTO Movies (title, year, rating, revenue_generated) VALUES
('The Shawshank Redemption', 1994, 5, NULL),
('The Godfather', 1972, 5, NULL),
('The Dark Knight', 2008, 5, NULL),
('The Godfather Part II', 1974, 5, NULL),
('12 Angry Men', 1957, 5, NULL),
('The Lord of the Rings: The Return of the King', 2003, 5, NULL),
('Schindler''s List', 1993, 5, NULL),
('The Lord of the Rings: The Fellowship of the Ring', 2001, 5, NULL),
('Pulp Fiction', 1994, 5, NULL),
('The Good, the Bad and the Ugly', 1966, 5, NULL),
('The Lord of the Rings: The Two Towers', 2002, 5, NULL),
('Forrest Gump', 1994, 5, NULL),
('Fight Club', 1999, 5, NULL),
('Inception', 2010, 5, NULL),
('Star Wars: Episode V - The Empire Strikes Back', 1980, 5, NULL),
('The Matrix', 1999, 5, NULL),
('GoodFellas', 1990, 5, NULL),
('Interstellar', 2014, 5, NULL),
('One Flew Over the Cuckoo''s Nest', 1975, 5, NULL),
('Seven', 1995, 5, NULL),
('It''s a Wonderful Life', 1946, 5, NULL),
('The Silence of the Lambs', 1991, 5, NULL),
('Seven Samurai', 1954, 5, NULL),
('Saving Private Ryan', 1998, 5, NULL),
('The Green Mile', 1999, 5, NULL),
('City of God', 2002, 5, NULL),
('Life Is Beautiful', 1997, 5, NULL),
('Terminator 2: Judgment Day', 1991, 5, NULL),
('Star Wars: Episode IV - A New Hope', 1977, 5, NULL),
('Back to the Future', 1985, 5, NULL),
('Spirited Away', 2001, 5, NULL),
('The Pianist', 2002, 5, NULL),
('Gladiator', 2000, 5, NULL),
('Parasite', 2019, 5, NULL),
('Grave of the Fireflies', 1988, 5, NULL),
('Psycho', 1960, 5, NULL),
('The Lion King', 1994, 5, NULL),
('Harakiri', 1962, 5, NULL),
('Whiplash', 2014, 5, NULL),
('The Intouchables', 2011, 5, NULL),
('The Departed', 2006, 5, NULL),
('The Prestige', 2006, 5, NULL),
('Casablanca', 1942, 5, NULL),
('The Usual Suspects', 1995, 5, NULL),
('American History X', 1998, 5, NULL),
('Léon: The Professional', 1994, 5, NULL),
('The Green Book', 2018, 5, NULL),
('The Lives of Others', 2006, 5, NULL),
('The Great Dictator', 1940, 5, NULL),
('Cinema Paradiso', 1988, 5, NULL);

delete from  dbo.Movies;

select * from dbo.Movies
order by title;