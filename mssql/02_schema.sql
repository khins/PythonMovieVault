USE MovieVault;
GO

IF OBJECT_ID('dbo.Genres', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Genres
    (
        GenreId INT IDENTITY(1,1) PRIMARY KEY,
        GenreName NVARCHAR(100) NOT NULL UNIQUE
    );
END;
GO

IF OBJECT_ID('dbo.Movies', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Movies
    (
        MovieId INT IDENTITY(1,1) PRIMARY KEY,
        Title NVARCHAR(200) NOT NULL,
        ReleaseYear INT NOT NULL,
        GenreId INT NOT NULL,
        DirectorName NVARCHAR(150) NOT NULL,
        RuntimeMinutes INT NOT NULL,
        AverageRating DECIMAL(3,1) NULL,
        CONSTRAINT FK_Movies_Genres FOREIGN KEY (GenreId) REFERENCES dbo.Genres(GenreId)
    );
END;
GO

IF OBJECT_ID('dbo.Watchlist', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Watchlist
    (
        WatchlistId INT IDENTITY(1,1) PRIMARY KEY,
        MovieId INT NOT NULL,
        AddedOn DATETIME2 NOT NULL CONSTRAINT DF_Watchlist_AddedOn DEFAULT SYSUTCDATETIME(),
        IsWatched BIT NOT NULL CONSTRAINT DF_Watchlist_IsWatched DEFAULT 0,
        CONSTRAINT FK_Watchlist_Movies FOREIGN KEY (MovieId) REFERENCES dbo.Movies(MovieId),
        CONSTRAINT UQ_Watchlist_Movie UNIQUE (MovieId)
    );
END;
GO

IF OBJECT_ID('dbo.UserRatings', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserRatings
    (
        UserRatingId INT IDENTITY(1,1) PRIMARY KEY,
        MovieId INT NOT NULL,
        Rating TINYINT NOT NULL,
        ReviewNote NVARCHAR(500) NULL,
        RatedOn DATETIME2 NOT NULL CONSTRAINT DF_UserRatings_RatedOn DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_UserRatings_Movies FOREIGN KEY (MovieId) REFERENCES dbo.Movies(MovieId),
        CONSTRAINT CK_UserRatings_Rating CHECK (Rating BETWEEN 1 AND 10)
    );
END;
GO

CREATE OR ALTER VIEW dbo.vMovieDetails
AS
SELECT
    m.MovieId,
    m.Title,
    m.ReleaseYear,
    g.GenreName,
    m.DirectorName,
    m.RuntimeMinutes,
    m.AverageRating
FROM dbo.Movies AS m
INNER JOIN dbo.Genres AS g
    ON m.GenreId = g.GenreId;
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchMovies
    @Title NVARCHAR(200) = NULL,
    @GenreName NVARCHAR(100) = NULL,
    @DirectorName NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        MovieId,
        Title,
        ReleaseYear,
        GenreName,
        DirectorName,
        RuntimeMinutes,
        AverageRating
    FROM dbo.vMovieDetails
    WHERE (@Title IS NULL OR Title LIKE '%' + @Title + '%')
      AND (@GenreName IS NULL OR GenreName = @GenreName)
      AND (@DirectorName IS NULL OR DirectorName LIKE '%' + @DirectorName + '%')
    ORDER BY Title;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTopRatedMovies
    @Limit INT = 10,
    @GenreName NVARCHAR(100) = NULL,
    @DirectorName NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Limit <= 0
    BEGIN
        THROW 50003, 'Limit must be greater than 0.', 1;
    END;

    SELECT TOP (@Limit)
        m.MovieId,
        m.Title,
        m.ReleaseYear,
        g.GenreName,
        m.DirectorName,
        m.RuntimeMinutes,
        m.AverageRating
    FROM dbo.Movies AS m
    INNER JOIN dbo.Genres AS g
        ON m.GenreId = g.GenreId
    WHERE (@GenreName IS NULL OR g.GenreName = @GenreName)
      AND (@DirectorName IS NULL OR m.DirectorName LIKE '%' + @DirectorName + '%')
      AND m.AverageRating IS NOT NULL
    ORDER BY m.AverageRating DESC, m.Title ASC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddUserRating
    @MovieId INT,
    @Rating TINYINT,
    @ReviewNote NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.UserRatings (MovieId, Rating, ReviewNote)
    VALUES (@MovieId, @Rating, @ReviewNote);
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddMovie
    @Title NVARCHAR(200),
    @ReleaseYear INT,
    @GenreName NVARCHAR(100),
    @DirectorName NVARCHAR(150),
    @RuntimeMinutes INT,
    @AverageRating DECIMAL(3,1) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Movies
        WHERE Title = @Title
          AND ReleaseYear = @ReleaseYear
    )
    BEGIN
        SELECT
            MovieId,
            CAST(0 AS BIT) AS WasInserted
        FROM dbo.Movies
        WHERE Title = @Title
          AND ReleaseYear = @ReleaseYear;
        RETURN;
    END;

    DECLARE @GenreId INT;

    SELECT @GenreId = GenreId
    FROM dbo.Genres
    WHERE GenreName = @GenreName;

    IF @GenreId IS NULL
    BEGIN
        INSERT INTO dbo.Genres (GenreName)
        VALUES (@GenreName);

        SET @GenreId = SCOPE_IDENTITY();
    END;

    INSERT INTO dbo.Movies
    (
        Title,
        ReleaseYear,
        GenreId,
        DirectorName,
        RuntimeMinutes,
        AverageRating
    )
    VALUES
    (
        @Title,
        @ReleaseYear,
        @GenreId,
        @DirectorName,
        @RuntimeMinutes,
        @AverageRating
    );

    SELECT
        CAST(SCOPE_IDENTITY() AS INT) AS MovieId,
        CAST(1 AS BIT) AS WasInserted;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddToWatchlist
    @MovieId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Movies
        WHERE MovieId = @MovieId
    )
    BEGIN
        THROW 50001, 'Movie not found.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Watchlist
        WHERE MovieId = @MovieId
    )
    BEGIN
        SELECT
            WatchlistId,
            CAST(0 AS BIT) AS WasInserted
        FROM dbo.Watchlist
        WHERE MovieId = @MovieId;
        RETURN;
    END;

    INSERT INTO dbo.Watchlist (MovieId)
    VALUES (@MovieId);

    SELECT
        CAST(SCOPE_IDENTITY() AS INT) AS WatchlistId,
        CAST(1 AS BIT) AS WasInserted;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_MarkWatchlistAsWatched
    @MovieId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @WasUpdated BIT = 0;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Watchlist
        WHERE MovieId = @MovieId
    )
    BEGIN
        THROW 50002, 'Movie is not on the watchlist.', 1;
    END;

    UPDATE dbo.Watchlist
    SET IsWatched = 1
    WHERE MovieId = @MovieId
      AND IsWatched = 0;

    IF @@ROWCOUNT > 0
    BEGIN
        SET @WasUpdated = 1;
    END;

    SELECT
        WatchlistId,
        IsWatched,
        @WasUpdated AS WasUpdated
    FROM dbo.Watchlist
    WHERE MovieId = @MovieId;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_RemoveFromWatchlist
    @MovieId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @WasDeleted BIT = 0;

    DELETE FROM dbo.Watchlist
    WHERE MovieId = @MovieId;

    IF @@ROWCOUNT > 0
    BEGIN
        SET @WasDeleted = 1;
    END;

    SELECT @WasDeleted AS WasDeleted;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetWatchlist
    @WatchedOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        w.WatchlistId,
        m.MovieId,
        m.Title,
        m.ReleaseYear,
        w.AddedOn,
        w.IsWatched
    FROM dbo.Watchlist AS w
    INNER JOIN dbo.Movies AS m
        ON w.MovieId = m.MovieId
    WHERE (@WatchedOnly = 0 OR w.IsWatched = 1)
    ORDER BY w.IsWatched, w.AddedOn;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateUserRating
    @MovieId INT,
    @Rating TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.UserRatings
        WHERE MovieId = @MovieId
    )
    BEGIN
        THROW 50004, 'No user rating exists for this movie yet.', 1;
    END;

    ;WITH LatestRating AS
    (
        SELECT TOP (1)
            UserRatingId
        FROM dbo.UserRatings
        WHERE MovieId = @MovieId
        ORDER BY RatedOn DESC, UserRatingId DESC
    )
    UPDATE ur
    SET Rating = @Rating
    FROM dbo.UserRatings AS ur
    INNER JOIN LatestRating AS lr
        ON ur.UserRatingId = lr.UserRatingId;

    SELECT TOP (1)
        UserRatingId,
        Rating
    FROM dbo.UserRatings
    WHERE MovieId = @MovieId
    ORDER BY RatedOn DESC, UserRatingId DESC;
END;
GO
