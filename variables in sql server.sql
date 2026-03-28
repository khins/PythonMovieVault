-- 1. Declare the variables with their data types
DECLARE @MinLength INT;
DECLARE @MaxLength INT;
DECLARE @MovieGenre INT;

-- 2. Assign values using SET
SET @MinLength = 90;
SET @MaxLength = 150;
SET @MovieGenre = 13;

--select * from dbo.Genres;

-- 3. Use them in a query
SELECT title, Runtime, genre_id
FROM Movies
WHERE Runtime BETWEEN @MinLength AND @MaxLength
  AND genre_id = @MovieGenre;
