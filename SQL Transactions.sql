--SQL Transactions
--The core philosophy of a transaction is the "all or nothing" principle—ensuring that a series of 
--database operations either all succeed together or none are applied at all.

SELECT definition 
FROM sys.check_constraints 
WHERE name = 'CK__Movies__rating__24927208';
--([rating]>=(1) AND [rating]<=(5))

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO [dbo].[Movies] (
        [title], [year], [rating], [revenue_generated], [genre_id], [studio], [runtime]
    )
    VALUES (
        'Inception', 
        2010, 
        5, -- Changed from 9 to 5 to satisfy most check constraints
        836800000.00, 
        1, 
        'Warner Bros.', 
        148
    );

    COMMIT TRANSACTION;
    PRINT 'Movie added successfully!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;