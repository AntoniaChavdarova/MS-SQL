USE Gringotts
SELECT * FROM WizzardDeposits

SELECT DepositGroup ,IsDepositExpired , AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985' 
GROUP BY DepositGroup , IsDepositExpired
ORDER BY DepositGroup DESC , IsDepositExpired;

SELECT SUM(DIFFERENCE)
FROM(
		SELECT FirstName as [Host Wizard] ,
		DepositAmount as [Host Wizard Deposit],  
		LEAD(FirstName) OVER(Order BY Id ASC) AS [Guest Wizard],
		LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Guest Wizard Depozit],
		DepositAmount - LEAD(DepositAmount) OVER(ORDER BY Id ASC) as [Difference]
		FROM WizzardDeposits 
) AS [LeadQuerry]
WHERE [Guest Wizard] IS NOT NULL;

USE SoftUni
SELECT DepartmentID , SUM(Salary) as [TotalSalary] FROM Employees
GROUP BY DepartmentID;

SELECT DepartmentID , Min(Salary) as [MinimumSalary] FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate > '01/01/2000'
GROUP BY DepartmentID;

SELECT  * INTO EmployeesWithHighestSalary FROM Employees
WHERE Salary > 30000

DELETE FROM EmployeesWithHighestSalary
WHERE ManagerID = 42

UPDATE EmployeesWithHighestSalary
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID , AVG(Salary) FROM EmployeesWithHighestSalary
GROUP BY DepartmentID

SELECT t.DepartmentID , t.MaxSalary FROM 
	(SELECT DepartmentID , MAX(Salary) as [MaxSalary] FROM Employees
	GROUP BY DepartmentID
	) AS t
WHERE t.MaxSalary NOT BETWEEN 30000 AND 70000;

SELECT t.DepartmentID , t.Salary as [ThirdHighestSalary] FROM
(
	SELECT DepartmentID , Salary, 
	DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) as [SalaryRange]
	FROM Employees
	GROUP BY DepartmentID , Salary
	) as t
WHERE t.SalaryRange = 3;

SELECT TOP (10) e1.FirstName , e1.LastName , e1.DepartmentID  
FROM Employees as e1
WHERE e1.Salary > (
   
			  SELECT  AVG(Salary) as [AverageSalary]
			  FROM Employees e2
			  WHERE  e2.DepartmentID = e1.DepartmentID
			  GROUP BY DepartmentID
			   ) 
ORDER BY DepartmentID;
 



