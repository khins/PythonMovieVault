--drop procedure sp_GetGenreStats;

CREATE PROCEDURE sp_GetGenreStats
    @GenreName VARCHAR(50),
    @MovieCount INT OUTPUT
AS
BEGIN
    DECLARE @TargetID INT;

    -- 1. Lookup the ID from your Genres table
    SELECT @TargetID = genre_id 
    FROM [dbo].[Genres] 
    WHERE [name] = @GenreName;

    -- 2. IF logic to check if the Genre Name exists in the Genres table
    IF @TargetID IS NULL
    BEGIN
        PRINT 'System Message: The genre "' + @GenreName + '" does not exist in the Genres table.';
        SET @MovieCount = 0;
        RETURN 0; -- Status: Genre not found
    END
    ELSE
    BEGIN
        -- 3. If it exists, perform the count
        SELECT @MovieCount = COUNT(*) 
        FROM Movies 
        WHERE genre_id = @TargetID;

        -- 4. Nested IF to provide specific feedback based on the count
        IF @MovieCount = 0
        BEGIN
            PRINT 'System Message: Genre found, but no movies are currently assigned to it.';
            RETURN 1; -- Status: Genre found, count is zero
        END
        ELSE
        BEGIN
            PRINT 'System Message: Success! Movies found for genre: ' + @GenreName;
            RETURN 2; -- Status: Genre found, movies exist
        END
    END
END;


--Key Rules for the EXEC Method:
--The Assignment Order: The variable for the RETURN value must come immediately
--after EXEC (e.g., EXEC @Status = ...).

--The OUTPUT Keyword: When calling the proc, you must include the word
--OUTPUT after the local variable, or SQL Server will not update your local variable with the new value.

--Named vs. Positional: While you can just pass values in order (e.g.,
--EXEC @Status = sp_GetGenreStats 'Comedy', @Count OUTPUT), using the
--@ParameterName = @LocalVariable syntax is a best practice because it makes
--your code much easier to read and maintain.



-- 1. Declare local variables to "catch" the data coming back
DECLARE @MovieCountResult INT;
DECLARE @ProcStatus INT;

-- 2. Execute the procedure
-- Note: The return value is assigned using '=' before the EXEC
EXEC @ProcStatus = sp_GetGenreStats 
    @GenreName = 'Comedy',            -- Input
    @MovieCount = @MovieCountResult OUTPUT; -- Output (Keyword is required!)

-- 3. Review the results
SELECT 
    @ProcStatus AS [Return Code], 
    @MovieCountResult AS [Movies Found];

-- 4. Use logic based on the results
IF @ProcStatus = 0
    PRINT 'Check your spelling; that genre does not exist.';
ELSE
    PRINT 'The count for this genre is: ' + CAST(@MovieCountResult AS VARCHAR);



--How this works:
--The Cursor: Think of GenreCursor as a pointer that sits on the Genres 
--table and moves down one row at a time.

--FETCH NEXT: This command physically moves the pointer and "pours" the genre name into 
--our @CurrentGenre variable.

--@@FETCH_STATUS: This is a global SQL variable. It stays at 0 as long as the cursor
--successfully finds a new row. As soon as you hit the end of the table, it changes, and the WHILE loop stops.

--Cleanup: Cursors take up memory. CLOSE releases the data lock, and DEALLOCATE
--deletes the cursor definition from memory.

-- 1. Declare variables for the loop
DECLARE @CurrentGenre VARCHAR(50);
DECLARE @MovieCountResult INT;
DECLARE @ProcStatus INT;

-- 2. Define a Cursor to grab all names from your Genres table
DECLARE GenreCursor CURSOR FOR 
SELECT [name] FROM [dbo].[Genres];

-- 3. Open the cursor and fetch the first record
OPEN GenreCursor;
FETCH NEXT FROM GenreCursor INTO @CurrentGenre;

