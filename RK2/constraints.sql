use dbRK2 
go 


alter table dbo.automobile add 
	constraint PK_E primary key (id)
go

alter table dbo.driver add 
	constraint PK_D primary key (id),
	constraint FK_A foreign key (automobile) references dbo.automobile (id)
go 

alter table dbo.fine add
	constraint PK_F primary key (id)
go 

--- многие ко многим 
alter table dbo.fd add 
	constraint PK_FD primary key (driver_id, fine_id),
	constraint FK_D foreign key (driver_id) references dbo.driver (id),
	constraint FK_F foreign key (fine_id) references dbo.fine (id)
go

