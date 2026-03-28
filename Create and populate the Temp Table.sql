-- 1. Create and populate the Temp Table
SELECT 
    m.Title, 
    g.name AS Genre, 
    dbo.fn_CalculateMovieAge(m.year) AS Age
INTO #AgingReport
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id;

-- 2. Add an index to make it fast (CTEs can't do this!)
CREATE INDEX IX_Genre ON #AgingReport(Genre);

-- 3. Now run multiple queries against it
SELECT * FROM #AgingReport WHERE Age > 20;
SELECT Genre, AVG(Age) AS AvgAge FROM #AgingReport GROUP BY Genre;

-- 4. Cleanup (Optional, as it dies when you close your connection)
DROP TABLE #AgingReport;