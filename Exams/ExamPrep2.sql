CREATE TABLE Students(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
MiddleName NVARCHAR(25) ,
LastName NVARCHAR(30) NOT NULL,
Age TINYINT CHECK(Age > 5 AND Age < 100),
[Address] NVARCHAR(50) ,
Phone NCHAR(10) CHECK(LEN(Phone) = 10)
)

CREATE TABLE Subjects(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
Lessons INT NOT NULL Check(Lessons > 0),
)

CREATE TABLE StudentsSubjects(
Id INT PRIMARY KEY IDENTITY,
StudentId INT NOT NULL Foreign KEY References Students(Id),
SubjectId INT NOT NULL Foreign KEY References Subjects(Id),
Grade Decimal(16,2) NOT NULL Check(Grade >= 2 AND Grade <= 6),
)

CREATE TABLE Exams(
Id INT PRIMARY KEY IDENTITY,
[Date] DateTime2,
SubjectId INT NOT NULL Foreign KEY References Subjects(Id)
)

CREATE Table StudentsExams(
StudentId INT NOT NULL Foreign KEY References Students(Id),
ExamId INT NOT NULL Foreign KEY References Exams(Id),
Grade Decimal(16,2) NOT NULL Check(Grade >= 2 AND Grade <= 6),
PRIMARY KEY (StudentId , ExamId)
)

CREATE TABLE Teachers(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
[Address] NVARCHAR(20) NOT NULL ,
Phone CHAR(10) CHECK(LEN(Phone) = 10),
SubjectId INT NOT NULL Foreign KEY References Subjects(Id)
)

CREATE TABLE StudentsTeachers(
StudentId INT NOT NULL Foreign KEY References Students(Id),
TeacherId INT NOT NULL Foreign KEY References Teachers(Id),
PRIMARY KEY (StudentId , TeacherId)
)

INSERT INTO Teachers (FirstName , LastName , [Address] , Phone , SubjectId)
VALUES
('Ruthanne',	'Bamb','84948 Mesta Junction',	'3105500146',	6),
('Gerrard','	Lowin',	'370 Talisman Plaza','3324874824',	2),
('Merrile', '	Lambdin	','81 Dahle Plaza','4373065154',	5),
('Bert','	Ivie',	'2 Gateway Circle','4409584510',4)

INSERT INTO Subjects ([Name],	Lessons)
VALUES
('Geometry',	12),
('Health',	10),
('Drama	',    7),
('Sports',	9)

UPDATE StudentsSubjects
SET Grade = 6.00
WHERE SubjectId IN (1,2) AND Grade >= 5.5



DELETE FROM StudentsTeachers
WHERE TeacherId IN  (
        SELECT Id FROM Teachers
        WHERE Phone LIKE ('%72%'))

DELETE FROM Teachers
WHERE Phone LIKE ('%72%')

SELECT FirstName , LastName , Age FROM Students
Where Age >= 12
Order BY FirstName , LastName

SELECT s.FirstName , s.LastName , COUNT(*) FROM Students as s
 JOIN StudentsTeachers as st ON s.Id = st.StudentId
 JOIN Teachers as t ON st.TeacherId = t.Id
GROUP BY s.Id , s.FirstName , s.LastName
ORDER BY s.LastName

SELECT CONCAT(FirstName , ' ' , LastName) as FullName FROM Students as s
LEFT JOIN StudentsExams as se ON s.Id = se.StudentId
LEFT JOIN Exams as e ON se.ExamId = e.Id
WHERE se.ExamId IS NULL
ORDER BY FullName

SELECT TOP 10 s.FirstName , s.LastName , FORMAT(AVG(Grade),'N2')as grade FROM Students as s
LEFT JOIN StudentsExams as se ON s.Id = se.StudentId
LEFT JOIN Exams as e ON se.ExamId = e.Id
GROUP BY s.Id , s.FirstName , s.LastName
ORDER BY grade DESC , s.FirstName , s.LastName

SELECT CONCAT
    (S.FirstName, ' ', ISNULL( S.MiddleName + ' ', ''), S.LastName)  as FullName FROM Students as s
LEFT JOIN StudentsSubjects as ss ON s.Id = ss.StudentId
LEFT JOIN Subjects as su ON ss.SubjectId = su.Id
WHERE SubjectId IS NULL
ORDER BY FullName

SELECT s.Name , AVG(Grade) as AverageGrade FROM Subjects as s
JOIN StudentsSubjects as ss ON s.Id = ss.SubjectId
GROUP BY s.Id ,s.Name
ORDER BY s.Id

CREATE OR ALTER FUNCTION udf_ExamGradesToUpdate(@studentId INT , @grade DECIMAL(16,2))
RETURNS NVARCHAR(Max)
AS
BEGIN

IF (SELECT Id FROM Students
    WHERE Id = @studentId) IS NULL RETURN 'The student with provided id does not exist in the school!';

IF @grade > 6.00 Return 'Grade cannot be above 6.00!';
DECLARE @count INT = (
						SELECT COUNT(*) FROM Students as s
						JOIN StudentsExams as se ON s.Id = se.StudentId
						WHERE StudentId = @studentId AND Grade >= @grade AND Grade <= @grade + 0.5
						GROUP BY StudentId)

DECLARE @name NVARCHAR(20) = (SELECT FirstName FROM Students 
								WHERE Id = @studentId);
RETURN CONCAT('You have to update ' , @count, ' grades for the student ', @name);

END

CREATE PROCEDURE usp_ExcludeFromSchool(@StudentId INT)
AS
BEGIN 
IF (SELECT Id FROM Students WHERE Id = @StudentId) IS NULL
THROW 50001 , 'This school has no student with the provided id!' , 2;

ELSE
DELETE FROM StudentsExams WHERE StudentId = @StudentId
DELETE FROM StudentsSubjects WHERE StudentId = @StudentId
DELETE FROM StudentsTeachers WHERE StudentId = @StudentId
DELETE FROM Students WHERE Id = @StudentId
END

EXEC usp_ExcludeFromSchool 
EXEC usp_ExcludeFromSchool 1
SELECT COUNT(*) FROM Students
