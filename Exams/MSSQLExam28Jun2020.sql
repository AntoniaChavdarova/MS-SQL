SELECT Id, FORMAT(JourneyStart, 'dd/MM/yyyy') AS JourneyStart ,
       FORMAT(JourneyEnd, 'dd/MM/yyyy') AS JourneyEnd
FROM Journeys
WHERE Purpose='Military'
ORDER BY JourneyStart

SELECT c.Id as id, CONCAT(c.FirstName , ' ' , c.LastName) as full_name
FROM TravelCards as tc
JOIN Colonists as c
ON tc.ColonistId = c.Id
WHERE tc.JobDuringJourney = 'Pilot'
ORDER BY id

SELECT COUNT(*)
FROM TravelCards as tc
JOIN Journeys as j ON tc.JourneyId = j.Id
JOIN Colonists as c 
ON tc.ColonistId = c.Id
WHERE j.Purpose = 'Technical'

SELECT  s.Name , s.Manufacturer
FROM TravelCards as tc
JOIN Journeys as j ON tc.JourneyId = j.Id
JOIN Spaceships as s ON j.SpaceshipId = s.Id
JOIN Colonists as c
ON tc.ColonistId = c.Id
WHERE tc.JobDuringJourney = 'Pilot' AND DATEDIFF(year ,BirthDate , '2019 - 01 - 01') < 30
ORDER BY s.Name

SELECT p.Name ,Count(j.Id) as JourneysCount FROM Journeys as j
JOIN Spaceports as s ON j.DestinationSpaceportId = s.Id
JOIN Planets as p ON s.PlanetId = p.Id
GROUP BY p.Name
ORDER BY JourneysCount DESC , p.Name 


SELECT *
FROM
		(SELECT tc.JobDuringJourney , CONCAT (c.FirstName , ' ' , c.LastName) as FullName ,
		DENSE_RANK() OVER (PARTITION BY tc.JobDuringJourney ORDER BY c.BirthDate ) AS JobRank
		FROM Colonists as c 
		JOIN TravelCards as tc ON c.Id = tc.ColonistId ) 
 as RANKQUERY
WHERE JobRank = 2;


CREATE FUNCTION udf_GetColonistsCount(@planetName VARCHAR(30))
RETURNS INT
AS
BEGIN
DECLARE @result INT = (
SELECT COUNT(*) FROM Colonists as c
JOIN TravelCards as tc ON c.Id = tc.ColonistId
JOIN Journeys as j ON tc.JourneyId = j.Id
JOIN Spaceports as s ON j.DestinationSpaceportId = s.Id
JOIN Planets as p ON s.PlanetId = p.Id
WHERE @planetName = p.Name
)
RETURN @result
END

SELECT dbo.udf_GetColonistsCount('Otroyphus')

CREATE PROCEDURE usp_ChangeJourneyPurpose(@JourneyId INT , @NewPurpose VARCHAR(11))
AS
BEGIN
     IF (@JourneyId NOT IN (SELECT Id  FROM Journeys))
	   THROW 50001, 'The journey does not exist!',1

       IF ((SELECT COUNT(*)
         FROM Journeys
         WHERE Id = @JourneyId
           AND Purpose = @NewPurpose) != 0)
        THROW 50002,'You cannot change the purpose!',1

   UPDATE Journeys
    SET Purpose=@NewPurpose
    WHERE Id = @JourneyId
    	 
END


EXEC usp_ChangeJourneyPurpose 2, 'Educational'

EXEC usp_ChangeJourneyPurpose 196, 'Technical'




