USE dbLAB01
GO 



-- ������� 1 

--������ ��������� �������
DECLARE @counter INT;
SET @counter = dbo.udf_CountMovies('������');
SELECT @counter as RussianMovies

--������ ������������� ��������� ������� 
SELECT * FROM dbo.udf_getActors('������')

--������ ���������������� ��������� �������
SELECT * FROM dbo.udf_getActorInfo('���������� ������� �������');

--������ ����������� �������
DECLARE @count INT=NULL;
DECLARE @length INT=0;
DECLARE @result FLOAT;
SET @result = dbo.udf_CountAvgLength(@length, @count);
SELECT @result as TotalAvgTime


-- ������� 2

-- ������ �������� ��������� 
EXEC riseRate '�����'; -- ������� ��������� 
GO 

EXEC riseRate '������'; -- ������� �� ��������� 
GO

-- ������ ����������� ��������� 
EXEC getAvgRate;
GO

-- ������ ������ � �������� 
EXEC insertAllUnique;
GO 
SELECT * FROM dbo.tmp_table

-- ������ ������ � ����������
EXEC getAllTablesInfo
GO

EXEC getTableInfo 'S';
GO

-- ������ �������� 
DELETE FROM A WHERE Aname = '�������� ������� ����������';
DELETE FROM A WHERE Aname = '������� ����� ����������';
DELETE FROM A WHERE Aname = '������� ������� ���������';

select * from dbo.history

-- ��� ��� ������
INSERT INTO A (Aage, Aname) VALUES (20, '��������� �������')
INSERT INTO A (Aage, Aname) VALUES (20, '��������� �������')

SELECT * FROM dbo.InsertedHistory