CREATE DATABASE Movies

CREATE TABLE Directors (
   Id INT Primary key Identity,
   DirectorName NVARCHAR(25) NOT NULL,
   Notes  NVARCHAR(Max)
   )

   CREATE TABLE Genres (
   Id INT Primary key Identity,
   GenreName NVARCHAR(25) NOT NULL,
   Notes  NVARCHAR(Max)
   )

   CREATE TABLE Categories (
   Id INT Primary key Identity,
   CategoryName NVARCHAR(25) NOT NULL,
   Notes  NVARCHAR(Max)
   )

   CREATE TABLE Movies (
   Id INT Primary key Identity,
   Title NVARCHAR(35) NOT NULL,
   DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
   CopyrightYear DATETIME2 NOT NULL,
	[Length] TIME NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating DECIMAL(2, 1),
	Notes NVARCHAR(MAX)
	)