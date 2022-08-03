--01. DDL
--Create DB

CREATE DATABASE Airport
go
USE Airport

CREATE TABLE Passengers(
Id int primary key identity,
FullName varchar(100) Unique not null,
Email varchar(50) Unique not null
)

CREATE TABLE Pilots(
Id int primary key identity,
FirstName varchar(30) Unique not null,
LastName varchar(30) Unique not null,
Age tinyint not null CHECK([Age]between 21 and 62),
--Rating decimal(18,4)null CHECK (Rating >=0.0 and Rating<=10.0 ) 
Rating float(53) null CHECK (Rating between 0.0 and 10.0 ) 
)

CREATE TABLE AircraftTypes(
Id int primary key identity,
TypeName varchar(30) Unique not null
)

CREATE TABLE Aircraft(
Id int primary key identity,
Manufacturer varchar(25) not null,
Model varchar(30) not null,
[Year] int not null,
FlightHours int null,
Condition char(1) not null,
TypeId int foreign key references Aircraft(Id) not null
)

CREATE TABLE PilotsAircraft(
AircraftId int foreign key references Aircraft(Id) not null,
PilotId int foreign key references Pilots(Id)  not null,
CONSTRAINT Pk_AircraftPilot primary key(AircraftId, PilotId)
)

CREATE TABLE Airports(
Id int primary key identity,
AirportName varchar(70) Unique not null,
Country varchar(100) Unique not null,
)

CREATE TABLE FlightDestinations(
Id int primary key identity,
AirportId int  foreign key references Airports(Id) not null,
[Start] DATETIME not null,
AircraftId int  foreign key references Aircraft(Id)not null,
PassengerId int  foreign key references Passengers(Id) not null,
TicketPrice decimal (18,2)  default 15 not null

)