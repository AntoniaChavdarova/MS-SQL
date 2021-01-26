CREATE OR ALTER PROC usp_DepositMoney (@AccountId int , @MoneyAmount decimal (18,4))
AS
BEGIN TRANSACTION
IF @MoneyAmount < 0
BEGIN
  ROLLBACK;
  THROW 50001 ,'Invalid Money Amount!',  1 ; 
  END
   IF (SELECT COUNT(*)
        FROM Accounts
        WHERE Id = @AccountId) < 1
        BEGIN
            THROW 50006,'Invalid AccountID',1;
        END

UPDATE Accounts SET Balance = Balance + @MoneyAmount
WHERE Id = @AccountId
COMMIT
GO 

EXEC usp_DepositMoney 19 , 1000

CREATE OR ALTER PROC  usp_WithdrawMoney(@AccountId int, @MoneyAmount money)
AS
    BEGIN TRANSACTION
    IF (@MoneyAmount < 0)
        BEGIN
            THROW 50005,'Amount should be positive',1;
        END
    IF (SELECT COUNT(*)
        FROM Accounts
        WHERE Id = @AccountId) < 1
        BEGIN
            THROW 50006,'Invalid AccountID',1;
        END
UPDATE Accounts
SET Balance = Balance - @MoneyAmount
WHERE @AccountId = Id;
    COMMIT
GO


CREATE OR ALTER PROC usp_TransferMoney(@SenderId int , @ReceiverId int , @Amount decimal(18,4))
AS
BEGIN TRANSACTION 
EXEC usp_WithdrawMoney @SenderId , @Amount
EXEC usp_DepositMoney @ReceiverId , @Amount 
COMMIT
GO

SELECT * FROM Accounts
EXEC usp_TransferMoney 2 , 1 , 1000

SELECT * FROM Employees
SELECT * FROM Projects

CREATE OR ALTER PROC usp_AssignProject(@emloyeeId int , @projectID int) 
AS
BEGIN TRANSACTION
 IF (SELECT COUNT(*) FROM (
SELECT e.EmployeeID , p.ProjectID FROM Employees as e
JOIN EmployeesProjects as ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects as p ON ep.ProjectID = p.ProjectID
GROUP BY p.ProjectID , e.EmployeeID
) as e
WHERE e.EmployeeID = @emloyeeId
) >= 3 
BEGIN
ROLLBACK;
THROW 50003 , 'The employee has too many projects!'  , 1;
 END
 INSERT INTO EmployeesProjects
 VALUES (@emloyeeId, @projectID);
COMMIT


