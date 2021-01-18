SELECT FirstName , LastName FROM Employees
WHERE FirstName LIKE 'SA%'

SELECT FirstName , LastName FROM Employees
WHERE LastName LIKE '%ei%'


SELECT FirstName , LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

SELECT * FROM Towns
WHERE LEFT([Name] , 1) IN ('M' , 'K' , 'B' , 'E')
ORDER BY [NAME]

SELECT TownID,Name
FROM Towns
WHERE LEFT(Name, 1) NOT in ('R', 'B', 'D')
ORDER BY Name

SELECT [Name] FROM Towns
WHERE LEN([Name]) IN (5,6)
ORDER BY [NAME]

SELECT FirstName , LastName FROM Employees
WHERE LEN(LastName) = 5

USE Geography
SELECT CountryName , IsoCode 
FROM Countries
WHERE CountryName LIKE ('%A%A%A%')
ORDER BY IsoCode


SELECT p.PeakName , r.RiverName  ,LOWER(CONCAT(p.PeakName , SUBSTRING(r.RiverName , 2 , LEN(r.RiverName) - 1))) AS [Mix] 
FROM Peaks AS p , Rivers AS r
WHERE RIGHT(p.PeakName , 1) = LEFT(r.RiverName , 1)
ORDER BY Mix

USE DIABLO
SELECT Username ,  SUBSTRING(Email,
                 CHARINDEX('@', Email) + 1,
                 LEN(Email) - CHARINDEX('@', Email) + 1)
           AS [Email Provider]

FROM Users
ORDER BY [Email Provider], Username

SELECT Username,
       IpAddress
           AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username
