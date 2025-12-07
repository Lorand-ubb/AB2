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


SELECT * FROM Transactions
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

--7.Add meg azoknak az itemeknek a nevét, amelyekhez még soha nem tartozott sikeres tranzakció! 

--8.Felhasználónként listázd ki, melyik volt az utolsó megszerzett skinjük és hány nap telt el azóta! 

--9.Add meg azokat az operatorokat, akiknek az összes skinjük legalább egyszer szerepelt sikeres tranzakcióban! 

--10.Listázd ki azokat a felhasználókat, akik legalább egy vásárlást és legalább egy eladást is végrehajtottak! 

--11.Add meg, melyik skin hozta a legnagyobb összbevételt (összes sikeres tranzakció értékének összege) az adatbázisban! 

--12.Számítsd ki, melyik évben volt a legtöbb sikeres tranzakció és mennyi volt az éves összérték! 

--13.Listázd ki azokat a felhasználókat, akik olyan skint birtokolnak, amit ugyanakkor más felhasználó már eladott sikeresen! 

--14.Keresd meg, melyik kategóriában van a legtöbb különböző item, és írd ki a kategória nevét és az itemek számát! 

--15.Add meg azon operatorok nevét, akikhez 2019 után jelent meg skin, és legalább egy felhasználó birtokolja is valamelyiket! 

--16.Listázd ki a legdrágább tranzakciót minden felhasználónál, a tranzakció típusával és dátumával együtt! 

--17.Add meg azoknak a skineknek a nevét, amelyeket csak „Attacker” típusú operatorok használhatnak! 

--18.Számítsd ki minden operator esetén, hogy a birtokolt skinek összesen hány különböző felhasználónál fordulnak elő! 

--19.Listázd ki azoknak a felhasználóknak a nevét, akik legalább három különböző operatorhoz tartozó skint birtokolnak! 

--20.Készíts egy listát a felhasználókról, ahol látszik, hogy hány sikeres, folyamatban lévő és törölt tranzakciójuk volt! 
