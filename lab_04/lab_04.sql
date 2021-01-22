USE dbLAB01
GO

EXEC sp_configure 'clr enabled', 1;  
RECONFIGURE;  
GO  

ALTER DATABASE dbLAB01 SET TRUSTWORTHY ON 
GO

-- Скалярная функция
-- считает количество фильмов, выпущенных в заданной стране
CREATE FUNCTION countMovies(@country nvarchar(25))
RETURNS INT
	EXTERNAL NAME lab_04.ScalarFunction.sqlCountMovies
GO

-- Проверка работы 
SELECT dbo.CountMovies('Россия')
GO

DROP FUNCTION countMovies
GO
-----------------------------------------------------------------------------

-- Табличная функция 
-- выдает список актеров конкретного фильма
CREATE FUNCTION getActors(@movieName NVARCHAR(25))
RETURNS TABLE (ActorId INT, ActorName NVARCHAR(50))
AS 
	EXTERNAL NAME lab_04.TableFunction.getActors
GO

SELECT * FROM getActors('художественный')
GO
 
DROP FUNCTION getActors
GO
-----------------------------------------------------------------------------

-- Агрегатная функция
-- группирует строки из таблицы
CREATE AGGREGATE Combine (@name NVARCHAR(200)) 
RETURNS NVARCHAR(MAX)
	EXTERNAL NAME lab_04.Combine
GO

SELECT dbo.Combine(Mname)
FROM M
GROUP BY(Mname)

DROP AGGREGATE Combine
GO
-----------------------------------------------------------------------------

--Хранимая процедура
--Заполнит таблицу уникальными значениями
CREATE PROCEDURE insertUnique @Name NVARCHAR(25), @Rate INT
AS
	EXTERNAL NAME lab_04.StoredProcedures.InsertUnique
GO

EXEC dbo.insertUnique 'Чудо', 2
GO 

SELECT * FROM dbo.tmp_table

EXEC dbo.insertUnique 'Чудо', 2
GO 

SELECT * FROM dbo.tmp_table


DROP PROCEDURE insertUnique
GO
-----------------------------------------------------------------------------
-- Триггер
CREATE TRIGGER OnDelete ON dbo.A
FOR DELETE AS 
	EXTERNAL NAME lab_04.Triggers.OnDelete
GO

-- тестим триггеры 
--DELETE FROM A WHERE Aname = 'Ситников Ярополк Игнатьевич';
--DELETE FROM A WHERE Aname = 'Кошелев Любим Елизарович';
--DELETE FROM A WHERE Aname = 'Уварова Варвара Вадимовна';

select * from dbo.history

DROP TRIGGER OnDelete
GO
-----------------------------------------------------------------------------

CREATE TYPE Point 
EXTERNAL NAME lab_04.Point
GO

CREATE TABLE CheckPoints 
(
	CheckPnt Point,
	distance INT
)
GO

INSERT INTO CheckPoints VALUES (convert(Point, '6,3'), 0)
SELECT CheckPnt.ToString(), distance FROM CheckPoints

DROP TABLE CheckPoints 
GO

DROP TYPE Point 
GO