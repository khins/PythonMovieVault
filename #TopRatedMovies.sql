

-- 1. This creates #TopRatedMovies AND populates it in one go
-- We use 'AS GenreName' to explicitly name the column from the Genres table
SELECT 
    m.movie_id AS MovieID, 
    m.title, 
    g.name AS GenreName,  -- This defines the name inside the temp table
    m.rating
INTO #TopRatedMovies
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
WHERE m.rating >= 4.5;

-- 2. Verify the data is there
SELECT * FROM #TopRatedMovies;

-- 3. Run your summary
SELECT 
    GenreName, 
    COUNT(*) AS MovieCount,
    AVG(rating) AS AverageRating
FROM #TopRatedMovies
GROUP BY GenreName;

-- 4. Cleanup
DROP TABLE #TopRatedMovies;