CREATE TRIGGER trg_UpdateUserBalanceIfTransactionMatch
ON Transactions
AFTER INSERT
AS
BEGIN
	DECLARE @UserSells NVARCHAR(50), @UserSellsID INT
	DECLARE @UserBuys NVARCHAR(50), @UserBuysID INT

	IF (SELECT TransactionType FROM inserted) = 'Buying'
	BEGIN
		EXECUTE UpdateUserBalanceOnBuying @pUserEmail = (SELECT UserEmail FROM inserted), @pTransactionValue = (SELECT TransactionValue FROM inserted)

		SET @UserBuys = (SELECT UserEmail FROM inserted)
		SET @UserBuysID = (SELECT TransactionID FROM inserted)
		
		SELECT t.* INTO #t1
		FROM Transactions t, inserted i
		WHERE t.ValidSkinID = i.ValidSkinID AND 
			i.TransactionValue >= t.TransactionValue AND
			t.TransactionType = 'Selling' AND 
			t.TransactionStatus = 'Ongoing'
			
		SELECT TOP 1 * INTO #t2
		FROM #t1
		ORDER BY #t1.TransactionValue

		SET @UserSells = (SELECT UserEmail FROM #t2)
		
	END --IF vege
	ELSE 
	BEGIN
		SET @UserSells = (SELECT UserEmail FROM inserted)
		SET @UserSellsID = (SELECT TransactionID FROM inserted)

		SELECT t.* INTO #t1
		FROM Transactions t, inserted i
		WHERE t.ValidSkinID = i.ValidSkinID AND 
			i.TransactionValue >= t.TransactionValue AND
			t.TransactionType = 'Buying' AND 
			t.TransactionStatus = 'Ongoing'
			
		SELECT TOP 1 * INTO #t2
		FROM #t1
		ORDER BY #t1.TransactionValue DESC

		SET @UserBuys = (SELECT UserEmail FROM #t2)
	END --Else vege
	
	--Tranzakciok statuszanak megvaltoztatasa
	UPDATE Transactions
		SET TransactionStatus = 'Succesfull'
		WHERE TransactionID = @UserSellsID

	UPDATE Transactions
	SET TransactionStatus = 'Succesfull'
	WHERE TransactionID = @UserBuysID

	--ha a vasarlo fel a felajanlottnal kevesebbet kell fizessek akkor visszakapja a penzet
	IF (SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserSellsID) != (SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserBuysID)
	BEGIN
		UPDATE Users
		SET UserBalance = UserBalance + ((SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserBuysID) - (SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserSellsID))
		WHERE UserEmail = @UserBuys
	END

	-- Ha a vasarlo kevesebbert vasarlot mint amenyit felajanlot akkor a tranzakcio ertekenek a modositasa
	UPDATE Transactions
	SET TransactionValue = (SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserSellsID)
	WHERE TransactionID = @UserBuysID

	--Tranzakciok utana UserBalance valtozasok elintezese
	UPDATE Users
	SET UserBalance = (SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserSellsID)
	WHERE UserEmail = @UserSells

	--A skik kiosztasa a vasarlonak
	INSERT INTO Own VALUES
	(GETDATE(), @UserBuys, (SELECT ValidSkinID FROM Transactions WHERE TransactionID = @UserSellsID))

	
	DROP TABLE #t1
	DROP TABLE #t2
END


--Tarolt eljarasok:
--Visszaadja azt a userEmail-t aki a legnagyobb transactionValue-val rendelkezik