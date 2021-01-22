USE dbLAB01
GO

CREATE TABLE dbo.InsertedHistory
(
	msg VARCHAR(100)
)
GO


CREATE TRIGGER insertInfoTrigger ON dbo.A 
INSTEAD OF INSERT
AS
	DECLARE @tmpName VARCHAR(25);
	SELECT @tmpName = (SELECT Aname from INSERTED)

	DECLARE @existance INT; 
	SELECT @existance = (SELECT TOP(1) Ano FROM A WHERE Aname=@TmpName)

	IF @existance is NULL
	BEGIN
		INSERT INTO InsertedHistory(msg) 
		SELECT 'Actor ' + @TmpName + ' was added.'

		INSERT INTO A (Aage, Aname) 
		SELECT Aage, Aname FROM INSERTED
	END;
	ELSE 
		INSERT INTO InsertedHistory(msg) 
		SELECT 'Actor ' + @TmpName + ' is already in table.'
GO 

INSERT INTO A (Aage, Aname) VALUES (20, 'Лозовский Алексей')
INSERT INTO A (Aage, Aname) VALUES (20, 'Лозовский Алексей')

SELECT * FROM dbo.InsertedHistory