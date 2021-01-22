USE dbLAB01
GO 



-- ЗАДАНИЕ 1 

--тестим скалярную функцию
DECLARE @counter INT;
SET @counter = dbo.udf_CountMovies('Россия');
SELECT @counter as RussianMovies

--тестим подставляемую табличную функцию 
SELECT * FROM dbo.udf_getActors('космос')

--тестим многооператорную табличную функцию
SELECT * FROM dbo.udf_getActorInfo('Пономарева Татьяна Юльевна');

--тестим рекурсивную функцию
DECLARE @count INT=NULL;
DECLARE @length INT=0;
DECLARE @result FLOAT;
SET @result = dbo.udf_CountAvgLength(@length, @count);
SELECT @result as TotalAvgTime


-- ЗАДАНИЕ 2

-- тестим хранимую процедуру 
EXEC riseRate 'сынок'; -- рейтинг изменится 
GO 

EXEC riseRate 'низкий'; -- рейтинг не изменится 
GO

-- тестим рекурсивную процедуру 
EXEC getAvgRate;
GO

-- тестим работу с курсором 
EXEC insertAllUnique;
GO 
SELECT * FROM dbo.tmp_table

-- тестим доступ к метаданным
EXEC getAllTablesInfo
GO

EXEC getTableInfo 'S';
GO

-- тестим триггеры 
DELETE FROM A WHERE Aname = 'Ситников Ярополк Игнатьевич';
DELETE FROM A WHERE Aname = 'Кошелев Любим Елизарович';
DELETE FROM A WHERE Aname = 'Уварова Варвара Вадимовна';

select * from dbo.history

-- все еще тестим
INSERT INTO A (Aage, Aname) VALUES (20, 'Лозовский Алексей')
INSERT INTO A (Aage, Aname) VALUES (20, 'Лозовский Алексей')

SELECT * FROM dbo.InsertedHistory