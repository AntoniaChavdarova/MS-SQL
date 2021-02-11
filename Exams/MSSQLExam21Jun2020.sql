CREATE TABLE Cities (
Id INT PRIMARY KEY IDENTITY ,
[Name] NVARCHAR(20) NOT NULL,
CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
EmployeeCount INT NOT NULL ,
BaseRate DECIMAL(15,2) 
)

CREATE TABLE Rooms(
Id INT PRIMARY KEY IDENTITY,
Price  DECIMAL(15,2) NOT NULL,
[Type] NVARCHAR(20) NOT NULL,
Beds INT NOT NULL,
HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL
)

CREATE  TABLE Trips (
Id INT PRIMARY KEY IDENTITY,
RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
BookDate Date NOT NULL,
ArrivalDate Date NOT NULL,
ReturnDate Date Not NULL ,
CancelDate Date,
CHECK (BookDate < ArrivalDate),
Check(ArrivalDate < ReturnDate)
)


CREATE TABLE Accounts(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(20) ,
LastName NVARCHAR(50) NOT NULL,
CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id) ,
BirthDate Date NOT NULL ,
Email VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE AccountsTrips(
AccountId INT FOREIGN KEY REFERENCES Accounts(Id) NOT NULL,
TripId INT FOREIGN KEY REFERENCES Trips(Id) NOT NULL,
PRIMARY KEY (AccountId , TripId),
Luggage INT NOT NULL Check(Luggage >= 0)

)

INSERT INTO Accounts(FirstName , MiddleName , LastName , CityId , BirthDate , Email)
VALUES
('John',	'Smith'	,'Smith',	34,	'1975-07-21',	'j_smith@gmail.com'),
('Gosho',	NULL	,'Petrov',	11,	'1978-05-16'	,'g_petrov@gmail.com'),
('Ivan',	'Petrovich',	'Pavlov'	,59,	'1849-09-26',	'i_pavlov@softuni.bg'),
('Friedrich',	'Wilhelm',	'Nietzsche'	,2,	'1844-10-15',	'f_nietzsche@softuni.bg')

INSERT INTO Trips (RoomId , BookDate , ArrivalDate , ReturnDate , CancelDate)
VALUES
(101	,'2015-04-12',	'2015-04-14',	'2015-04-20',	'2015-02-02'),
(102	,'2015-07-07',	'2015-07-15',	'2015-07-22',	'2015-04-29'),
(103	,'2013-07-17',	'2013-07-23',	'2013-07-24',	NULL),
(104	,'2012-03-17',	'2012-03-31',	'2012-04-01	','2012-01-10'),
(109	,'2017-08-07',	'2017-08-28',	'2017-08-29',	NULL)

UPDATE Rooms
SET Price += Price * 0.14
 WHERE HotelId IN (5,7,9)

DELETE FROM AccountsTrips
  WHERE AccountId = 47

SELECT FirstName , LastName ,  Format(BirthDate , 'MM-dd-yyyy' ) AS BirthDate , c.Name AS Hometown , Email FROM Accounts AS a 
JOIN Cities AS c ON a.CityId = c.Id
WHERE Email LIKE ('e%') 
ORDER BY Hometown

SELECT c.Name as City, COUNT(*) AS Hotels FROM Cities as c
JOIN Hotels as h ON c.Id = h.CityId
GROUP BY c.Name
ORDER BY Hotels DESC , c.Name

SELECT a.Id , CONCAT(FirstName , ' ' , LastName) as FullName  ,MAX( DATEDIFF(DAY ,  ArrivalDate ,ReturnDate )) as LongestTrip ,MIN( DATEDIFF(DAY ,  ArrivalDate ,ReturnDate )) as ShortestTrip  FROM Accounts as a 
JOIN AccountsTrips as [at] ON a.Id = at.AccountId
JOIN Trips as t ON at.TripId = t.Id
Where a.MiddleName IS NULL AND t.CancelDate IS NULL
GROUP BY a.Id , a.FirstName , a.LastName
ORDER BY LongestTrip DESC , ShortestTrip 


