--DML (Data Manipulation Language) Triggers
--in SQL Server—automated scripts that "fire" in response to table changes like INSERT, UPDATE, or DELETE.
--Unlike stored procedures, you don't call a trigger manually; the database engine executes it automatically when the 
--specified data change occurs.
--Gemini said
--This transcript explains DML (Data Manipulation Language) Triggers in SQL Server—automated scripts 
--that "fire" in response to table changes like INSERT, UPDATE, or DELETE.

--Unlike stored procedures, you don't call a trigger manually; the database engine executes it automatically
--when the specified data change occurs.

--1. How DML Triggers Work
--Triggers act as a "reflex" for your database. The instructor highlights three primary uses:

--Logging: Automatically writing to an audit log when data changes.

--Validation: Checking that the data meets complex rules before it's finalized.

--Blocking: Stopping an operation entirely if it violates a business policy.
-- 1. Create the trigger
CREATE TRIGGER TRG_PreventDirectorDelete
ON [dbo].[Directors]
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'Deletions are strictly prohibited in the Directors table.';
    -- By not writing a DELETE statement here, the original command is ignored
END;

-- 2. Test the trigger
DELETE FROM [dbo].[Directors] WHERE director_id = 1;
-- Result: The message prints, but the record remains in the table!