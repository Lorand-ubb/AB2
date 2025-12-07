--1.Listázd ki azoknak a felhasználóknak a nevét és email-címét, akik a legtöbb pénzt költötték sikeres vásárlások során! 
SELECT t.UserEmail, SUM(t.TransactionValue) as TotalTransactionValue INTO #t1
FROM Transactions t
WHERE 
	t.TransactionType = 'Buying' AND
	t.TransactionStatus = 'Succesfull'
GROUP BY t.UserEmail

SELECT u.UserName
FROM #t1, Users u
WHERE
	u.UserEmail = #t1.UserEmail

DROP TABLE #t1

--2.Listázd ki minden operator nevét és hogy hány különböző skinhez tartozik legalább egy sikeres tranzakció!
SELECT o.OperatorName, COUNT(DISTINCT vs.SkinName) AS KulonbozoSkinekSzama
FROM Operators o, ValidSkins vs, Transactions t
WHERE 
    o.OperatorName = vs.OperatorName AND
	vs.ValidSkinID = t.ValidSkinID AND
	t.TransactionStatus = 'Succesfull'
GROUP BY o.OperatorName
ORDER BY KulonbozoSkinekSzama DESC;

--3.Keresd meg azokat a felhasználókat, akik rendelkeznek „Black Ice” és „Neon Dawn” skinnel is, de nincs „White Noise” skinjük! 
SELECT o.UserEmail INTO #t1
FROM Own o, ValidSkins vs
WHERE
	o.ValidSkinID = vs.ValidSkinID AND
	vs.SkinName = 'Black Ice'

SELECT o.UserEmail INTO #t2
FROM Own o, ValidSkins vs
WHERE
	o.ValidSkinID = vs.ValidSkinID AND
	vs.SkinName = 'Neon Dawn'
	
SELECT o.UserEmail INTO #t3
FROM Own o, ValidSkins vs
WHERE
	o.ValidSkinID = vs.ValidSkinID AND
	vs.SkinName = 'White Noise'

SELECT *
FROM #t1, Users u
WHERE
	#t1.UserEmail = u.UserEmail AND
	#t1.UserEmail IN (SELECT #t2.UserEmail FROM #t2) AND
	#t1.UserEmail NOT IN (SELECT #t3.UserEmail FROM #t3)

DROP TABLE #t1
DROP TABLE #t2
DROP TABLE #t3

--4.Számítsd ki, 2024-ben naponta mekkora volt az összes sikeres tranzakció összértéke operátoronként! 
SELECT t.TransactionDate, o.OperatorName, SUM(t.TransactionValue) AS OsszErtek
FROM Transactions t, ValidSkins vs, Operators o
WHERE 
	t.ValidSkinID = vs.ValidSkinID AND 
	vs.OperatorName = o.OperatorName AND
	t.TransactionStatus = 'Succesfull' AND 
	YEAR(t.TransactionDate) = 2024
GROUP BY t.TransactionDate, o.OperatorName
ORDER BY t.TransactionDate, OsszErtek DESC


--5.Minden kategóriára add meg azt az itemet, amelyhez a legnagyobb értékű sikeres tranzakció tartozott! 
SELECT c.CategorieName, MAX(t.TransactionValue) AS MaxValue INTO #t1
FROM Categories c, Items i, ValidSkins vs, Transactions t
WHERE 
	c.CategorieName = i.CategorieName AND
	i.ItemName = vs.ItemName AND
	vs.ValidSkinID = t.ValidSkinID AND
	t.TransactionStatus = 'Succesfull'
GROUP BY c.CategorieName

SELECT c.CategorieName, i.ItemName, t.TransactionValue
FROM Categories c, Items i, ValidSkins vs, Transactions t, #t1
WHERE 
	c.CategorieName = i.CategorieName AND 
	i.ItemName = vs.ItemName AND 
	vs.ValidSkinID = t.ValidSkinID AND 
	t.TransactionStatus = 'Succesfull' AND 
	t.TransactionValue = #t1.MaxValue AND
	c.CategorieName = #t1.CategorieName
DROP TABLE #t1