-- 4. Start the WHILE loop
-- @@FETCH_STATUS = 0 means "there is still another row to process"
WHILE @@FETCH_STATUS = 0
BEGIN
    -- 5. Call your stored procedure for the current genre
    EXEC @ProcStatus = sp_GetGenreStats 
        @GenreName = @CurrentGenre, 
        @MovieCount = @MovieCountResult OUTPUT;

    -- 6. Print the results for this specific iteration
    PRINT 'Processing: ' + @CurrentGenre + ' | Count: ' + CAST(@MovieCountResult AS VARCHAR);

    -- 7. Fetch the next genre name to continue the loop
    FETCH NEXT FROM GenreCursor INTO @CurrentGenre;
END;

-- 8. Clean up! Always close and deallocate cursors
CLOSE GenreCursor;
DEALLOCATE GenreCursor;

--Why use a Temporary Table (#)?
--Sorting Power: You can't sort PRINT statements. By saving data to #GenreResults, you can use
--ORDER BY MovieCount DESC to instantly see your most popular genres.

--Data Analysis: You can run further queries on this temp table, such as finding the average
--number of movies per genre: SELECT AVG(MovieCount) FROM #GenreResults.

--Cleanliness: Unlike a permanent table, this disappears automatically when you close your
--SSMS tab, so it doesn't clutter your Genres or Movies database.


-- 1. Create a temporary table to hold the results
-- This table lives in memory and is deleted when you close your connection.
IF OBJECT_ID('tempdb..#GenreResults') IS NOT NULL DROP TABLE #GenreResults;

CREATE TABLE #GenreResults (
    GenreName VARCHAR(50),
    MovieCount INT,
    StatusMessage VARCHAR(100)
);

-- 2. Variables for the loop
DECLARE @CurrentGenre VARCHAR(50);
DECLARE @MovieCountResult INT;
DECLARE @ProcStatus INT;

-- 3. Define and Open the Cursor
DECLARE GenreCursor CURSOR FOR 
SELECT [name] FROM [dbo].[Genres];

OPEN GenreCursor;
FETCH NEXT FROM GenreCursor INTO @CurrentGenre;

-- 4. The Loop
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Call the stored procedure
    EXEC @ProcStatus = sp_GetGenreStats 
        @GenreName = @CurrentGenre, 
        @MovieCount = @MovieCountResult OUTPUT;

    -- 5. Instead of just printing, INSERT into our temp table
    INSERT INTO #GenreResults (GenreName, MovieCount, StatusMessage)
    VALUES (
        @CurrentGenre, 
        @MovieCountResult, 
        CASE 
            WHEN @ProcStatus = 0 THEN 'Genre Not Found'
            WHEN @ProcStatus = 1 THEN 'Empty Genre'
            WHEN @ProcStatus = 2 THEN 'Contains Movies'
        END
    );

    FETCH NEXT FROM GenreCursor INTO @CurrentGenre;
END;

-- 6. Cleanup Cursor
CLOSE GenreCursor;
DEALLOCATE GenreCursor;

-- 7. FINALLY: Sort the results by highest movie count
SELECT * FROM #GenreResults
ORDER BY MovieCount DESC, GenreName ASC;



--this is the "Gold Standard":
--Encapsulation: All the "messy" logic (cursors, temp tables, loops) is hidden inside the procedure.
--The end-user just sees a clean table of results.

--Maintainability: If you decide to change the sorting order or add a "Date Created" column later,
--you only change it in one place (the procedure), and every script using it gets the update automatically.

--Professionalism: This mimics how enterprise-level reporting systems work—running "Master Procs" 
--to aggregate data from multiple tables.


