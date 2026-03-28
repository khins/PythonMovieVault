--drop procedure sp_GetGenreStats;

CREATE PROCEDURE sp_GetGenreStats
    @GenreName VARCHAR(50),         -- Input: The string name from your Genres table
    @MovieCount INT OUTPUT          -- Output: To return the total count
AS
BEGIN
    DECLARE @TargetID INT;

    -- 1. Look up the genre_id based on the name provided
    SELECT @TargetID = genre_id 
    FROM [dbo].[Genres] 
    WHERE [name] = @GenreName;

    -- 2. Check if the genre actually exists
    IF @TargetID IS NULL
    BEGIN
        SET @MovieCount = 0;
        RETURN 0; -- Return 0 to indicate the genre name wasn't found
    END

    -- 3. Perform the count on the Movies table using the ID
    -- (Assumes your Movies table now has a genre_id column)
    SELECT @MovieCount = COUNT(*) 
    FROM Movies 
    WHERE genre_id = @TargetID;

    -- 4. Final status check
    IF @MovieCount > 0
        RETURN 1; -- Success: Genre exists and has movies
    ELSE
        RETURN 2; -- Partial Success: Genre exists but has 0 movies
END;

DECLARE @FoundCount INT;
DECLARE @ReturnStatus INT;

EXEC @ReturnStatus = sp_GetGenreStats 
    @GenreName = 'Sci-Fi', 
    @MovieCount = @FoundCount OUTPUT;

-- Evaluate the return value
IF @ReturnStatus = 1
    PRINT 'Found ' + CAST(@FoundCount AS VARCHAR) + ' movies.';
ELSE IF @ReturnStatus = 2
    PRINT 'Genre exists, but no movies are assigned to it.';
ELSE
    PRINT 'Error: That genre name does not exist in the Genres table.';