USE dbLAB01
GO

-- ЗАДАНИЕ 1
-- скалярная функция
-- считает количество фильмов, произведенных в заданной стране
CREATE FUNCTION dbo.udf_CountMovies(@country varchar(30))
RETURNS INT AS 
BEGIN 
DECLARE @counter INT=0;
SELECT @counter = COUNT(Mno) FROM dbo.M 
				  WHERE M.Mctry = @country;
RETURN @counter;
END;
GO 


-- Табличная функция 
-- Выведет список актеров, игравших в заданном фильме
CREATE FUNCTION dbo.udf_getActors(@movie varchar(25))
RETURNS TABLE 
AS
RETURN (SELECT Aname 
		FROM  A JOIN A_M on A.Ano=A_M.Ano
				JOIN M on A_M.Mno=M.Mno
		WHERE Mname=@movie);
GO 


-- Выведет таблицу с информацией об актере
-- (название фильмов, Возраст актера, средний)
CREATE FUNCTION dbo.udf_getActorInfo(@AName varchar(50))
RETURNS @result TABLE 
	(
		ActorName varchar(50) not null,
		ActorAge int not null, 
		MovieName varchar(25) not null, 
		MovieCountry varchar(20) not null
		--AgvRate int not null
	)
AS 
BEGIN 
	INSERT INTO @result 
	(
		ActorName,
		ActorAge, 
		MovieName, 
		MovieCountry
	)
	SELECT Aname, Aage, Mname, Mctry
	FROM A JOIN A_M ON A.Ano=A_M.Ano
		   JOIN M ON A_M.Mno=M.Mno
	WHERE Aname = @AName
	RETURN;
END;
GO

--- рекурсивно считает среднюю длину фильмов в бд
CREATE FUNCTION dbo.udf_CountAvgLength(@length INT, @count INT)
RETURNS FLOAT AS 
BEGIN 
		IF @count >= 30
			RETURN @length / @count;

		SET @length += (SELECT Mlength from M where Mno = @count)
		SET @count += 1

		RETURN dbo.udf_CountAvgLength(@length, @count);
END;
GO 

--- Увеличит значение статуса на 1 если у заданного фильма
CREATE PROCEDURE riseRate @movieName varchar(20)
AS
	SELECT Mname, Mrate from M WHERE Mname = @movieName;

	UPDATE M SET Mrate += 1 WHERE Mrate < 10 AND Mname = @movieName;

	SELECT Mname, Mrate from M WHERE Mname = @movieName;
GO 

--Посчитает средний рейтинг по таблице и 
--увеличит на 1 рейтинг тех, фильмов
--значение которых ниже среднего
CREATE PROCEDURE getAvgRate 
AS 
	DECLARE @AvgRate FLOAT;
	WITH recursion(TotalRate, MovieCounter) 
	AS(
		SELECT (SELECT Mrate FROM M WHERE Mno = 1) AS TotalRate, 1 AS MovieCounter
		UNION ALL
		SELECT TotalRate + (SELECT Mrate FROM M WHERE Mno = MovieCounter), MovieCounter+1
		FROM recursion WHERE MovieCounter < 30
	)

	SELECT @AvgRate = (select max(TotalRate) / max(MovieCounter) from recursion);

	SELECT Mname, Mrate FROM M WHERE Mrate < @AvgRate;

	--- можно заменить на процедуру RiseRate c использованием курсора 
	UPDATE M SET Mrate += 1 WHERE Mrate < @AvgRate;

	SELECT Mname, Mrate FROM M WHERE Mrate < @AvgRate;
GO



--- ЗАДАНИЕ 2 
--- Ну просто чтоб была, почему бы и нет
CREATE TABLE dbo.tmp_table(
	MovieName VARCHAR(25),
	Rate INT
)
GO

--- Вставит строку в таблицу если такого фильма нет
CREATE PROCEDURE insertUnique @Name varchar(25), @Rate INT
AS	
	IF NOT EXISTS (SELECT MovieName FROM dbo.tmp_table WHERE MovieName = @Name)
	BEGIN 
		INSERT INTO dbo.tmp_table VALUES (@Name, @Rate)
	END
