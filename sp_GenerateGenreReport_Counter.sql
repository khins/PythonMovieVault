CREATE PROCEDURE sp_GenerateGenreReport_Counter
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Setup Temp Table
        IF OBJECT_ID('tempdb..#GenreResults') IS NOT NULL DROP TABLE #GenreResults;
        CREATE TABLE #GenreResults (
            GenreName VARCHAR(50),
            MovieCount INT,
            StatusMessage VARCHAR(100)
        );

        -- 2. Initialize the Counter and the Limit
        DECLARE @CurrentID INT, @MaxID INT;
        DECLARE @GenreName VARCHAR(50), @MovieCountResult INT, @ProcStatus INT;

        SELECT @CurrentID = MIN(genre_id), @MaxID = MAX(genre_id) FROM [dbo].[Genres];

        -- 3. Start the Counter Loop
        WHILE @CurrentID <= @MaxID
        BEGIN
            -- 4. Get the name for the current ID (handles gaps in IDs)
            SELECT @GenreName = [name] FROM [dbo].[Genres] WHERE genre_id = @CurrentID;

            -- Only run the logic if the ID actually exists (skips deleted IDs)
            IF @GenreName IS NOT NULL
            BEGIN
                EXEC @ProcStatus = sp_GetGenreStats 
                    @GenreName = @GenreName, 
                    @MovieCount = @MovieCountResult OUTPUT;

                INSERT INTO #GenreResults (GenreName, MovieCount, StatusMessage)
                VALUES (
                    @GenreName, 
                    @MovieCountResult, 
                    CASE 
                        WHEN @ProcStatus = 0 THEN 'Genre Not Found'
                        WHEN @ProcStatus = 1 THEN 'Empty Genre'
                        ELSE 'Contains Movies' 
                    END
                );
            END

            -- 5. Increment the counter (Critical to avoid infinite loop!)
            SET @CurrentID = @CurrentID + 1;
        END

        -- 6. Final Output
        SELECT * FROM #GenreResults ORDER BY MovieCount DESC;

    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorDetails;
    END CATCH
END;
GO

exec sp_GenerateGenreReport_Counter;