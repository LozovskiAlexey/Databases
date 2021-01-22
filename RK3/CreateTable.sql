use master 
go 

if exists (select name from sys.databases where name=N'dbRK3')
	drop database dbRK3
go

create database dbRK3
go 

use dbRK3
go

-- Создание таблиц 
create table dbo.Employee (
	id int not null, 
	full_name varchar(50) not null,
	birth_date date not null, 
	department varchar(25) not null
) 
go


create table dbo.TimeControl (
	Employee_id int not null, 
	date date not null DEFAULT GETDATE(), -- Дата
	week_day varchar(10) not null, -- День недели 
	timer time not null,	  -- Время совершения действия 
	action_type int not null  -- Вошел/вышел 
) 
go

-- Создание ограничений на таблицы 
alter table dbo.Employee add 
	constraint Empl_PK primary key (id)
go 

alter table dbo.TimeControl add 
	constraint TC_FK foreign key (Employee_id) references dbo.Employee (id) on delete cascade,
	constraint TC_TYPE_CHECK check (action_type = 1 or action_type = 2) 
go

-- заполнение таблиц 
insert into dbo.Employee (id, full_name, birth_date, department)
	values (1, 'Иванов Иван Иванович', '25-09-1990', 'ИТ')
go 

insert into dbo.Employee (id, full_name, birth_date, department)
	values (2, 'Петров Петр Петрович', '12-11-1987', 'Бухгалтерия')
go 


insert into dbo.TimeControl (Employee_id, date, week_day, timer, action_type)
	values (1, '14-12-2018', 'Суббота', '9:00', 1) 
go

insert into dbo.TimeControl (Employee_id, date, week_day, timer, action_type)
	values (1, '14-12-2018', 'Суббота', '9:20', 2) 
go

insert into dbo.TimeControl (Employee_id, date, week_day, timer, action_type)
	values (1, '14-12-2018', 'Суббота', '9:25', 1) 
go

insert into dbo.TimeControl (Employee_id, date, week_day, timer, action_type)
	values (2, '14-12-2018', 'Суббота', '9:05', 1) 
go


-- Написать функцию, возвращающую средний возраст опоздавших сотрудников, 
-- дата опоздания передается в качестве параметра
-- опоздание - все, что позже 9:00
create function dbo.count_LateCommers(@today_date date)
returns int 
as 
begin 
	declare @res int;
	declare @arrivalTime time = '9:00:00.000';
	select @res = avg(tmp)
			   from (
				   select datediff(year, birth_date, getdate()) as tmp
				   from dbo.TimeControl as TC
				   join dbo.Employee as Empl on TC.Employee_id = Empl.id
				   where TC.action_type = 1 AND (datepart(hour, timer) >= 9 AND datepart(minute, timer) > 0) AND date = @today_date
			   ) as tmp
return(@res)
end
go 


declare @LateCommers int
set @LateCommers = dbo.count_LateCommers('14-12-2018')
select @LateCommers



