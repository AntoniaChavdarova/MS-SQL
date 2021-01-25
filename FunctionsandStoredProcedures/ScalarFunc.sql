USE Minions

CREATE OR ALTER  FUNCTION udf_BreakDurationTime(@Date Datetime)
RETURNS int
AS
BEGIN
DECLARE @BreakTime INT;
SET @BreakTime = DATEDIFF(DAY, @Date , GETDATE());
RETURN @BreakTime
END

SELECT [Username] ,
dbo.udf_BreakDurationTime([LastLoginTime]) AS DaysBreak
FROM Users

USE SoftUni

CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10) 
AS
BEGIN
DECLARE @salaryLevel VARCHAR(10)
IF @salary < 30000 SET @salaryLevel =  'Low'
ELSE IF  @salary <= 50000 SET @salaryLevel =  'Average'
ELSE  SET @salaryLevel =  'High'
RETURN @salaryLevel
END

SELECT Salary,
dbo.ufn_GetSalaryLevel([Salary]) AS [Salary Level]
FROM Employees

CREATE PROCEDURE usp_EmployeesBySalaryLevel(@salaryLevel varchar(10)) 
AS 
BEGIN
SELECT FirstName AS [First Name] , LastName AS [Last Name]
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
END
EXEC usp_EmployeesBySalaryLevel [high]


CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters nvarchar(max), @word nvarchar(max))
RETURNS BIT
AS
BEGIN
	DECLARE @i INT = 1;
	WHILE @i <= LEN(@word)
	BEGIN
	   DECLARE @currChar CHAR = SUBSTRING(@word , @i , 1);
	   DECLARE @charIndex  INT = CHARINDEX(@currChar ,@setOfLetters);
	   IF(@charIndex = 0)
		  RETURN 0;
	   SET @i = @i +  1;

	 END
  RETURN 1
END; 

SELECT dbo.ufn_IsWordComprised('jkjrbkoj' , 'Rob') AS Result

USE Diablo

CREATE FUNCTION ufn_CashInUsersGames(@GameName nvarchar(30))
RETURNS TABLE
AS
RETURN SELECT (
  SELECT SUM(Cash) AS [SumCash] FROM (
		SELECT g.[Name] , ug.Cash ,
		ROW_NUMBER() OVER (PARTITION BY g.[Name] ORDER BY ug.Cash DESC) as [RowNum]
		FROM UsersGames as ug
		JOIN Games as g ON ug.GameId = g.Id
		WHERE g.[Name] = @GameName
		) as [RowNumQuerry]
WHERE [RowNum] % 2 <> 0
) as [SumCash]

SELECT * FROM ufn_CashInUsersGames('Love in a mist')






