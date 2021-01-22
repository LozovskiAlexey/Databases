use dbRK2
go 

CREATE PROCEDURE triggerSummary (
@name varchar(100), 
@res int OUTPUT
)
AS
begin 
	select * into res from sys.objects where name = N'trg' and type = 'TR';
	if exists (select * from sys.objects where name = N'trg' and type = 'TR')
		begin 
			drop trigger dbo.trg;
		end;
		return @res;
end;
