SELECT FirstName + '.' + LastName + '@softuni.bg' AS 'Full Email Address' 
FROM Employees

SELECT DISTINCT Salary FROM Employees

SELECT * FROM Employees
WHERE JobTitle LIKE 'Sales Representative'

SELECT FirstName , LastName , JobTitle FROM Employees
WHERE Salary   BETWEEN  20000 AND 30000

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS  'Full Name' 
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600);

SELECT FirstName , LastName 
FROM Employees
WHERE ManagerID IS Null

SELECT FirstName , LastName , Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

SELECT TOP 5 FirstName , LastName 
FROM Employees
ORDER BY Salary DESC

SELECT  FirstName , LastName 
FROM Employees
WHERE DepartmentID != 4

SELECT  *
FROM Employees
ORDER BY Salary DESC , FirstName , LastName DESC , MiddleName;

CREATE VIEW V_EmployeesSalaries 
AS  
(SELECT FirstName , LastName , Salary
FROM Employees)

CREATE VIEW V_EmployeeNameJobTitle  
AS  
SELECT 
FirstName + ' ' +  ISNULL(MiddleName , '') + ' ' +  LastName AS 'Full Name' ,
JobTitle
FROM Employees 

SELECT DISTINCT JobTitle FROM Employees

SELECT TOP 10 ProjectID, [Name] , [Description] , StartDate , ENdDAte
FROM Projects
ORDER BY StartDate , [Name]

SELECT TOP 7 FirstName , LastName , HireDate
FROM Employees
Order By HireDate DESC

USE Geography
SELECT TOP 30 CountryName , [Population]
FROM Countries
WHERE ContinentCode LIKE 'EU'
ORDER BY Population DESC , CountryName

SELECT CountryName , CountryCode, 
  CASE 
       WHEN CurrencyCode = 'EUR' THEN 'Euro'
	   ELSE 'Not Euro'
	   END AS [Currency]
FROM Countries
ORDER BY CountryName ASC