CREATE PROCEDURE sp_GenerateGenreReport
AS
BEGIN
    -- 1. SET NOCOUNT ON prevents "1 row affected" messages from cluttering the output
    SET NOCOUNT ON;

    -- 2. Setup the Temp Table
    IF OBJECT_ID('tempdb..#GenreResults') IS NOT NULL DROP TABLE #GenreResults;
    CREATE TABLE #GenreResults (
        GenreName VARCHAR(50),
        MovieCount INT,
        StatusMessage VARCHAR(100)
    );

    -- 3. Declare loop variables
    DECLARE @CurrentGenre VARCHAR(50);
    DECLARE @MovieCountResult INT;
    DECLARE @ProcStatus INT;

    -- 4. Cursor Logic
    DECLARE GenreCursor CURSOR FOR 
    SELECT [name] FROM [dbo].[Genres];

    OPEN GenreCursor;
    FETCH NEXT FROM GenreCursor INTO @CurrentGenre;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Call our existing stats procedure for each genre
        EXEC @ProcStatus = sp_GetGenreStats 
            @GenreName = @CurrentGenre, 
            @MovieCount = @MovieCountResult OUTPUT;

        -- Save to temp table
        INSERT INTO #GenreResults (GenreName, MovieCount, StatusMessage)
        VALUES (
            @CurrentGenre, 
            @MovieCountResult, 
            CASE 
                WHEN @ProcStatus = 0 THEN 'Genre Not Found'
                WHEN @ProcStatus = 1 THEN 'Empty Genre'
                WHEN @ProcStatus = 2 THEN 'Contains Movies'
            END
        );

        FETCH NEXT FROM GenreCursor INTO @CurrentGenre;
    END;

    -- 5. Cleanup Cursor
    CLOSE GenreCursor;
    DEALLOCATE GenreCursor;

    -- 6. Final Report Output
    PRINT '--- GENRE DISPATCH REPORT ---';
    SELECT 
        GenreName AS [Genre], 
        MovieCount AS [Total Movies], 
        StatusMessage AS [Status]
    FROM #GenreResults
    ORDER BY MovieCount DESC;

    -- Temp table is automatically dropped when procedure ends
END;
GO

EXEC sp_GenerateGenreReport;


--Key Error Handling Functions
--When a CATCH block is triggered, SQL Server provides several useful functions to tell you what happened:

--ERROR_MESSAGE(): Returns the actual text of the error (e.g., "Table not found").

--ERROR_NUMBER(): The unique ID of the SQL error.

--ERROR_PROCEDURE(): Tells you exactly which procedure the error occurred in
--(very helpful when you have nested procs).

--ERROR_LINE(): Returns the specific line number that failed.

ALTER PROCEDURE sp_GenerateGenreReport
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Wrap everything in a TRY block
    BEGIN TRY
        -- Setup Temp Table
        IF OBJECT_ID('tempdb..#GenreResults') IS NOT NULL DROP TABLE #GenreResults;
        CREATE TABLE #GenreResults (
            GenreName VARCHAR(50),
            MovieCount INT,
            StatusMessage VARCHAR(100)
        );

        -- Declare variables
        DECLARE @CurrentGenre VARCHAR(50);
        DECLARE @MovieCountResult INT;
        DECLARE @ProcStatus INT;

        -- Cursor Logic
        DECLARE GenreCursor CURSOR FOR SELECT [name] FROM [dbo].[Genres];
        OPEN GenreCursor;
        FETCH NEXT FROM GenreCursor INTO @CurrentGenre;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Call the sub-procedure
            EXEC @ProcStatus = sp_GetGenreStats 
                @GenreName = @CurrentGenre, 
                @MovieCount = @MovieCountResult OUTPUT;

            INSERT INTO #GenreResults (GenreName, MovieCount, StatusMessage)
            VALUES (
                @CurrentGenre, 
                @MovieCountResult, 
                CASE 
                    WHEN @ProcStatus = 0 THEN 'Genre Not Found'
                    WHEN @ProcStatus = 1 THEN 'Empty Genre'
                    WHEN @ProcStatus = 2 THEN 'Contains Movies'
                END
            );

            FETCH NEXT FROM GenreCursor INTO @CurrentGenre;
        END

        CLOSE GenreCursor;
        DEALLOCATE GenreCursor;

        -- Final Report
        SELECT * FROM #GenreResults ORDER BY MovieCount DESC;

    END TRY

    -- 2. If ANYTHING fails above, the code jumps here
    BEGIN CATCH
        -- Ensure the cursor is cleaned up if it failed mid-loop
        IF CURSOR_STATUS('global', 'GenreCursor') >= -1
        BEGIN
            IF CURSOR_STATUS('global', 'GenreCursor') > -1 CLOSE GenreCursor;
            DEALLOCATE GenreCursor;
        END

        -- 3. Display a helpful error message
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorDetails,
            ERROR_PROCEDURE() AS ErrorLocation;
            
        PRINT 'Critical Error: The report failed to complete.';
    END CATCH
END;
GO