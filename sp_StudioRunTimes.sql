drop procedure sp_StudioRunTimes;

CREATE PROCEDURE sp_StudioRunTimes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        title,
        studio,
        SUM(runtime) AS total_runtime,
        AVG(runtime) AS average_runtime
    FROM Movies
    GROUP BY studio, title
    ORDER BY studio ASC;
END;
GO

ALTER TABLE Movies
ADD studio VARCHAR(100) NULL;
GO

ALTER TABLE Movies
ADD runtime SMALLINT NULL;
GO

UPDATE Movies SET studio = 'Columbia Pictures' WHERE title = 'The Shawshank Redemption';
UPDATE Movies SET studio = 'Paramount Pictures' WHERE title = 'The Godfather';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'The Dark Knight';
UPDATE Movies SET studio = 'Paramount Pictures' WHERE title = 'The Godfather Part II';
UPDATE Movies SET studio = 'United Artists' WHERE title = '12 Angry Men';
UPDATE Movies SET studio = 'New Line Cinema' WHERE title = 'The Lord of the Rings: The Return of the King';
UPDATE Movies SET studio = 'Universal Pictures' WHERE title = 'Schindler''s List';
UPDATE Movies SET studio = 'New Line Cinema' WHERE title = 'The Lord of the Rings: The Fellowship of the Ring';
UPDATE Movies SET studio = 'Miramax' WHERE title = 'Pulp Fiction';
UPDATE Movies SET studio = 'Produzioni Europee Associate' WHERE title = 'The Good, the Bad and the Ugly';
UPDATE Movies SET studio = 'New Line Cinema' WHERE title = 'The Lord of the Rings: The Two Towers';
UPDATE Movies SET studio = 'Paramount Pictures' WHERE title = 'Forrest Gump';
UPDATE Movies SET studio = '20th Century Fox' WHERE title = 'Fight Club';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'Inception';
UPDATE Movies SET studio = 'Lucasfilm' WHERE title = 'Star Wars: Episode V - The Empire Strikes Back';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'The Matrix';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'GoodFellas';
UPDATE Movies SET studio = 'Paramount Pictures' WHERE title = 'Interstellar';
UPDATE Movies SET studio = 'United Artists' WHERE title = 'One Flew Over the Cuckoo''s Nest';
UPDATE Movies SET studio = 'New Line Cinema' WHERE title = 'Seven';
UPDATE Movies SET studio = 'RKO Radio Pictures' WHERE title = 'It''s a Wonderful Life';
UPDATE Movies SET studio = 'Orion Pictures' WHERE title = 'The Silence of the Lambs';
UPDATE Movies SET studio = 'Toho' WHERE title = 'Seven Samurai';
UPDATE Movies SET studio = 'DreamWorks' WHERE title = 'Saving Private Ryan';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'The Green Mile';
UPDATE Movies SET studio = 'O2 Filmes' WHERE title = 'City of God';
UPDATE Movies SET studio = 'Miramax' WHERE title = 'Life Is Beautiful';
UPDATE Movies SET studio = 'TriStar Pictures' WHERE title = 'Terminator 2: Judgment Day';
UPDATE Movies SET studio = 'Lucasfilm' WHERE title = 'Star Wars: Episode IV - A New Hope';
UPDATE Movies SET studio = 'Universal Pictures' WHERE title = 'Back to the Future';
UPDATE Movies SET studio = 'Studio Ghibli' WHERE title = 'Spirited Away';
UPDATE Movies SET studio = 'Focus Features' WHERE title = 'The Pianist';
UPDATE Movies SET studio = 'DreamWorks' WHERE title = 'Gladiator';
UPDATE Movies SET studio = 'CJ Entertainment' WHERE title = 'Parasite';
UPDATE Movies SET studio = 'Studio Ghibli' WHERE title = 'Grave of the Fireflies';
UPDATE Movies SET studio = 'Paramount Pictures' WHERE title = 'Psycho';
UPDATE Movies SET studio = 'Walt Disney Pictures' WHERE title = 'The Lion King';
UPDATE Movies SET studio = 'Shochiku' WHERE title = 'Harakiri';
UPDATE Movies SET studio = 'Sony Pictures Classics' WHERE title = 'Whiplash';
UPDATE Movies SET studio = 'Gaumont' WHERE title = 'The Intouchables';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'The Departed';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'The Prestige';
UPDATE Movies SET studio = 'Warner Bros.' WHERE title = 'Casablanca';
UPDATE Movies SET studio = 'PolyGram Filmed Entertainment' WHERE title = 'The Usual Suspects';
UPDATE Movies SET studio = 'New Line Cinema' WHERE title = 'American History X';
UPDATE Movies SET studio = 'Gaumont' WHERE title = 'Léon: The Professional';
UPDATE Movies SET studio = 'Universal Pictures' WHERE title = 'The Green Book';
UPDATE Movies SET studio = 'Buena Vista International' WHERE title = 'The Lives of Others';
UPDATE Movies SET studio = 'United Artists' WHERE title = 'The Great Dictator';
UPDATE Movies SET studio = 'Miramax' WHERE title = 'Cinema Paradiso';

