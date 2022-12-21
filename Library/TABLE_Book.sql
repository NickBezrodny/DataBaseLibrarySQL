CREATE TABLE Book
(
      ID INT PRIMARY KEY NONCLUSTERED NOT NULL,
	  [Name] NVARCHAR(50) NOT NULL,
	  Publication_year INT NOT NULL,
	  Page_number INT NOT NULL
);

ALTER TABLE Book
ADD CONSTRAINT cPublication_year
CHECK (Publication_year > 0);

ALTER TABLE Book
ADD CONSTRAINT cPage_number
CHECK (Page_number > 0);