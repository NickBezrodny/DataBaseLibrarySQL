CREATE VIEW vIssuanceReaderBook
AS
SELECT R.Last_name, R.First_name, B.[Name], I.Date_issue, 
	   ISNULL(CAST(I.Date_expiration AS VARCHAR(10)), N'Не сдано') AS Date_expiration
FROM Book AS B
INNER JOIN Issuance AS I
ON B.ID = I.ID_Book
INNER JOIN Reader AS R
ON I.ID_Reader = R.ID;

SELECT *
FROM vIssuanceReaderBook;

DROP VIEW vIssuanceReaderBook;