--6. Listázd ki a felhasználók nevét és a sikeres tranzakcióik összértékét!
SELECT u.UserName, SUM(t.TransactionValue) AS OsszesSikeresTranzakcio
FROM Transactions t, Users u
WHERE 
	t.UserEmail = u.UserEmail AND
	t.TransactionStatus = 'Succesfull'
GROUP BY u.UserName
ORDER BY OsszesSikeresTranzakcio DESC

--7. Add meg azoknak az itemeknek a nevét, amelyekhez még soha nem tartozott sikeres tranzakció!  

SELECT VS.ItemName
FROM ValidSkins VS
WHERE VS.ValidSkinID NOT IN (
    SELECT T.ValidSkinID
    FROM Transactions T
    WHERE T.TransactionStatus = 'Succesfull'
);

--8. Felhasználónként listázd ki, melyik volt az utolsó megszerzett skinjük és hány nap telt el azóta!  

SELECT O.UserEmail,
       MAX(O.SkinAcquireDate) AS LastAcquireDate
INTO #T
FROM Own O, Users U
WHERE O.UserEmail = U.UserEmail
GROUP BY O.UserEmail;

SELECT U.UserName,
       VS.SkinName,
       DATEDIFF(DAY, T.LastAcquireDate, GETDATE()) AS LastAcquireDate
FROM Users U, Own O, ValidSkins VS, #T T
WHERE U.UserEmail = O.UserEmail
  AND O.ValidSkinID = VS.ValidSkinID
  AND T.UserEmail = U.UserEmail
  AND O.SkinAcquireDate = T.LastAcquireDate;

--9. Add meg azokat az operatorokat, akiknek az összes skinjük legalább egyszer szerepelt sikeres tranzakcióban!  

SELECT VS.OperatorName,
       COUNT(VS.ValidSkinID) AS OsszesSkin
INTO #AllSkins
FROM ValidSkins VS, Operators OP
WHERE VS.OperatorName = OP.OperatorName
GROUP BY VS.OperatorName;

SELECT VS.OperatorName,
       COUNT(DISTINCT VS.ValidSkinID) AS SikeresSkin
INTO #SuccessfulSkins
FROM ValidSkins VS, Operators OP, Transactions T
WHERE VS.OperatorName = OP.OperatorName
  AND VS.ValidSkinID = T.ValidSkinID
  AND T.TransactionStatus = 'Successful'
GROUP BY VS.OperatorName;

SELECT A.OperatorName
FROM #AllSkins A, #SuccessfulSkins S
WHERE A.OperatorName = S.OperatorName
  AND A.OsszesSkin = S.SikeresSkin;

--10. Listázd ki azokat a felhasználókat, akik legalább egy vásárlást és legalább egy eladást is végrehajtottak!  

SELECT DISTINCT T.UserEmail
INTO #Buyers
FROM Transactions T
WHERE TransactionType = 'Buying'
  AND T.TransactionStatus = 'Succesfull';

SELECT DISTINCT T.UserEmail
INTO #Sellers
FROM Transactions T
WHERE TransactionType = 'Selling'
  AND T.TransactionStatus = 'Succesfull';

SELECT U.UserName
FROM Users U, #Buyers B, #Sellers S
WHERE U.UserEmail = B.UserEmail
  AND U.UserEmail = S.UserEmail;
  
DROP TABLE #Buyers
DROP TABLE #Sellers

--11. Listázd ki az összes skin nevét, amelyekhez már volt legalább egy sikeres tranzakció.

SELECT SkinName
FROM Skins
WHERE SkinName IN (
    SELECT SkinName
    FROM ValidSkins
    WHERE ValidSkinID IN (
        SELECT ValidSkinID
        FROM Transactions
        WHERE TransactionStatus = 'Succesfull'
    )
);


--12. Számítsd ki, melyik évben volt a legtöbb sikeres tranzakció és mennyi volt az éves összérték!

SELECT 
    YEAR(TransactionDate) AS Year,
    COUNT(*) AS SuccessFulTransactions,
    SUM(TransactionValue) AS MaxWorth
FROM Transactions
WHERE TransactionStatus = 'Succesfull'
GROUP BY YEAR(TransactionDate)
ORDER BY COUNT(*) DESC;


