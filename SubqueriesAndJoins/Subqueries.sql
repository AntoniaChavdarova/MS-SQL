USE Geography
SELECT  c.CountryCode , m.MountainRange , p.PeakName , p.Elevation
FROM Countries as c
     JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode 
     JOIN Mountains as m ON  mc.MountainId = m.Id
     JOIN Peaks as  p ON m.Id= p.MountainId
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

SELECT CountryCode , COUNT(MountainId) as [MountainRanges] 
FROM MountainsCountries
WHERE CountryCode IN ('BG' , 'RU' , 'US')
GROUP BY CountryCode

SELECT  TOP 5 c.CountryName , r.RiverName
FROM  Countries AS c
  LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName 


SELECT ContinentCode ,CurrencyCode , CurrencyCount AS [CurrencyUsage]
  FROM(    
	SELECT ContinentCode ,CurrencyCode , CurrencyCount ,
	DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurrencyCount DESC ) AS [CurrencyRank]
	FROM (
				 SELECT ContinentCode ,
					CurrencyCode ,
					COUNT(*) AS [CurrencyCount] 
				 FROM Countries
				 GROUP BY ContinentCode , CurrencyCode
		 ) AS [CurrencyCountQuerry] 
	WHERE CurrencyCount > 1
) AS [CurrencyRankingQuery]
WHERE CurrencyRank = 1
ORDER BY ContinentCode

SELECT CountryCode , COUNT(MountainId) as [MountainRanges] 
FROM MountainsCountries
GROUP BY CountryCode

SELECT COUNT(c.CountryCode) AS Count
FROM Countries as c
    Left JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode 
    LEFT JOIN Mountains as m ON  mc.MountainId = m.Id
WHERE mc.MountainId  IS NULL;

SELECT TOP 5 CountryName,HighestPeakElevation ,LongestRiverLength
FROM (
		SELECT CountryName,Elevation as HighestPeakElevation ,[Length] as LongestRiverLength, 
		DENSE_RANK() OVER (Partition BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRange,
		DENSE_RANK() OVER (Partition BY c.CountryName ORDER BY r.Length DESC) AS RiverRange FROM Countries as c
		LEFT JOIN CountriesRivers as rc ON c.CountryCode = rc.CountryCode
		LEFT JOIN Rivers as r ON rc.RiverId = r.Id
		LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains as m ON mc.MountainId = m.Id
		LEFT JOIN Peaks as p ON m.Id = p.MountainId
) as [t]
WHERE t.PeakRange = 1 AND t.RiverRange = 1
ORDER BY HighestPeakElevation DESC , LongestRiverLength DESC , CountryName;

SELECT TOP 5 CountryName,MAX(Elevation) as HighestPeakElevation ,MAX([Length]) as LongestRiverLength
FROM Countries as c
        LEFT JOIN CountriesRivers as rc ON c.CountryCode = rc.CountryCode
		LEFT JOIN Rivers as r ON rc.RiverId = r.Id
		LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains as m ON mc.MountainId = m.Id
		LEFT JOIN Peaks as p ON m.Id = p.MountainId
GROUP BY CountryName
ORDER BY HighestPeakElevation DESC , LongestRiverLength DESC , CountryName;

SELECT TOP 5 t.[Country] ,
  ISNULL(t.[Highest Peak Name] , '(no highest peak)') AS [Highest Peak Name] ,  
  ISNULL(t.[Highest Peak Elevation] , 0) AS [Highest Peak Elevation] ,
  ISNULL(t.Mountain , '(no mountain)') AS Mountain
 FROM
  (SELECT c.CountryName as Country , p.PeakName as [Highest Peak Name] , p.Elevation as [Highest Peak Elevation] , m.MountainRange as Mountain ,
		DENSE_RANK() OVER (Partition BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRange
		   FROM Countries as c
			LEFT JOIN MountainsCountries as mc ON c.CountryCode = mc.CountryCode 
			LEFT  JOIN Mountains as m ON  mc.MountainId = m.Id
			LEFT  JOIN Peaks as  p ON m.Id= p.MountainId
   ) as t
WHERE t.PeakRange = 1
ORDER BY t.Country ASC , [Highest Peak Name] ASC;


