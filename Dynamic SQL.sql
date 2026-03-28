
--Dynamic SQL
--Dynamic SQL is a technique that allows you to build a SQL query as a string at runtime and
--then execute it. While standard SQL requires you to know your table and column names upfront,
--Dynamic SQL lets you change parts of the query—like the table name, the filters, or even the
--sort order—on the fly using variables.

--How It Works
--Instead of writing a fixed statement, you "stitch" together a string and pass it to a system procedure to run.

--The Manual Way (Concatenation): You build a string by adding variables directly into the text.

--Risk: This is vulnerable to SQL Injection (where a user can type malicious code into your variable to 
--delete data or bypass security).

--The Safe Way (sp_executesql): You use placeholders (parameters) instead of adding variables
--directly into the string. This is the "production-ready" method because it treats user input as data,
--not as executable code.

DECLARE @SQL NVARCHAR(MAX);
DECLARE @DirectorName NVARCHAR(100) = 'Steven Spielberg';

-- 1. Build the string with a placeholder (@Name)
SET @SQL = N'SELECT * FROM Directors WHERE name = @Name';

-- 2. Execute safely using sp_executesql
-- This separates the "Command" from the "Data"
EXEC sp_executesql 
    @SQL, 
    N'@Name NVARCHAR(100)', 
    @Name = @DirectorName;