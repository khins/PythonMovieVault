--DDL Triggers (Data Definition Language) react to changes in schema (structure). They fire in 
--response to commands like CREATE, ALTER, and DROP. These are primarily used by Database Administrators
--(DBAs) to enforce administrative rules and prevent accidental or unauthorized structural changes.
CREATE TRIGGER TRG_ProtectAllDatabases
ON ALL SERVER
FOR DROP_DATABASE
AS 
BEGIN
    PRINT 'Database deletion is disabled on this server!';
    ROLLBACK;
END;