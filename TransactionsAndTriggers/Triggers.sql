CREATE  TABLE Logs(
LogId INT PRIMARY KEY IDENTITY,
AccountId INT FOREIGN KEY REFERENCES Accounts(Id) ,
OldSum money NOT NULL,
NewSum money NOT NULL
) 


CREATE OR ALTER  TRIGGER  tr_AddToLogsWhenAccountUpdate 
ON Accounts FOR UPDATE
AS
INSERT INTO Logs( AccountId, OldSum, NewSum)
SELECT  i.AccountHolderId , d.Balance , i.Balance 
FROM inserted as i
JOIN  deleted as d ON i.Id = d.Id
GO

CREATE  TABLE NotificationEmails(
Id INT PRIMARY KEY IDENTITY,
Recipient INT FOREIGN KEY REFERENCES Accounts(Id) ,
[Subject] nvarchar(max) ,
Body nvarchar(max) 
)

CREATE OR ALTER TRIGGER tr_AddToNotificationEmailOnLogsUpdate
    ON Logs
    FOR INSERT
    AS
    INSERT INTO NotificationEmails(Recipient, Subject, Body)
    SELECT i.AccountID,
           'Balance change for account: ' + CAST(i.AccountID AS nvarchar(20)),
           'On ' + CONVERT(nvarchar(20), GETDATE(), 100) + ' your balance was changed from ' +
           CAST(i.OldSum AS nvarchar(20)) + ' to ' + CAST(i.NewSum AS nvarchar(20)) + '.'
    FROM inserted AS i

   GO

SELECT * FROM Accounts

UPDATE Accounts
SET Balance += 300
WHERE Id = 2

USE SoftUni

CREATE TABLE Deleted_Employees(
EmployeeId int PRIMARY KEY IDENTITY,
FirstName nvarchar(50) NOT NULL,
LastName nvarchar(50) NOT NULL,
MiddleName nvarchar(50),
JobTitle nvarchar(50),
DepartmentId int,
Salary money
) 

DROP TABLE Deleted_Employees

CREATE OR ALTER TRIGGER tr_DeletedEmployees
ON Employees
INSTEAD OF DELETE
AS
INSERT INTO Deleted_Employees
SELECT  d.FirstName , d.LastName, d.MiddleName, d.JobTitle, d.DepartmentId, d.Salary
FROM deleted as d
GO






