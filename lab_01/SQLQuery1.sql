USE master
GO 

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'dbLAB01')
	DROP DATABASE dbLAB01
GO 

CREATE DATABASE dbLAB01
GO

USE dbLAB01
GO 

CREATE TABLE dbo.S(
	Sno int IDENTITY NOT NULL,
	Sname varchar(25) NOT NULL,
	Sgenre varchar(25) NOT NULL,
	Sctry varchar(20) NOT NULL,
	Sseasons int NOT NULL,
	Srate int NOT NULL
)
GO

CREATE TABLE dbo.M(
	Mno int IDENTITY NOT NULL,
	Mname varchar(25) NOT NULL,
	Mgenre varchar(25) NOT NULL,
	Mctry varchar(20) NOT NULL,
	Mlength int NOT NULL,
	Mrate int NOT NULL
)
GO

CREATE TABLE dbo.A(
	Ano int IDENTITY NOT NULL,
	Aname varchar(50) NOT NULL,
	Aage smallint NOT NULL
)
GO

CREATE TABLE dbo.U(
	Uno int IDENTITY NOT NULL,
	Uname varchar(50) NOT NULL,
	Uage smallint NOT NULL,
	Usub int NOT NULL
)
GO

CREATE TABLE dbo.Sub(
	Subno int IDENTITY NOT NULL,
	Subprice int NOT NULL, 
	Subname varchar(50) NOT NULL
)
GO

CREATE TABLE dbo.A_S(
	Ano int NOT NULL,
	Sno int NOT NULL
)
GO

CREATE TABLE dbo.A_M(
	Ano int NOT NULL,
	Mno int NOT NULL
)
GO

create table dbo.S_S_M(
	Subno int NOT NULL,
	Sno int NOT NULL,
	Mno int NOT NULL
)
go 
