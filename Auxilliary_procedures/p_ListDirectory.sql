use Auxilliary
go

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

alter procedure p_ListDirectory(
	@db_name varchar(255)
)
as 
begin
	declare @path varchar(1024)

	set @path = 'E:\ChiasmaBulkFiles\' + @db_name + '\'

	exec master.sys.xp_dirtree @path, 1, 1


	SET NOCOUNT off
end
go