GO

--- Вставит в таблицу фильмы с уникальными именами
CREATE PROCEDURE insertAllUnique 
AS 
	DECLARE my_cursor CURSOR FOR --- SCROLL дает возможность использовать в выборке не только NEXT
	SELECT Mname, Mrate FROM M
	
	--- определяем переменные (в них читаем из курсора)
	DECLARE @Name varchar(25);
	DECLARE @Rate int;

	--- открыли курсор, теперь с ним можно работать
	OPEN my_cursor

	--- читаем из курсора построчно
	FETCH NEXT FROM my_cursor INTO @Name, @Rate

	--- в цикле, пока не считали все или не возникла ошибка 
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		EXEC insertUnique @Name, @Rate
		FETCH NEXT FROM my_cursor INTO @Name, @Rate
	END;

	--- закрываем курсор и освобождаем
	CLOSE my_cursor
	DEALLOCATE my_cursor
GO

--- доступ ко информации обо всех таблицах
CREATE PROCEDURE getAllTablesInfo ---@name VARCHAR(20)
AS
	SELECT  *
	FROM    sys.objects
	WHERE   type = 'U';

GO

--- доступ к информации о заданной пользователем таблице 
CREATE PROCEDURE getTableInfo @name VARCHAR(25)
AS 
	SELECT TABLE_NAME AS [Имя таблицы],
           COLUMN_NAME AS [Имя столбца],
           DATA_TYPE AS [Тип данных столбца],
           IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE table_name = @name
GO


--- ЗАДАНИЕ 3
--- удаление из связующей таблицы 
--- строку с заданным актером
CREATE TRIGGER test ON dbo.A 
AFTER DELETE 
AS
	select * from deleted
GO 

---ЗАДАНИЕ 3 
--- журнал изменений таблицы А
CREATE TABLE dbo.history
(
	id INT NOT NULL IDENTITY,
	deletedId INT NOT NULL,
	msg VARCHAR(50)
)
GO

--- удаление из связующей таблицы 
--- строку с заданным актером
CREATE TRIGGER infoTrigger ON dbo.A 
AFTER DELETE
AS
	DECLARE @tmpName VARCHAR(25);
	SELECT @tmpName = (SELECT Aname from DELETED)

	DECLARE @DeletedId INT;
	SELECT @DeletedId = (SELECT Ano from DELETED)

	DELETE A_M WHERE A_M.Ano = @DeletedId
	DELETE A_S WHERE A_S.Ano = @DeletedId

	INSERT INTO dbo.history(deletedId, msg)
	SELECT Ano, 'Actor ' + @tmpName + ' was deleted.'
	FROM DELETED
GO 

--- таблица информации о добавленных строках
CREATE TABLE dbo.InsertedHistory
(
	msg VARCHAR(100)
)
GO

--- добавит строку если такой нет в таблице
--- заполнит инфо-таблицу сообщением о добавлении или 
--- обнаружении существующей записи
CREATE TRIGGER insertInfoTrigger ON dbo.A 
INSTEAD OF INSERT
AS
	DECLARE @tmpName VARCHAR(25);
	SELECT @tmpName = (SELECT Aname from INSERTED)

	--- проверка на существование записи в таблице А
	DECLARE @existance INT; 
	SELECT @existance = (SELECT TOP(1) Ano FROM A WHERE Aname=@TmpName)

	IF @existance is NULL
	BEGIN
		--- если записи нет - добавить в таблицу А
		INSERT INTO A (Aage, Aname) 
		SELECT Aage, Aname FROM INSERTED

		--- в журнал записывается информация о том, что запись добавлена
		INSERT INTO InsertedHistory(msg) 
		SELECT 'Actor ' + @TmpName + ' was added.'
	END;
	ELSE 
		--- если запись есть, в журнал запишется сообщение об этом
		INSERT INTO InsertedHistory(msg) 
		SELECT 'Actor ' + @TmpName + ' is already in table.'
GO 
