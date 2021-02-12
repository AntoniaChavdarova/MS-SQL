CREATE TABLE Planes (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL,
Seats INT NOT NULL,
[Range] INT NOT NULL
)

CREATE TABLE Flights (
Id INT PRIMARY KEY IDENTITY,
DepartureTime Datetime2 ,
ArrivalTime Datetime2,
Origin VARCHAR(50) NOT NULL,
Destination VARCHAR(50) NOT NULL,
PlaneId INT NOT NULL FOREIGN KEY REFERENCES Planes(Id)

)

CREATE TABLE Passengers(
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
Age INT NOT NULL,
[Address] VARCHAR(30) NOT NULL,
PassportId CHAR(11) NOT NULL 
)

CREATE TABLE LuggageTypes(
Id INT PRIMARY KEY IDENTITY,
[Type] VARCHAR(30) NOT NULL,
)

CREATE TABLE Luggages(
Id INT PRIMARY KEY IDENTITY,
LuggageTypeId INT NOT NULL FOREIGN KEY REFERENCES LuggageTypes(Id),
PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id)
)

CREATE TABLE Tickets(
Id INT PRIMARY KEY IDENTITY,
PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id),
FlightId INT  NOT NULL  FOREIGN KEY REFERENCES Flights(Id),
LuggageId INT  NOT NULL  FOREIGN KEY REFERENCES Luggages(Id),
Price DECIMAL(16,2) NOT NULL
)

UPDATE Tickets
SET Price = Price * 1.3
WHERE FlightId = ( SELECT Id FROM Flights
					WHERE Destination = 'Carlsbad') 


DELETE FROM Tickets
WHERE FlightId = (SELECT Id FROM Flights
WHERE Destination = 'Ayn Halagim')

DELETE FROM Flights
WHERE Destination = 'Ayn Halagim'

SELECT Id , [Name] , Seats , [Range] FROM Planes
WHERE [Name] LIKE ('%tr%')
ORDER BY Id , [Name] , Seats , [Range]

SELECT FlightId , SUM(Price) as TotalPrice FROM Flights as f
JOIN Tickets as t ON f.Id = t.FlightId
GROUP BY FlightId 
ORDER BY TotalPrice DESC , FlightId 
--7
SELECT Concat(FirstName , ' ' , LastName) as FullName , Origin , Destination FROM Flights as f
JOIN Tickets as t ON f.Id = t.FlightId
JOIN Passengers as p ON t.PassengerId = p.Id
ORDER BY FullName , Origin , Destination
--8
SELECT FirstName , LastName , Age FROM Passengers as p
LEFT JOIN Tickets as t ON p.Id = t.PassengerId
WHERE PassengerId IS NULL
ORDER BY Age DESC , FirstName , LastName
--9
SELECT  Concat(FirstName , ' ' , LastName) as FullName,pl.Name as [Plane Name], CONCAT(Origin ,' - ', Destination) as Trip,
[Type] as [Luggage Type]
FROM Flights as f
JOIN Planes as pl ON f.PlaneId = pl.Id
JOIN Tickets as t ON f.Id = t.FlightId
JOIN Luggages as l ON t.LuggageId = l.Id
JOIN LuggageTypes as lt ON l.LuggageTypeId = lt.Id
JOIN Passengers as p ON t.PassengerId = p.Id
ORDER BY FullName ,[Plane Name] ,  Origin , Destination , [Luggage Type]

--10
SELECT [Name] , Seats , COUNT(*) as Count FROM Planes as p
Left JOIN Flights as f ON p.Id = f.PlaneId
Left JOIN Tickets as t ON f.Id = t.FlightId
Left JOIN Passengers as pa ON t.PassengerId = pa.Id
GROUP BY  p.[Id] , [Name] , Seats
ORDER BY Count DESC , [Name] , Seats

CREATE FUNCTION udf_CalculateTickets(@origin NVARCHAR(max), @destination NVARCHAR(max), @peopleCount INT) 
RETURNS NVARCHAR(Max)
AS
BEGIN

IF @peopleCount <= 0 RETURN 'Invalid people count!';

DECLARE @flightId INT =	(SELECT Id FROM Flights
			WHERE Origin = @origin AND Destination = @destination)
IF @flightId IS NULL RETURN 'Invalid flight!';
ELSE 
DECLARE @price DECIMAL(16,2) = (
     SELECT Price FROM Flights as f
	 JOIN Tickets as t ON  f.Id = t.FlightId
	 WHERE FlightId = @flightId)
DECLARE @res DECIMAL(16,2) = @price * @peopleCount;
RETURN CONCAT('Total price ' , @res)

END

SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33)

SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', -1)

SELECT dbo.udf_CalculateTickets('Invalid','Rancabolang', 33)

