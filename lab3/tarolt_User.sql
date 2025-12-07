CREATE PROCEDURE UpdateUserBalanceOnBuying
	@pUserEmail NVARCHAR(50), 
	@pTransactionValue INT
AS
BEGIN
	SET NOCOUNT ON; 

	--Parameter ellenorzes
	IF NOT EXISTS (SELECT * FROM Users WHERE UserEmail = @pUserEmail)
	BEGIN
		PRINT 'Ez a User nem letezik'
		RETURN
	END

	IF @pTransactionValue < 10
	BEGIN
		PRINT 'Ez az ertek tul kicsi'
		RETURN
	END

		
	IF (SELECT UserBalance FROM Users WHERE UserEmail = @pUserEmail) >= @pTransactionValue 
	BEGIN 
		UPDATE Users 
		SET UserBalance = UserBalance - @pTransactionValue 
		FROM Users u 
		WHERE u.UserEmail = @pUserEmail 
	END
	ELSE
	BEGIN
		PRINT 'The User does not have enough money for this transaction'
	END
END
GO