UPDATE Movies SET runtime = 142 WHERE title = 'The Shawshank Redemption';
UPDATE Movies SET runtime = 175 WHERE title = 'The Godfather';
UPDATE Movies SET runtime = 152 WHERE title = 'The Dark Knight';
UPDATE Movies SET runtime = 202 WHERE title = 'The Godfather Part II';
UPDATE Movies SET runtime = 96  WHERE title = '12 Angry Men';
UPDATE Movies SET runtime = 201 WHERE title = 'The Lord of the Rings: The Return of the King';
UPDATE Movies SET runtime = 195 WHERE title = 'Schindler''s List';
UPDATE Movies SET runtime = 178 WHERE title = 'The Lord of the Rings: The Fellowship of the Ring';
UPDATE Movies SET runtime = 154 WHERE title = 'Pulp Fiction';
UPDATE Movies SET runtime = 178 WHERE title = 'The Good, the Bad and the Ugly';
UPDATE Movies SET runtime = 179 WHERE title = 'The Lord of the Rings: The Two Towers';
UPDATE Movies SET runtime = 142 WHERE title = 'Forrest Gump';
UPDATE Movies SET runtime = 139 WHERE title = 'Fight Club';
UPDATE Movies SET runtime = 148 WHERE title = 'Inception';
UPDATE Movies SET runtime = 124 WHERE title = 'Star Wars: Episode V - The Empire Strikes Back';
UPDATE Movies SET runtime = 136 WHERE title = 'The Matrix';
UPDATE Movies SET runtime = 146 WHERE title = 'GoodFellas';
UPDATE Movies SET runtime = 169 WHERE title = 'Interstellar';
UPDATE Movies SET runtime = 133 WHERE title = 'One Flew Over the Cuckoo''s Nest';
UPDATE Movies SET runtime = 127 WHERE title = 'Seven';
UPDATE Movies SET runtime = 130 WHERE title = 'It''s a Wonderful Life';
UPDATE Movies SET runtime = 118 WHERE title = 'The Silence of the Lambs';
UPDATE Movies SET runtime = 207 WHERE title = 'Seven Samurai';
UPDATE Movies SET runtime = 169 WHERE title = 'Saving Private Ryan';
UPDATE Movies SET runtime = 189 WHERE title = 'The Green Mile';
UPDATE Movies SET runtime = 130 WHERE title = 'City of God';
UPDATE Movies SET runtime = 116 WHERE title = 'Life Is Beautiful';
UPDATE Movies SET runtime = 137 WHERE title = 'Terminator 2: Judgment Day';
UPDATE Movies SET runtime = 121 WHERE title = 'Star Wars: Episode IV - A New Hope';
UPDATE Movies SET runtime = 116 WHERE title = 'Back to the Future';
UPDATE Movies SET runtime = 125 WHERE title = 'Spirited Away';
UPDATE Movies SET runtime = 150 WHERE title = 'The Pianist';
UPDATE Movies SET runtime = 155 WHERE title = 'Gladiator';
UPDATE Movies SET runtime = 132 WHERE title = 'Parasite';
UPDATE Movies SET runtime = 89  WHERE title = 'Grave of the Fireflies';
UPDATE Movies SET runtime = 109 WHERE title = 'Psycho';
UPDATE Movies SET runtime = 88  WHERE title = 'The Lion King';
UPDATE Movies SET runtime = 133 WHERE title = 'Harakiri';
UPDATE Movies SET runtime = 107 WHERE title = 'Whiplash';
UPDATE Movies SET runtime = 112 WHERE title = 'The Intouchables';
UPDATE Movies SET runtime = 151 WHERE title = 'The Departed';
UPDATE Movies SET runtime = 130 WHERE title = 'The Prestige';
UPDATE Movies SET runtime = 102 WHERE title = 'Casablanca';
UPDATE Movies SET runtime = 106 WHERE title = 'The Usual Suspects';
UPDATE Movies SET runtime = 119 WHERE title = 'American History X';
UPDATE Movies SET runtime = 110 WHERE title = 'Léon: The Professional';
UPDATE Movies SET runtime = 130 WHERE title = 'The Green Book';
UPDATE Movies SET runtime = 137 WHERE title = 'The Lives of Others';
UPDATE Movies SET runtime = 125 WHERE title = 'The Great Dictator';
UPDATE Movies SET runtime = 155 WHERE title = 'Cinema Paradiso';

EXEC sp_StudioRunTimes;