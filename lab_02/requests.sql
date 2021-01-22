USE dbLAB01
GO

-- ������� ��� �������, ������� ������ 18
select Aname 
from dbo.A as A where Aage > 18

-- ������� ��� �������, ������� ��������� � ���������� �� 18 �� 36
select Aname 
from dbo.A as A where Aage between 18 and 36

-- ������� ���� ������� ��� ��� ���� 
select Aname 
from dbo.A as A where Aname LIKE '% ���� %'

-- ������� ����� ���� ������� ������� ������ 18, ������� ������ � ������
select Aname 
from dbo.A as A 
join dbo.A_S on A.Ano = A_S.Ano 
join dbo.S on A_S.Sno = S.Sno 
where Aage > 18 and Sname in (
	select Sname 
	from dbo.S
	where Sgenre like '%�����%'
)

-- ������� ���� ������� ������� ������ ������ ��������
select Aname
from dbo.A where exists(
	select * 
	from dbo.A as B
	where dbo.A.Aage < B.Aage
)

-- ������� ������ �������, ������� ������ � ��������, ������ ����������
select Mname 
from dbo.M 
join dbo.S_S_M as SSM on M.Mno = SSM.Mno
join dbo.Sub as Sub on SSM.Subno = Sub.Subno
where Sub.Subprice > ALL 
(
	select Subprice 
	from dbo.Sub 
	where Subname = '����������'
)

-- ������� ���� �������, ��� ������� ���� �������� �� �������
select Aname
from dbo.A as A 
where A.Aage > (select avg(A.Aage) 
	from A)

select Subname, 
	   Subprice,
	   (	
			select avg(Subprice) 
			from dbo.Sub 
		) as avg_price, 
		(
			select max(Subprice)
			from dbo.Sub
		) as max_price
		from dbo.Sub


select case Subno when 1 then '����������'
			      when 2 then '�������'
				  when 3 then '����������'
	   end as sub_name, Subno
from dbo.Sub

select case when Subno = 1 then '����������'
			when Subno = 2 then '�������'
			when Subno = 3 then '����������'
	   end as sub_name, Subno
from dbo.Sub

---select Subno, count(Uno) as amount
---into #st
---from dbo.U as U
---join dbo.Sub as Sub on U.Usub = Sub.Subno
---group by Subno

---select * from #st

-- ��� ������� ������ �������� ���������� �������, � ������� �� ����������
select Aname, count(AM.Mno)
from dbo.A as A 
join dbo.A_M as AM on A.Ano=AM.Ano
join dbo.M as M on AM.Mno=M.Mno
group by Aname

--- �������� ��� ������� ����� ������� ���������� ������� � ������� 
--- ������ ������ ������� ������� ������� ���� �������� �� �� 
select Mgenre, count(A_M.Mno) as amount, AVG(Aage) as avg_age
from M 
join A_M on A_M.Mno=M.Mno
join A on A.Ano=A_M.Ano
group by Mgenre
having AVG(Aage) > (
		select AVG(Aage) as Avg_age
		from A
)

insert Sub (Subprice, Subname)
values (1800, '����������')

select * from Sub 

delete Sub where Subprice = 1800

insert M (Mlength, Mname, Mgenre, Mctry, Mrate)
select (
	select max(Mlength) 
	from M 
	where M.Mgenre = '�������'
), '����������', '�������', '������', '5/10';

with recursia (ml, ind) 
as (
	select  (select Mlength from M where Mno = 1) as ml,  1 as ind  

	union all 

	select ml + (select Mlength from M where Mno = ind), ind+1
	from recursia
	where ind < 99
)
select max(ml) / 99 from recursia; --- avg(movlength) from recursia 

delete from M 
where Mno in (
	select Mno 
	from M 
	where Mname = '������');


with NewM (ml)
as (
	select Mlength from M where Mrate = '10/10'
	) 
select avg(ml) from NewM;


update M 
set Mlength = 123
where Mno = 10

update A
set Aage = (
	select max(Aage) from A
		   )
		   where Ano=10

select Aname, count(AM.Mno) over(partition by Aname)
from dbo.A as A 
join dbo.A_M as AM on A.Ano=AM.Ano
join dbo.M as M on AM.Mno=M.Mno
--group by Aname

select Mname, Aname, count(Aname) over(partition by Mname)
from dbo.M as M
join dbo.A_M as AM on AM.Mno=M.Mno
join dbo.A on A.Ano=AM.Ano
--group by Mname

-- ������ ������� ��������� � ������� � ������ ������� 
select Aname 
from A 
join (
	select Mgenre, Ano
	from M 
	join A_M as AM on AM.Mno=M.Mno
	where Mgenre = '�������'
	) as Com on A.Ano = Com.Ano

-- �������� � �������� ��� ������ ����� 
select Subname, Mno
from Sub 
join S_S_M as SSM on SSM.Subno = Sub.Subno 
where Mno in (
	select M.Mno 
	from M 
	join A_M as AM on AM.Mno=M.Mno
	where Ano in (
				select Ano 
				from A 
				where Aname = '�������� ������� �������������'
				)
	)

