
CREATE TABLE Clients (
ClientId INT PRIMARY KEY Identity ,
FirstName NVARCHAR(50) NOT NULL ,
LastName NVARCHAR(50) NOT NULL,
Phone CHAR(12) CHECK(LEN(Phone) = 12)  NOT NULL 
)

CREATE TABLE Mechanics (
MechanicId INT PRIMARY KEY Identity ,
FirstName NVARCHAR(50) NOT NULL ,
LastName NVARCHAR(50) NOT NULL,
[Address] NVARCHAR(255) NOT NULL
)

CREATE TABLE Models(
ModelId INT PRIMARY KEY Identity,
[Name] NVARCHAR(50) UNIQUE NOT NULL,
)

CREATE TABLE Jobs(
JobId INT PRIMARY KEY Identity,
ModelId INT FOREIGN KEY REFERENCES Models(ModelId) NOT NULL,
[Status] NVARCHAR(11) CHECK([Status] = 'Pending' OR [Status] = 'In Progress' OR [Status] = 'Finished')
DEFAULT 'Pending' NOT NULL,
ClientId INT FOREIGN KEY REFERENCES Clients(ClientId) NOT NULL,
MechanicId INT FOREIGN KEY REFERENCES Mechanics(MechanicId) ,
IssueDate DATE NOT NULL ,
FinishDate DATE 
)

CREATE TABLE Orders(
OrderId INT PRIMARY KEY Identity,
JobId INT FOREIGN KEY REFERENCES Jobs(JobId) NOT NULL,
IssueDate DATE ,
Delivered BIT DEFAULT (0)
)
CREATE TABLE Vendors(
VendorId INT PRIMARY KEY Identity,
[Name] NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Parts(
PartId INT PRIMARY KEY Identity,
SerialNumber NVARCHAR(50) UNIQUE NOT NULL ,
[Description] NVARCHAR(255),
Price DECIMAL(15,2) CHECK(Price > 0 AND Price <= 9999.99) NOT NULL,
VendorId INT FOREIGN KEY REFERENCES Vendors(VendorId) NOT NULL,
StockQty INT DEFAULT(0) CHECK(StockQty >= 0)
)

CREATE TABLE OrderParts(
OrderId INT FOREIGN KEY REFERENCES Orders(OrderId) NOT NULL,
PartId INT FOREIGN KEY REFERENCES Parts(PartId) NOT NULL,
Quantity INT DEFAULT(1) CHECK(Quantity > 0) NOT NULL ,
PRIMARY KEY (OrderId , PartId)
)

CREATE TABLE PartsNeeded(
JobId INT FOREIGN KEY REFERENCES Jobs(JobId) NOT NULL,
PartId INT FOREIGN KEY REFERENCES Parts(PartId) NOT NULL,
Quantity INT DEFAULT(1) CHECK(Quantity > 0) NOT NULL,
PRIMARY KEY (JobId , PartId)
)


INSERT INTO Clients (FirstName , LastName , Phone)
VALUES
('Teri',	'Ennaco',	'570-889-5187'),
('Merlyn',	'Lawler',	'201-588-7810'),
('Georgene',	'Montezuma',	'925-615-5185'),
('Jettie',	'Mconnell',	'908-802-3564'),
('Lemuel',	'Latzke',	'631-748-6479'),
('Melodie',	'Knipp',	'805-690-1682'),
('Candida',	'Corbley',	'908-275-8357')

UPDATE Jobs
SET MechanicId=3, Status='In Progress'
WHERE Status='Pending'

DELETE FROM OrderParts WHERE OrderId=19
DELETE FROM Orders WHERE OrderId=19

SELECT  CONCAT(m.FirstName , ' ' , m.LastName) as Mechanic , [Status] , IssueDate FROM Mechanics as m
JOIN Jobs as j ON m.MechanicId = j.MechanicId
ORDER BY m.MechanicId , j.IssueDate , j.JobId

SELECT  CONCAT(FirstName , ' ' , LastName) as Client ,DATEDIFF(DAY ,  IssueDate ,'2017-04-24'  ) as [Days going], [Status] FROM Clients as c
JOIN Jobs as j ON c.ClientId = j.ClientId
WHERE [Status] <> 'Finished'
ORDER BY [Days going] DESC , c.ClientId 

SELECT CONCAT(m.FirstName , ' ' , m.LastName) as Mechanic ,AVG(DATEDIFF(DAY ,  IssueDate ,FinishDate  )) as [Average Days] FROM Mechanics as m
JOIN Jobs as j ON m.MechanicId = j.MechanicId
WHERE [Status] = 'Finished'
GROUP BY CONCAT(m.FirstName , ' ' , m.LastName) , m.MechanicId
ORDER BY m.MechanicId

SELECT  CONCAT(m.FirstName , ' ' , m.LastName) as Available FROM Mechanics as m
LEFT JOIN Jobs as j ON m.MechanicId = j.MechanicId
WHERE (
        SELECT COUNT(JobId) FROM Jobs
		WHERE [Status] <> 'Finished' AND MechanicId = m.MechanicId
		GROUP BY MechanicId , [Status]) IS NULL 
GROUP BY  CONCAT(m.FirstName , ' ' , m.LastName),m.MechanicId
ORDER BY m.MechanicId

SELECT j.JobId , IIF(SUM(Price * Quantity)  IS NULL , 0.00 ,SUM(Price * Quantity) )  as [Total] FROM Jobs as j
LEFT JOIN Orders as o ON j.JobId = o.JobId
LEFT JOIN OrderParts as op ON o.OrderId = op.OrderId
LEFT JOIN Parts as p ON op.PartId = p.PartId
WHERE j.Status = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId ASC

SELECT *FROM Jobs as j
LEFT JOIN Orders as o ON j.JobId = o.JobId
LEFT JOIN OrderParts as op ON o.OrderId = op.OrderId
LEFT JOIN Parts as p ON op.PartId = p.PartId
GROUP BY j.JobId

SELECT p.PartId , p.Description , pn.Quantity as [Required] ,p.StockQty as [In Stock], 
IIF(o.Delivered = 0 , op.Quantity , 0) as Ordered FROM Parts as p
LEFT JOIN PartsNeeded pn ON p.PartId = pn.PartId
LEFT JOIN OrderParts as op ON op.PartId = p.PartId
LEFT JOIN Jobs as j ON j.JobId = pn.JobId
LEFT JOIN Orders as o ON j.JobId = o.JobId
WHERE j.Status <> 'Finished'  AND p.StockQty + IIF(o.Delivered = 0 , op.Quantity , 0) < pn.Quantity
ORDER BY p.PartId

CREATE OR ALTER FUNCTION udf_GetCost(@JobId INT )
RETURNS DECIMAL(16,2)
AS
BEGIN
DECLARE @res DECIMAL(16,2) = (SELECT SUM(Price) 
								         FROM Parts AS P
                  JOIN OrderParts OP on P.PartId = OP.PartId
                  JOIN Orders O on OP.OrderId = O.OrderId
                  JOIN Jobs J on J.JobId = O.JobId
         WHERE J.JobId = @JobId)
DECLARE @res2 DECIMAL(16,2)

IF (@res IS NULL)
RETURN 0
RETURN @res
END


 





