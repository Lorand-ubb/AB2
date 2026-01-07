CREATE OR ALTER PROCEDURE SkinsVasarlasAutoKeresessel
    @pUserEmail NVARCHAR(50),      -- Ki vasarol?
    @pSkinName NVARCHAR(50),       -- Milyen skint?
    @pOperatorName NVARCHAR(50),   -- Melyik operatornak?
    @pAr INT,                      -- Mennyibe kerul a skin?
    @pSikeresTargy NVARCHAR(50) OUTPUT, -- Melyik fegyverre vettuk meg?
    @pMaradekEgyenleg INT OUTPUT        -- Mennyi penze maradt?
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Users WHERE UserEmail = @pUserEmail)
    BEGIN
        RAISERROR('A megadott felhasznalo nem letezik.', 11, 1)
        RETURN -2
    END

    IF NOT EXISTS (SELECT 1 FROM Skins WHERE SkinName = @pSkinName)
    BEGIN
        RAISERROR('A megadott Skin nem letezik.', 11, 2)
        RETURN -3
    END

    IF NOT EXISTS (SELECT 1 FROM Operators WHERE OperatorName = @pOperatorName)
    BEGIN
        RAISERROR('A megadott Operator nem letezik.', 11, 3)
        RETURN -4
    END

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
    BEGIN TRANSACTION

    DECLARE @KeresettValidSkinID INT
    DECLARE @KeresettItemName NVARCHAR(50)
    DECLARE @TalaltVasarolhato BIT = 0

    DECLARE SkinKereso CURSOR LOCAL FOR 
    SELECT VS.ValidSkinID, VS.ItemName
    FROM ValidSkins VS
    WHERE VS.SkinName = @pSkinName 
        AND VS.OperatorName = @pOperatorName
        
    OPEN SkinKereso
    FETCH NEXT FROM SkinKereso INTO @KeresettValidSkinID, @KeresettItemName

    WHILE @@FETCH_STATUS = 0 AND @TalaltVasarolhato = 0
    BEGIN
		-- Megnezi ha a skint birtokolja a felhasznalo
        IF NOT EXISTS (
            SELECT 1 
            FROM Own 
            WHERE UserEmail = @pUserEmail 
                AND ValidSkinID = @KeresettValidSkinID 
			) 
        BEGIN 
            DECLARE @JelenlegiEgyenleg INT 
            SELECT @JelenlegiEgyenleg = UserBalance FROM Users WHERE UserEmail = @pUserEmail 

            IF @JelenlegiEgyenleg >= @pAr 
            BEGIN 
                UPDATE Users 
                SET UserBalance = UserBalance - @pAr 
                WHERE UserEmail = @pUserEmail 

                INSERT INTO Own (SkinAcquireDate, UserEmail, ValidSkinID) 
                VALUES (GETDATE(), @pUserEmail, @KeresettValidSkinID) 

				IF @@ERROR <> 0 
				BEGIN 
					RAISERROR('Insert hiba',16, 1) 
					ROLLBACK TRANSACTION 
					RETURN -11 
				END 

                INSERT INTO Transactions (TransactionValue, TransactionType, TransactionDate, TransactionStatus, UserEmail, ValidSkinID) 
                VALUES (@pAr, 'Buying', GETDATE(), 'Success', @pUserEmail, @KeresettValidSkinID) 

				IF @@ERROR <> 0 
				BEGIN 
					RAISERROR('Insert hiba',16, 1) 
					ROLLBACK TRANSACTION 
					RETURN -11 
				END 

                SET @TalaltVasarolhato = 1 
                SET @pSikeresTargy = @KeresettItemName 
                SET @pMaradekEgyenleg = @JelenlegiEgyenleg - @pAr 
            END 
        END 

        FETCH NEXT FROM SkinKereso INTO @KeresettValidSkinID, @KeresettItemName 
    END 

    CLOSE SkinKereso 
    DEALLOCATE SkinKereso 

    IF @TalaltVasarolhato = 1 
    BEGIN 
        COMMIT TRANSACTION 
        RETURN 1 
    END 
    ELSE 
    BEGIN 
        ROLLBACK TRANSACTION 
        RAISERROR('Nem sikerult vasarolni (Mar birtokolja az osszes variaciot vagy nincs eleg penz).', 11, 5)
        RETURN -1
    END
END
GO



--teszt

-- ELOKESZULETEK
DELETE FROM Own 
WHERE UserEmail = 'ash.player@gmail.com' 
  AND ValidSkinID = 1; -- Black Ice - R4-C

UPDATE Users
SET UserBalance = 5200
WHERE UserEmail = 'ash.player@gmail.com';


-- MAGA A TESZT
DECLARE @VettTargy NVARCHAR(50)
DECLARE @UjEgyenleg INT
DECLARE @RetVal INT

-- ADATOK A TESZT ELOTT
SELECT 'Inventory' as Tabla, UserEmail, ValidSkinID, SkinAcquireDate 
FROM Own 
WHERE UserEmail = 'ash.player@gmail.com';

SELECT 'Penzugyek' as Tabla, UserName, UserBalance 
FROM Users 
WHERE UserEmail = 'ash.player@gmail.com';

EXEC @RetVal = SkinsVasarlas_AutoKeresessel 
    @pUserEmail = 'ash.player@gmail.com', 
    @pSkinName = 'Black Ice', 
    @pOperatorName = 'Ash', 
    @pAr = 2500,
    @pSikeresTargy = @VettTargy OUTPUT, 
    @pMaradekEgyenleg = @UjEgyenleg OUTPUT;

PRINT '--------------------------------------------------'
PRINT 'Visszateresi kod (1 = Siker): ' + CAST(@RetVal AS VARCHAR)
PRINT 'Megvasarolt fegyver: ' + @VettTargy
PRINT 'Megmaradt penz: ' + CAST(@UjEgyenleg AS VARCHAR)
PRINT '--------------------------------------------------'


-- ADATOK A TESZT UTAN
SELECT 'Inventory' as Tabla, UserEmail, ValidSkinID, SkinAcquireDate 
FROM Own 
WHERE UserEmail = 'ash.player@gmail.com';

SELECT 'Penzugyek' as Tabla, UserName, UserBalance 
FROM Users 
WHERE UserEmail = 'ash.player@gmail.com';