SELECT TOP 10 CityId , c.Name ,c.CountryCode as Country, COUNT(a.Id) as Accounts FROM Accounts as a
JOIN Cities as c ON a.CityId = c.Id
GROUP BY CityId , c.Name , c.CountryCode
ORDER BY Accounts DESC


SELECT a.Id , a.Email , c.Name , COUNT(*) as Trips FROM AccountsTrips as at
JOIN Accounts as a ON a.Id = at.AccountId
JOIN Cities as c ON a.CityId = c.Id
JOIN Trips as t ON at.TripId = t.Id
JOIN Rooms as r ON t.RoomId = r.Id
JOIN Hotels as h ON r.HotelId = h.Id
where h.CityId = a.CityId
GROUP BY c.Name , a.Id , a.Email
ORDER BY Trips DESC , a.Id


SELECT
t.Id , FirstName + ' ' + ISNULL(MiddleName + ' ' ,'') +  LastName as [Full Name] ,c.Name as [FROM] ,ci.Name as [To] ,
CASE 
WHEN t.CancelDate IS NULL THEN CONVERT(NVARCHAR , DATEDIFF(Day , ArrivalDate , ReturnDate) ) +  ' days'
ELSE 'Canceled' END
AS Duration
FROM AccountsTrips as at
JOIN Accounts as a ON a.Id = at.AccountId
JOIN Cities as c ON a.CityId = c.Id
JOIN Trips as t ON at.TripId = t.Id
JOIN Rooms as r ON t.RoomId = r.Id
JOIN Hotels as h ON r.HotelId = h.Id
JOIN Cities as ci ON h.CityId = ci.Id
ORDER BY [Full Name] , t.Id


CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE , @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @id INT;
DECLARE @beds INT;
DECLARE @type NVARCHAR(20);
DECLARE @price DECIMAL(15,2);

     SELECT TOP 1 @id = r.Id , @type = r.Type ,@beds = r.Beds ,@price = (h.BaseRate + r.Price) * @People
	 FROM Hotels as h
	 JOIN Rooms as r ON h.Id = r.HotelId
	 JOIN Trips as t ON r.Id = t.RoomId
	 WHERE h.Id = @HotelId AND r.Beds >= @People
	 AND NOT EXISTS (
					 SELECT * FROM Trips t 
					 WHERE  t.RoomId = r.Id
					 AND CancelDate IS NULL AND @Date Between ArrivalDate AND ReturnDate)
ORDER BY (h.BaseRate + r.Price) * @People DESC

IF @id IS NULL RETURN 'No rooms available'
DECLARE @res NVARCHAR(MAX) = CONCAT('Room ',@id,': ',@type,' (' , @beds ,' beds) - $',@price)
RETURN @res
END

SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)

CREATE PROCEDURE usp_SwitchRoom(@TripId INT , @TargetRoomId INT )
AS
BEGIN
DECLARE @TripHotelId INT =  (SELECT HotelId FROM Trips as t
                             JOIN Rooms as r ON t.RoomId = r.Id
                             JOIN Hotels as h ON r.HotelId = h.Id
	                         WHERE t.Id = @TripId);

DECLARE @TargetRoomHotelId INT  = (SELECT HotelId FROM Rooms
                                    WHERE Id = @TargetRoomId )

IF @TripHotelId <> @TargetRoomHotelId  THROW 50002 , 'Target room is in another hotel!' , 1

DECLARE @NumOfAccounts INT = (SELECT COUNT(*) FROM AccountsTrips at
				              WHERE at.TripId = @TripId)
																							 
DECLARE @NumsOfBeds INT  = (SELECT Beds FROM Rooms
                            WHERE Id = @TargetRoomId )

IF @NumsOfBeds < @NumOfAccounts THROW 50003 , 'Not enough beds in target room!' , 4
UPDATE Trips SET RoomId = @TargetRoomId Where id = @TripId;
END

EXEC usp_SwitchRoom 10, 11
SELECT RoomId FROM Trips WHERE Id = 10
EXEC usp_SwitchRoom 10, 7
EXEC usp_SwitchRoom 10, 8



