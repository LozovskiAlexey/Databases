BULK INSERT dbLAB01.dbo.A
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\actor_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.U
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\user_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.M
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\movie_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.S
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\show_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.Sub
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\sub_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.A_M
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\actor_movie_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.A_S
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\actor_show_data.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO


BULK INSERT dbLAB01.dbo.S_S_M
FROM 'C:\Users\mrado\OneDrive\Desktop\Labs\semester5\DB\lab_01\lab_01\lab_01\generate_sub_type.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = ', ', ROWTERMINATOR ='\n');
GO