--13. Listázd ki azokat a felhasználókat, akik olyan skint birtokolnak, amit ugyanakkor más felhasználó már eladott sikeresen! 

SELECT UserEmail
FROM Own
WHERE ValidSkinID IN (
    SELECT ValidSkinID
    FROM Transactions
    WHERE TransactionStatus = 'Succesfull'     
      AND TransactionType = 'Selling'          
)
AND UserEmail NOT IN (
    SELECT UserEmail
    FROM Transactions
    WHERE TransactionStatus = 'Succesfull'
      AND TransactionType = 'Selling'
);


--14. Listázd ki azoknak a felhasználóknak az email címét, akiknek még nincs egyetlen skinjük sem! 

SELECT UserEmail
FROM Users
WHERE UserEmail NOT IN (
    SELECT UserEmail
    FROM Own
);



--15. Add meg azon operatorok nevét, akikhez 2019 után jelent meg skin, és legalább egy felhasználó birtokolja is valamelyiket! 

Select DISTINCT VS.ValidSkinID into #Skins
From ValidSkins VS, Skins S
Where VS.SkinName = S.SkinName and
      YEAR(S.ReleaseDate) > 2019;

Select S.ValidSkinID into #Skins2
From Own O, #Skins S
Where O.ValidSkinID = S.ValidSkinID;

Select DISTINCT O.OperatorName
From ValidSkins VS, Operators O, #Skins2 S
Where VS.ValidSkinID = S.ValidSkinID and
      O.OperatorName = VS.OperatorName;



--16. Listázd ki a legdrágább tranzakciót minden felhasználónál, a tranzakció típusával és dátumával együtt!

Select U.UserEmail, MAX(T.TransactionValue) as MaxValue into #MaxTransactions
From Users U, Transactions T
Where U.UserEmail = T.UserEmail
Group By U.UserEmail;

Select U.UserEmail, T.TransactionValue, T.TransactionType, T.TransactionDate
From Users U, Transactions T, #MaxTransactions M
Where U.UserEmail = T.UserEmail and
      U.UserEmail = M.UserEmail and
      T.TransactionValue = M.MaxValue;


--17. Add meg azoknak a skineknek a nevét, amelyeket csak „Attacker” típusú operatorok használhatnak! 

Select DISTINCT VS.SkinName into #AttackerSkins
From ValidSkins VS, Operators O
Where VS.OperatorName = O.OperatorName and
      O.OperatorType = 'Attacker';

Select DISTINCT VS.SkinName into #NonAttackerSkins
From ValidSkins VS, Operators O
Where VS.OperatorName = O.OperatorName and
      O.OperatorType <> 'Attacker';

Select A.SkinName
From #AttackerSkins A
Where A.SkinName NOT IN (Select N.SkinName From #NonAttackerSkins N);


--18. Számítsd ki minden operator esetén, hogy a birtokolt skinek összesen hány különböző felhasználónál fordulnak elő! 

Select O.OperatorName, COUNT(DISTINCT Ow.UserEmail) as UserCount
From Operators O, ValidSkins VS, Own Ow
Where O.OperatorName = VS.OperatorName and
      VS.ValidSkinID = Ow.ValidSkinID
Group By O.OperatorName;



--19. Listázd ki azoknak a felhasználóknak a nevét, akik legalább három különböző operatorhoz tartozó skint birtokolnak! 

Select U.UserEmail, COUNT(DISTINCT VS.OperatorName) as OperatorCount into #UserOperatorCount
From Users U, Own Ow, ValidSkins VS
Where U.UserEmail = Ow.UserEmail and
      Ow.ValidSkinID = VS.ValidSkinID
Group By U.UserEmail;

Select U.UserName
From Users U, #UserOperatorCount UOC
Where U.UserEmail = UOC.UserEmail and
      UOC.OperatorCount >= 3;

--20. Add meg azoknak a felhasználóknak a nevét, akiknek van legalább egy 2023-ban megszerzett skinjük! 

Select DISTINCT U.UserName
From Users U, Own Ow
Where U.UserEmail = Ow.UserEmail and
      YEAR(Ow.SkinAcquireDate) = 2023;

