SELECT FirstName FROM Employees
WHERE DepartmentID IN (3,10) AND  DATEPART(year , HireDate) BETWEEN 1995 AND 2005

CREATE VIEW V_EmployeesHiredAfter2000 
AS
SELECT FirstName , LastName FROM Employees
WHERE DATEPART(year , HireDate) > 2000

USE Diablo
SELECT TOP 50 [Name] , FORMAT(Start, 'yyyy-MM-dd') AS [Start] FROM Games
WHERE DATEPART(year , [Start]) IN (2011 , 2012)
ORDER BY [Start] , [Name]

SELECT [Name] ,
 CASE
    WHEN DATEPART(HOUR , [Start]) BETWEEN 0 AND 11 THEN 'Morning'
	WHEN DATEPART(HOUR , [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
  END AS [Part of the Day],
 CASE
    WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration BEtWEEN 4 AND 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	ELSE 'Extra Long'
  END AS [Duration]
FROM Games
ORDER BY [Name] , Duration , [Part of the Day]