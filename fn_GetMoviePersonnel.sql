CREATE FUNCTION dbo.fn_GetMoviePersonnel
(
    @TargetMovieID INT
)
RETURNS @PersonnelTable TABLE 
(
    PersonName VARCHAR(100),
    RoleType VARCHAR(50),
    CharacterOrJob VARCHAR(100)
)
AS
BEGIN
    -- 1. Insert the Actors into our temporary table variable
    INSERT INTO @PersonnelTable (PersonName, RoleType, CharacterOrJob)
    SELECT 
        a.name, 
        'Actor', 
        ma.role_name
    FROM [dbo].[Actors] a
    JOIN [dbo].[MovieActors] ma ON a.actor_id = ma.actor_id
    WHERE ma.movie_id = @TargetMovieID;

    -- 2. Insert the Directors into the SAME temporary table variable
    INSERT INTO @PersonnelTable (PersonName, RoleType, CharacterOrJob)
    SELECT 
        d.name, 
        'Director', 
        'Director'
    FROM [dbo].[Directors] d
    WHERE d.movie_id = @TargetMovieID;

    -- 3. Return the completed table
    RETURN;
END;
GO

-- Assuming Inception is Movie ID 14
SELECT * FROM dbo.fn_GetMoviePersonnel(14);

select * from Movies

select * from [dbo].[Directors]