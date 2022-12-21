--  акие книги самые молодые/старые по изданию?
SELECT [Name], Publication_year
FROM Book
WHERE Publication_year = 
	(
		SELECT MIN(Publication_year)
		FROM Book
	);

SELECT [Name], Publication_year
FROM Book
WHERE Publication_year = 
	(
		SELECT MAX(Publication_year)
		FROM Book
	);

-- ѕ–ќ¬≈– ј
SELECT *
FROM Book
ORDER BY Publication_year ASC;

-- 3 самых попул¤рных книги по выдаче
SELECT TOP 3 B.[Name]
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID= I.ID_Book
GROUP BY B.Name
ORDER BY COUNT(I.ID_Book) DESC;

-- —ама¤(-ые) попул¤рна¤(-ые) книга(-и) по выдаче
SELECT B.[Name], COUNT(B.ID) AS [Count of books]
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
GROUP BY I.ID_Book,B.[Name]
HAVING COUNT(B.ID) >= ALL
	(
		SELECT COUNT(B.ID)
		FROM Book AS B
		INNER JOIN Issuance AS I
		ON B.ID = I.ID_Book
		GROUP BY I.ID_Book
	);

--  ниги, которые ни разу не брали читатели
SELECT B.Name
FROM Book AS B
LEFT JOIN Issuance AS I
ON B.ID= I.ID_Book
WHERE I.ID_Book IS NULL;

--  то из читателей ни разу не брал книгу?
SELECT R.Last_name, R.First_name
FROM Reader AS R
LEFT JOIN Issuance AS I
ON R.ID= I.ID_Reader
WHERE I.ID_Reader IS NULL;


-- ќтсортировать книги по количеству страниц (от большего к меньшему)
SELECT [Name], Page_number
FROM Book
ORDER BY Page_number DESC;

--  то и какие книги сейчас читает?
SELECT R.Last_name, R.First_name, B.[Name] AS [Name of book]
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
INNER JOIN Reader AS R
ON R.ID = I.ID_Reader
WHERE I.Date_expiration IS NULL;

--ѕоказать всех читателей по количеству прочитанных книг и страниц за всЄ врем¤
SELECT R.Last_name, R.First_name, 
	   ISNULL(CAST(SUM(B.Page_number) AS int), 0) AS [Count of pages],
	   COUNT(I.ID_Reader) AS [Count of books]
FROM Reader AS R
LEFT JOIN Issuance AS I
ON R.ID = I.ID_Reader
LEFT JOIN Book AS B
ON I.ID_Book = B.ID
GROUP BY I.ID_Reader, R.Last_name, R.First_name
ORDER BY SUM(B.Page_number) DESC;

--  ниг какого автора больше всего находитс¤ в библиотеке?
SELECT A.Last_name, A.First_name, COUNT(B.ID) AS [Count of books]
FROM Book AS B
INNER JOIN Bibliography AS I
ON B.ID = I.ID_Book
INNER JOIN Author AS A
ON A.ID = I.ID_Author
GROUP BY I.ID_Author, A.Last_name, A.First_name
HAVING COUNT(B.ID) >= ALL
	(
		SELECT COUNT(B.ID)
		FROM Book AS B
		INNER JOIN Bibliography AS I
		ON B.ID = I.ID_Book
		GROUP BY I.ID_Author
	);

-- Ќайти все просроченные книги, которые были вз¤ты ранее 2022 года и не сданы обратно, а также
-- контактные данные читател¤(-ей), который (-ые) не сдал(-и) книгу(-и).
SELECT R.Last_name, R.First_name, R.Phone_number, B.[Name] AS [Name of book], I.Date_issue
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
INNER JOIN Reader AS R
ON R.ID = I.ID_Reader
WHERE I.Date_expiration IS NULL AND I.Date_issue < '2022-01-01';

--  ака¤ книга была сдана последней и когда?
SELECT B.[Name] AS [Name of book], I.Date_expiration AS [Date of returning]
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
WHERE I.Date_expiration>= ALL
	(
		SELECT I.Date_expiration
		FROM Issuance AS I
		WHERE I.Date_expiration IS NOT NULL
	);

--  ниги с датой сдачи, отсортированные в пор¤дке убывани¤. 
SELECT B.[Name] AS [Name of book], I.Date_expiration AS [Date of returning]
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
WHERE I.Date_expiration IS NOT NULL
ORDER BY I.Date_expiration DESC;

-- ниги какого автора больше всего брали читатели за всЄ врем¤?
SELECT A.Last_name, A.First_name, COUNT(I.ID_Book) AS [Count]
FROM Author AS A
INNER JOIN Bibliography AS B
ON A.ID = B.ID_Author
INNER JOIN Issuance AS I
ON B.ID_Book = I.ID_Book
GROUP BY A.Last_name, A.First_name
HAVING COUNT(I.ID_Book) >= ALL
	(
		SELECT COUNT(I.ID_Book)
		FROM Issuance AS I
		INNER JOIN Bibliography AS B
		ON I.ID_Book = B.ID_Book
		GROUP BY B.ID_Author
	);

--  то и какую книгу брал за 2022 год?
SELECT B.[Name] AS [Name of book], R.Last_name, R.First_name
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
INNER JOIN Reader AS R
ON I.ID_Reader = R.ID
WHERE I.Date_issue LIKE '%2022%';
 