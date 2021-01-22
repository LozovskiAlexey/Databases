IF EXISTS (SELECT name FROM sys.databases WHERE name = N'dbLAB01')
	DROP DATABASE dbLAB01
GO 

CREATE DATABASE dbLAB01
GO


--insert t1 (t1_id, num)
--values (1, 1)
--insert t1 (t1_id, num)
--values (2, 0)
--insert t1 (t1_id, num)
--values (3, 4)
--insert t1 (t1_id, num)
--values (4, 4)
--insert t1 (t1_id, num)
--values (5, 4)


select * from t1;

with t as (
	select t1_id, 
	row_number() over (partition by t1_id 
					   order by(select null)) as tmp
	from t1
)
select * from t;


with t as (
	select t1_id, 
	row_number() over (partition by t1_id 
					   order by(select null)) as tmp
	from t1
)
select * from t where tmp = 1;


with t as (
	select t1_id, 
	row_number() over (partition by t1_id 
					   order by(select null)) as tmp
	from t1
)
delete from t where tmp = 1;

