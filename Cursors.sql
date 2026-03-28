--Cursors
--While SQL is typically a set-based language (meaning it handles entire tables of data at once),
--a Cursor allows you to break that rule. It is a control structure that enables you to walk 
--through a query result set one row at a time, similar to a for or while loop in traditional 
--programming languages like Python or Java.

--1. The 5-Step Cursor Lifecycle
--To use a cursor safely and effectively, you must follow this specific sequence:

--Declare: Define the cursor's name and the specific SELECT statement it will loop through.

--Open: Execute the query and ready the result set.

--Fetch: Grab the first (or next) row and pull its values into local variables.

--While Loop: Process the current row, then fetch the next one. This continues as 
--long as @@FETCH_STATUS = 0 (meaning rows are still available).

--Close & Deallocate: Release the rows and remove the cursor object from memory to prevent leaks.

DECLARE @MovieTitle VARCHAR(MAX);
DECLARE @FinalList VARCHAR(MAX) = '';

-- 1. Declare
DECLARE MovieCursor CURSOR FOR 
SELECT title FROM Movies;

-- 2. Open
OPEN MovieCursor;

-- 3. Fetch Initial Row
FETCH NEXT FROM MovieCursor INTO @MovieTitle;

-- 4. Loop through the rows
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @FinalList = @FinalList + @MovieTitle + ', ';
    
    -- Fetch the next row
    FETCH NEXT FROM MovieCursor INTO @MovieTitle;
END

-- 5. Cleanup
CLOSE MovieCursor;
DEALLOCATE MovieCursor;


-- Show the result
SELECT LEFT(@FinalList, LEN(@FinalList) - 1) AS AllMovies;

--The Shawshank Redemption, The Godfather, The Dark Knight, The Godfather Part II, 12 Angry Men, The Lord of the Rings: The Return of the King, Schindler's List, The Lord of the Rings: The Fellowship of the Ring, Pulp Fiction, The Good, the Bad and the Ugly, The Lord of the Rings: The Two Towers, Forrest Gump, Fight Club, Inception, Star Wars: Episode V - The Empire Strikes Back, The Matrix, GoodFellas, Interstellar, One Flew Over the Cuckoo's Nest, Seven, It's a Wonderful Life, The Silence of the Lambs, Seven Samurai, Saving Private Ryan, The Green Mile, City of God, Life Is Beautiful, Terminator 2: Judgment Day, Star Wars: Episode IV - A New Hope, Back to the Future, Spirited Away, The Pianist, Gladiator, Parasite, Grave of the Fireflies, Psycho, The Lion King, Harakiri, Whiplash, The Intouchables, The Departed, The Prestige, Casablanca, The Usual Suspects, American History X, Léon: The Professional, The Green Book, The Lives of Others, The Great Dictator, Cinema Paradiso