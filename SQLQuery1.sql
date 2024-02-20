CREATE DATABASE Kitabxana
USE Kitabxana

CREATE TABLE Authors
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL
)

CREATE TABLE Books
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(100) CHECK(LEN(NAME)>=2),
AuthorId INT FOREIGN KEY REFERENCES Authors(Id),
PageCount INT CHECK(PageCount>= 10)
)

INSERT INTO Authors
VALUES
('Fidan','Heydarova'),
('Jeikhun','Jalilov'),
('Nazrin','Mammadova'),
('Lamiya','Guliyeva'),
('Tahir','Yagubov')

INSERT INTO Books
VALUES
('Twilight',3,140),
('Me Before You',1,55),
('Matilda',4,326),
('Warriors',2,70),
('The Lost Symbol',5,95)

--Books ve Authors table-larınız olsun
-- (one to many realtion) Id,Name,PageCount ve
-- AuthorFullName columnlarının valuelarını
--qaytaran bir view yaradın

CREATE VIEW VW_Books AS
SELECT B.Id,B.Name,B.PageCount,CONCAT(A.Name,' ',A.Surname) AS AuthorFullName FROM Books AS B
JOIN Authors AS A ON B.AuthorId = A.Id

SELECT * FROM VW_Books


--Göndərilmiş axtarış dəyərinə görə həmin axtarış
-- dəyəri name və ya authorFullName-lərində olan Book-ları
-- Id,Name,PageCount,AuthorFullName columnları şəklində
-- göstərən procedure yazın

CREATE PROCEDURE Value_Search
@SEARCH NVARCHAR(30)
AS
SELECT * FROM VW_Books 
WHERE Name LIKE CONCAT('%', @SEARCH, '%') OR AuthorFullName LIKE CONCAT('%', @SEARCH, '%')

EXEC Value_Search 'f'


--Book tabledaki verilmiş id-li datanın qiymıətini verilmiş yeni qiymətə update edən procedure yazın.(Giymet deyeri yoxdur kitab sehifesine gore yazdim :/)
CREATE PROCEDURE UPDATE_BOOKS
@BOOKID INT,
@UPDATEPAGECOUNT INT
AS UPDATE Books SET PageCount = @UPDATEPAGECOUNT WHERE Books.Id=@BOOKID

 EXEC UPDATE_BOOKS 4,170



-- Authors-ları Id,FullName,BooksCount,MaxPageCount şəklində qaytaran view yaradırsınız
--Id-author id-si
--FullName - Name ve Surname birləşməsi
--BooksCount - Həmin authorun əlaqəli olduğu kitabların sayı
--MaxPageCount - həmin authorun əlaqəli olduğu kitabların içərisindəki max pagecount dəyəri

CREATE VIEW VW_Authors
AS
SELECT A.Id,CONCAT(A.Name,' ' ,A.Surname) AS FullName,COUNT(B.Id) AS BooksCount, MAX(B.PageCount) AS MaxPageCount
FROM Authors AS A
JOIN Books AS B ON A.Id = B.AuthorId
GROUP BY A.Id, CONCAT(A.Name, ' ', A.Surname)

SELECT * FROM VW_Authors