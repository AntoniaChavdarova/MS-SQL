SELECT TOP 2 DepositGroup  FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize) 

SELECT DepositGroup , SUM(DepositAmount) as TotalSum FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC;

SELECT DepositGroup ,MagicWandCreator , MIN(DepositCharge) as MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup , MagicWandCreator
ORDER BY MagicWandCreator , DepositGroup;

SELECT  AgeGroup , Count(*) WizardCount 
FROM
   (SELECT  CASE 
				WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
				ELSE '[61+]'
                 END AS  AgeGroup   FROM WizzardDeposits
    ) AS AGERankingQuery
GROUP BY AgeGroup

SELECT FirstName FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest' 
GROUP By FirstName



SELECT * FROM WizzardDeposits