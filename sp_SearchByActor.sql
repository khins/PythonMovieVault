CREATE PROCEDURE sp_SearchByActor
    @ActorName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- We add wildcards (%) so that 'Leo' finds 'Leonardo DiCaprio'
    DECLARE @SearchTerm VARCHAR(105) = '%' + @ActorName + '%';

    SELECT 
        a.name AS Actor,
        m.Title AS MovieTitle,
        m.year,
        ma.role_name AS [Character Role],
        dbo.fn_CalculateMovieAge(m.year) AS MovieAge -- Reusing your age function!
    FROM [dbo].[Actors] AS a
    INNER JOIN [dbo].[MovieActors] AS ma ON a.actor_id = ma.actor_id
    INNER JOIN [dbo].[Movies] AS m ON ma.movie_id = m.movie_id
    WHERE a.name LIKE @SearchTerm
    ORDER BY m.year DESC;
    
    -- Check if we actually found anything
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No movies found for actor: ' + @ActorName;
    END
END;
GO

EXEC sp_SearchByActor 'Al Pacino';