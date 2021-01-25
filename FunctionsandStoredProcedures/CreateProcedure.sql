CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName AS 'First Name', LastName AS 'Last Name' 
FROM Employees
WHERE Salary > 35000;

EXEC usp_GetEmployeesSalaryAbove35000

CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber
(@paramSalary decimal(18,4))
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
FROM Employees
WHERE Salary >= @paramSalary

EXEC usp_GetEmployeesSalaryAboveNumber 45000 

CREATE  OR ALTER PROC usp_GetTownsStartingWith
(@townName nvarchar(5))
AS
SELECT [Name] FROM Towns
WHERE [Name] LIKE @townName + '%'

EXEC usp_GetTownsStartingWith B

SELECT * FROM Employees
SELECT * FROM Towns

CREATE PROC usp_GetEmployeesFromTown(@TownName nvarchar(35))
AS
BEGIN
SELECT e.FirstName as [First Name] , e.LastName as [Last Name] FROM Employees AS e
JOIN Addresses as a ON e.AddressID = a.AddressID
JOIN Towns as t ON a.TownID = t.TownID
WHERE @TownName = t.Name
END

EXEC usp_GetEmployeesFromTown Sofia 

CREATE PROC usp_DeleteEmployeesFromDepartment(@departmentId INT)
AS
BEGIN
    --first delete all records from EmployeesProjects where EmployeeId is in to-be-deleted IDs

    DELETE
    FROM EmployeesProjects
    WHERE EmployeeID IN (SELECT EmployeeID
                         FROM Employees
                         WHERE DepartmentID = @departmentId);
    --set managerId to null where Manager is an Employee who is going to be deleted

    UPDATE Employees
    SET ManagerID=NULL
    WHERE ManagerID IN (SELECT EmployeeID
                        FROM Employees
                        WHERE DepartmentID = @departmentId);
--Alter column ManagerId in Departments table and make it nullable

    ALTER TABLE Departments
        ALTER COLUMN ManagerID int;

    UPDATE Departments
    SET ManagerID = NULL
    WHERE ManagerID IN (SELECT EmployeeID
                        FROM Employees
                        WHERE DepartmentID = @departmentId);

    --delete employees from departments

    DELETE FROM Employees
    WHERE DepartmentID=@departmentId

    DELETE FROM Departments
    where DepartmentID=@departmentId

    SELECT count(*)
    FROM Employees
    where DepartmentID=@departmentId

END

USE Bank

CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@Money Decimal(18,4))
AS
SELECT ah.FirstName as [First Name] , ah.LastName as [Last Name] 
FROM AccountHolders as ah
JOIN Accounts as a ON ah.Id = a.AccountHolderId
GROUP BY ah.FirstName , ah.LastName
HAVING SUM(a.Balance) > @Money
ORDER BY ah.FirstName , ah.LastName

Exec usp_GetHoldersWithBalanceHigherThan 1000

SELECT * FROM AccountHolders
SELECT * FROM Accounts