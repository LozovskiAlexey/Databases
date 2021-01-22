use master 
go 

if exists (select name from sys.databases where name=N'dbRK2')
	drop database dbRK2
go

create database dbRK2 
go 

use dbRK2 
go

create table dbo.driver(
	id int NOT NULL,
	driver_num varchar(25) NOT NULL,
	phone_num varchar(20) NOT NULL,
	full_name varchar(50) NOT NULL,
	automobile int NOT NULL
)
go 

create table dbo.automobile(
	id int NOT NULL, 
	mark varchar(20) NOT NULL,
	model int NOT NULL,
	release_dt date NOT NULL,
	reg_dt date NOT NULL
)
go

create table dbo.fine(   ---רענאפ
	id int NOT NULL,
	Ftype varchar(20) NOT NULL,
	cost int NOT NULL,
	warning varchar(max) NOT NULL
)
go

create table dbo.fd(
	fine_id int NOT NULL,
	driver_id int NOT NULL
)
go
