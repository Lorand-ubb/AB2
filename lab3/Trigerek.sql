CREATE OR ALTER TRIGGER trg_UpdateUserBalanceIfTransactionMatch
ON Transactions
AFTER INSERT
AS
BEGIN
	
	-- Csak egy rekordot kezelunk egyszerre
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR('This trigger only supports single row inserts', 16, 1);
        ROLLBACK;
        RETURN;
    END

	
	DECLARE @UserSells NVARCHAR(50), @UserSellsID INT
	DECLARE @UserBuys NVARCHAR(50), @UserBuysID INT

	IF (SELECT TransactionType FROM inserted) = 'Buying'
	BEGIN

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
	
		DECLARE @vTransactionValue INT;
		SET @vTransactionValue = (SELECT TransactionValue FROM inserted)
		
		DECLARE @NewValue INT;

		EXEC UpdateUserBalanceOnBuying 
			@pUserEmail = @UserBuys,
			@pTransactionValue = @vTransactionValue,
			@pNewValue = @NewValue OUTPUT;
		
	END --IF vege
	ELSE 
	BEGIN -- Sell Begin
		SET @UserSells = (SELECT UserEmail FROM inserted)
		SET @UserSellsID = (SELECT TransactionID FROM inserted)

		SELECT t.* INTO #t3
		FROM Transactions t, inserted i
		WHERE t.ValidSkinID = i.ValidSkinID AND 
			i.TransactionValue >= t.TransactionValue AND
			t.TransactionType = 'Buying' AND 
			t.TransactionStatus = 'Ongoing'
			
		SELECT TOP 1 * INTO #t4
		FROM #t3
		ORDER BY #t3.TransactionValue DESC

		SET @UserBuys = (SELECT UserEmail FROM #t4)
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
		SET UserBalance = UserBalance + 
			((SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserBuysID) - (SELECT TransactionValue FROM Transactions WHERE TransactionID = @UserSellsID))
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
	DROP TABLE #t3
	DROP TABLE #t4
END

SELECT * FROM Users
SELECT * FROM Items
SELECT * FROM Skins
SELECT * FROM Operators
SELECT * FROM ValidSkins
SELECT * FROM Own o
SELECT * FROM Transactions

INSERT INTO Users VALUES
('testseller@test.com', 'testseller', 0),
('testbuyer@test.com', 'testbuyer', 1500)

INSERT INTO Items VALUES
('testitem', 'Weapon')

INSERT INTO Skins VALUES
('testSkin', GETDATE())

INSERT INTO Operators VALUES
('testOperator', GETDATE(), 'Attacker')

INSERT INTO ValidSkins VALUES
('testSkin', 'testitem', 'testOperator')

INSERT INTO Own VALUES
(GETDATE() ,'testseller@test.com', 16)

INSERT INTO Transactions VALUES
(1000, 'Selling', GETDATE(), 'Ongoing', 'testseller@test.com', 16)

INSERT INTO Transactions VALUES
(1200, 'Buying', GETDATE(), 'Ongoing', 'testbuyer@test.com', 16)
