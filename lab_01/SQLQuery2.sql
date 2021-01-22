USE dbLAB01
GO

ALTER TABLE dbo.S ADD
	CONSTRAINT PK_S PRIMARY KEY (Sno)
GO

ALTER TABLE dbo.M ADD
	CONSTRAINT PK_M PRIMARY KEY (Mno)
GO

ALTER TABLE dbo.A ADD
	CONSTRAINT PK_A PRIMARY KEY (Ano)
GO

ALTER TABLE dbo.Sub ADD
	CONSTRAINT PK_SUB PRIMARY KEY (Subno),
	CONSTRAINT UK_SUB UNIQUE (Subname)
GO

ALTER TABLE dbo.U ADD
	CONSTRAINT PK_U PRIMARY KEY (Uno),
	CONSTRAINT FK_U_S FOREIGN KEY (Usub) REFERENCES dbo.Sub (Subno) on delete cascade
GO

ALTER TABLE dbo.A_S ADD
	CONSTRAINT PK_AS PRIMARY KEY (Ano, Sno),
	CONSTRAINT FK_AS_A FOREIGN KEY (Ano) REFERENCES dbo.A (Ano) on delete cascade,
	CONSTRAINT FK_AS_S FOREIGN KEY (Sno) REFERENCES dbo.S (Sno) on delete cascade
GO

ALTER TABLE dbo.S_S_M ADD
	CONSTRAINT PK_SSM PRIMARY KEY (Subno, Sno, Mno),
	CONSTRAINT FK_SSM_S FOREIGN KEY (Subno) REFERENCES dbo.Sub (Subno) on delete cascade,
	CONSTRAINT FK_SSM_SH FOREIGN KEY (Sno) REFERENCES dbo.S (Sno) on delete cascade,
	CONSTRAINT FK_SSM_M FOREIGN KEY (Mno) REFERENCES dbo.M (Mno) on delete cascade
GO

ALTER TABLE dbo.A_M ADD
	CONSTRAINT PK_AM PRIMARY KEY (Ano, Mno),
	CONSTRAINT FK_AM_A FOREIGN KEY (Ano) REFERENCES dbo.A (Ano) on delete cascade,
	CONSTRAINT FK_AM_M FOREIGN KEY (Mno) REFERENCES dbo.M (Mno) on delete cascade
GO

ALTER TABLE dbo.S ADD
	CONSTRAINT Sseasons_chk CHECK (Sseasons > 0),
	CONSTRAINT Srate_chk CHECK (Srate >= 0 AND Srate <= 10)
GO

ALTER TABLE dbo.M ADD
	CONSTRAINT Mseasons_chk CHECK (Mlength > 0),
	CONSTRAINT Mrate_chk CHECK (Mrate >= 0 AND Mrate <= 10)
GO

ALTER TABLE dbo.A ADD
	CONSTRAINT Aage_chk CHECK (Aage > 0 and Aage < 100)
GO

ALTER TABLE dbo.U ADD
	CONSTRAINT Uage_chk CHECK (Uage > 0 and Uage < 100)	
GO

--ALTER TABLE dbo.Sub ADD
--	CONSTRAINT Subprice_chk CHECK (Subprice > 0),
--	CONSTRAINT Subname_chk CHECK (Subname = 'Золотая' OR Subname = 'Серебряная' OR Subname = 'Платиновая')
--	Subname = 'Платиновая')
--GO 


CREATE RULE dbo.Country_rule
AS
	@country IN ('Австралия', 'Германия', 'Испания', 'Италия',
           'Франция', 'Россия', 'Китай', 'Америка', 'Англия')
GO 
EXEC sp_bindrule 'Country_rule', 'dbo.S.Sctry'
EXEC sp_bindrule 'Country_rule', 'dbo.M.Mctry'
GO


CREATE RULE dbo.Genre_rule
AS
	@genre IN ('Драма', 'Мелодрама', 'Комедия', 'Трагедия',
         'Ситкома', 'Детектив', 'Триллер', 'Ужасы',
         'Слешер','Арт-хаус', 'Фантастика', 'Фентези')
GO 
EXEC sp_bindrule 'Country_rule', 'dbo.S.Sgenre'
EXEC sp_bindrule 'Country_rule', 'dbo.M.Mgenre'
GO