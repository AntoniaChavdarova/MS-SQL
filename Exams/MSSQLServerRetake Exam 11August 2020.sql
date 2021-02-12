
CREATE TABLE Countries(
Id INT Primary KEY IDENTITY,
[Name] NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Customers(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(25)  NOT NULL,
LastName NVARCHAR(25)  NOT NULL,
Gender CHAR(1) CHECK(Gender = 'M' OR Gender = 'F') NOT NULL,
Age INT NOT NULL,
PhoneNumber CHAR(10) CHECK(LEN(PhoneNumber) = 10) NOT NULL,
CountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL
)

CREATE TABLE Products(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25)  NOT NULL UNIQUE,
[Description] NVARCHAR(250) NOT NULL,
Recipe NVARCHAR(max) NOT NULL,
Price DECIMAL(16,2) CHECK(Price > 0) NOT NULL
)

CREATE TABLE Feedbacks(
Id INT PRIMARY KEY IDENTITY ,
[Description] NVARCHAR(255) ,
Rate DECIMAL(16,2) CHECK(Rate > 0 AND Rate < 10) NOT NULL,
ProductId INT FOREIGN KEY REFERENCES Products(Id) NOT NULL,
CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL
)

CREATE TABLE Distributors(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) UNIQUE NOT NULL,
AddressText NVARCHAR(30) NOT NULL,
Summary NVARCHAR(200) NOT NULL,
CountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL
)

CREATE TABLE Ingredients(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
[Description] NVARCHAR(200) NOT NULL,
OriginCountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL,
DistributorId INT FOREIGN KEY REFERENCES Distributors(Id) NOT NULL
)
CREATE TABLE ProductsIngredients(
ProductId INT FOREIGN KEY REFERENCES Products(Id),
IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id),
PRIMARY KEY (ProductId , IngredientId)
)


INSERT INTO Distributors ([Name],	CountryId	,AddressText,	Summary)
VALUES
('Deloitte & Touche', 2 ,'6 Arch St #9757',	'Customizable neutral traveling'),
('Congress Title', 13 ,'58 Hancock St',	'Customer loyalty'),
('Kitchen People', 1,	'3 E 31st St #77',	'Triple-buffered stable delivery'),
('General Color Co Inc', 21,'	6185 Bohn St #72',	'Focus group'),
('Beck Corporation',	23,'	21 E 64th Ave	','Quality-focused 4th generation hardware')

INSERT INTO Customers(FirstName	,LastName,	Age,	Gender,	PhoneNumber,	CountryId)
VALUES 
('Francoise',	'Rautenstrauch',	15,	'M'	,'0195698399',	5),
('Kendra',	'Loud',	22,	'F',	'0063631526',	11),
('Lourdes',	'Bauswell',	50	,'M',	'0139037043',	8),
('Hannah',	'Edmison',	18,	'F',	'0043343686',	1),
('Tom'	,'Loeza',	31,	'M',	'0144876096',	23),
('Queenie',	'Kramarczyk',	30	,'F',	'0064215793',	29),
('Hiu',	'Portaro',	25,	'M',	'0068277755',	16),
('Josefa',	'Opitz',	43,	'F',	'0197887645',	17)

--Update the table Ingredients and change the DistributorId of "Bay Leaf", "Paprika" and "Poppy"
--to 35. Change the OriginCountryId to 14 of all ingredients with OriginCountryId equal to 8.

UPDATE Ingredients
SET DistributorId = 35
WHERE [Name] = 'Bay Leaf' OR [Name] = 'Paprika' OR [Name] = 'Poppy'

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8

--Delete all Feedbacks which relate to Customer with Id 14 or to Product with Id 5.


DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5 

SELECT [Name] , Price , Description FROM Products
ORDER BY Price DESC , [Name]

SELECT ProductId , Rate , Description , CustomerId , Age , Gender FROM Customers as c
JOIN Feedbacks as f ON c.Id = f.CustomerId
WHERE f.Rate < 5
ORDER BY ProductId DESC , Rate

SELECT CONCAT(FirstName , ' ' , LastName) as CustomerName , PhoneNumber , Gender FROM Customers as c
LEFt JOIN Feedbacks as f ON c.Id = f.CustomerId
WHERE f.CustomerId IS NULL
ORDER BY CustomerId

--Select customers that are either at least 21 old and contain
--“an” in their first name or their phone number ends with “38” and are not from Greece. 
--Order by first name (ascending), then by age(descending).

SELECT FirstName , Age , PhoneNumber FROM Customers
WHERE Age >= 21 AND FirstName LIKE ('%an%') OR PhoneNumber LIKE ('%38') AND CountryId <> 31
ORDER BY FirstName , Age DESC

--Select all distributors which distribute ingredients used in the making process of all products 
--having average rate between 5 and 8 (inclusive)
--. Order by distributor name, ingredient name and product name all ascending.
SELECT DistributorName , IngredientName , ProductName  , AverageRate FROM (
				SELECT d.Name as DistributorName ,
				i.Name as IngredientName,
				p.Name as ProductName , AVG(Rate) as AverageRate FROM Distributors as d 
				 JOIN Ingredients as i ON d.Id = i.DistributorId
				 JOIN ProductsIngredients as pi ON i.Id = pi.IngredientId
				 JOIN Products as p ON pi.ProductId = p.Id
				 JOIN Feedbacks as f ON p.Id = f.ProductId
				GROUP BY  d.Name , p.Name, i.Name ) as RANK
WHERE AverageRate BETWEEN 5.0 AND 8.0
ORDER BY DistributorName, IngredientName,ProductName


--Select all countries with their most active distributor 
--(the one with the greatest number of ingredients). 
--If there are several distributors with most ingredients delivered, list them all.
--Order by country name then by distributor name.


select rankQuery.Name, rankQuery.DistributorName
from (
select c.Name, d.Name as DistributorName,
       dense_rank() over (partition by c.Name order by count(i.Id) desc) as rank
from Countries as c
      join  Distributors D on c.Id = D.CountryId
     left join Ingredients I on D.Id = I.DistributorId
group by  c.Name, d.Name
) as rankQuery
where rankQuery.rank=1
 ORDER BY rankQuery.Name, rankQuery.DistributorName

CREATE VIEW v_UserWithCountries AS
SELECT CONCAT(FirstName , ' ' , LastName) as CustomerName ,
Age , Gender , [Name] AS CountryName
FROM Customers as c
JOIN Countries as co ON c.CountryId = co.Id

SELECT TOP 5 *
  FROM v_UserWithCountries
 ORDER BY Age






