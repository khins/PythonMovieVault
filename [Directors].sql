CREATE TABLE [dbo].[Directors](
    [director_id] [int] IDENTITY(1,1) PRIMARY KEY,
    [name] [varchar](100) NOT NULL,
    [movie_id] [int] NULL, -- Simplified for this example
    CONSTRAINT FK_Directors_Movies FOREIGN KEY ([movie_id]) REFERENCES [dbo].[Movies](movie_id)
);

-- Quick seed data
INSERT INTO [dbo].[Directors] (name, movie_id)
VALUES ('Christopher Nolan', (SELECT movie_id FROM Movies WHERE Title = 'Inception')),
       ('Steven Spielberg', (SELECT movie_id FROM Movies WHERE Title = 'Schindler''s List'));