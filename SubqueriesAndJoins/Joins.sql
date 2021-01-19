SELECT TOP 5 EmployeeID , JobTitle , e.AddressID , a.AddressText FROM Employees AS e
JOIN Addresses AS a 
ON e.AddressID = a.AddressID
ORDER BY e.AddressID

SELECT TOP 50 FirstName , LastName , t.Name as Town , a.AddressText FROM Employees AS e
  JOIN Addresses AS a 
  ON e.AddressID = a.AddressID
   JOIN Towns as t
   ON a.TownID = t.TownID
ORDER BY e.FirstName , e.LastName

SELECT e.EmployeeID , e.FirstName , e.LastName , d.Name as DepartmentName
FROM Employees as e 
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID AND d.Name = 'Sales'
ORDER BY e.EmployeeID

SELECT TOP 5 e.EmployeeID , e.FirstName , e.Salary, d.Name as DepartmentName 
FROM Employees as e 
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID AND e.Salary > 15000
ORDER BY d.DepartmentID

SELECT TOP 3 e.EmployeeID ,e.FirstName  FROM Employees AS e
  LEFT JOIN EmployeesProjects as ep
  ON e.EmployeeID = ep.EmployeeID 
  WHERE ep.ProjectID IS NULL

SELECT  e.FirstName , e.LastName,e.HireDate, d.Name as DeptName 
FROM Employees as e 
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID AND d.Name IN ('Sales' , 'Finance') AND e.HireDate > '1.1.1999'
ORDER BY HireDate

SELECT TOP 5 e.EmployeeID , e.FirstName , p.Name as ProjectName 
FROM Employees as e 
  JOIN EmployeesProjects as ep
  ON e.EmployeeID = ep.EmployeeID
 JOIN Projects as p
  ON ep.ProjectID = p.ProjectID AND p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

SELECT e.EmployeeID , e.FirstName ,
CASE
    WHEN DATEPART(year , p.StartDate) >= 2005 THEN 'NULL'
	ELSE p.Name
	END AS [ProjectName] 
FROM Employees as e 
  JOIN EmployeesProjects as ep
  ON e.EmployeeID = ep.EmployeeID 
 JOIN Projects as p
  ON ep.ProjectID = p.ProjectID 
WHERE e.EmployeeID = 24

SELECT m.EmployeeID , m.FirstName , e.EmployeeID as ManagerID, e.FirstName as ManagerName FROM Employees as e 
JOIN Employees as m
ON e.EmployeeID = m.ManagerID
WHERE m.ManagerID IN (3,7) 
ORDER BY m.EmployeeID 

SELECT TOP 50  e.EmployeeID , e.FirstName + ' ' + e.LastName as EmployeeName, m.FirstName + ' ' + m.LastName as ManagerName, d.Name as DepartmentName 
FROM Employees as e 
 JOIN Employees as m
 ON e.ManagerID = m.EmployeeID
   JOIN Departments as d
   ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID
 
SELECT 
MIN(a.AverageSalary) AS MinAverageSalary
FROM
(SELECT e.DepartmentID , AVG(e.Salary) AS AverageSalary
FROM Employees AS e
GROUP BY e.DepartmentID) as a
 
USE Geography


SELECT * FROM Countries
SELECT * FROM MountainsCountries

