CREATE TABLE StudentsExams (
StudentID INT  NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
ExamID INT  NOT NULL FOREIGN KEY REFERENCES Exams(ExamID),
PRIMARY KEY (StudentID , ExamID)
)

SELECT s.[Name] , e.[Name] FROM StudentsExams AS se
JOIN Students AS s ON se.StudentID = s.StudentID
JOIN Exams AS e ON se.ExamID = e.ExamID

CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY,
[Name] NVARCHAR(25) NOT NULL,
ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers(TeacherID , [Name] , ManagerID)
VALUES 
(101 ,'John' , NULL),
(102 ,'Maya' , 106),
(103 ,'Silvia' , 106),
(104 ,'Ted' , 105),
(105 ,'Mark' , 101),
(106 , 'Greata' , 101)

CREATE DATABASE University

CREATE TABLE Majors(
MajorID INT PRIMARY KEY ,
[Name] NVARCHAR(50),
)

CREATE TABLE Students(
StudentID INT PRIMARY KEY , 
StudentNumber NVARCHAR(15), 
StudentName NVARCHAR(35),
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments(
PaymentID INT PRIMARY KEY , 
PaymentDate DATETIME2 NOT NULL,
PaymentAmount DECIMAL(10,2) NOT NULL,
StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY , 
SubjectName NVARCHAR(50)
)

CREATE TABLE AGENDA(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
PRIMARY KEY (StudentID , SubjectID)
)

USE Geography

SELECT MountainRange , PeakName , Elevation   FROM Peaks as p
JOIN Mountains as m ON p.MountainId = m.Id
WHERE MountainRange Like 'Rila'
Order BY Elevation DESC
