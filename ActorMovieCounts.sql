WITH ActorMovieCounts AS (
    -- Step 1: Count movies per actor
    SELECT 
        a.name AS ActorName,
        COUNT(ma.movie_id) AS TotalMovies
    FROM [dbo].[Actors] AS a
    JOIN [dbo].[MovieActors] AS ma ON a.actor_id = ma.actor_id
    GROUP BY a.name
)
-- Step 2: Use the CTE to filter "Busy Actors"
SELECT 
    ActorName, 
    TotalMovies
FROM ActorMovieCounts
WHERE TotalMovies > 3
ORDER BY TotalMovies DESC;