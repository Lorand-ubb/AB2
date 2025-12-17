CREATE OR ALTER PROCEDURE UpdateUserBalanceOnBuying
	@pUserEmail NVARCHAR(50), 
	@pTransactionValue INT,
	@pNewValue INT OUTPUT
AS
BEGIN 
	SET NOCOUNT ON; 

	IF NOT EXISTS (SELECT 1 FROM Users WHERE UserEmail = @pUserEmail)
	BEGIN
		RAISERROR('The user is does not exist', 16, 1)
		RETURN -10
	END

	IF @pTransactionValue < 0
	BEGIN
		RAISERROR('The value is negativ', 16, 1)
		RETURN -20
	END
	ELSE IF @pTransactionValue < 20
	BEGIN
		RAISERROR('The value is below 20, it needs to be higher', 16, 1)
		RETURN -21
	END

		
	IF (SELECT UserBalance FROM Users WHERE UserEmail = @pUserEmail) >= @pTransactionValue 
	BEGIN 
		SET @pNewValue = (SELECT UserBalance FROM Users WHERE UserEmail = @pUserEmail) - @pTransactionValue
		UPDATE Users 
		SET UserBalance = UserBalance - @pTransactionValue 
		FROM Users u 
		WHERE u.UserEmail = @pUserEmail 
	END
	ELSE
	BEGIN
		RAISERROR('The value is below 20, it needs to be higher', 16, 1)
		RETURN -12
	END
END
GO
