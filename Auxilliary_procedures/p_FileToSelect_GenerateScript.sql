use Auxilliary
GO

/****** Object:  StoredProcedure [dbo].[p_FileToSelect]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Read contents of a file into a temp table and then perform a select on that table
-- File must have a single column
-- File path = 'E:\Edvards_share\Proc_refs\FileToSelect\Data.txt'
-- This is a shared folder, put in shortcut for easy use

-- More persons, a map table and personal folders

alter procedure p_FileToSelect_GenerateScript(
	 @number_cols int = 1,
	 @table_name varchar(255) = '#tmp'
)

as
begin
SET NOCOUNT ON

declare @col_name varchar(30)
declare @counter int
declare @cmd varchar(255)

set @counter = 1

set @cmd = 'create table ' + @table_name + ' (data varchar(255)'

while @counter < @number_cols begin
	set @col_name = 'data' + cast(@counter as varchar(30))
	set @cmd = @cmd + ',
	' + @col_name + ' varchar(255)'
	set @counter = @counter + 1
end


set @cmd = @cmd + ')
go

insert into ' + @table_name + '
exec Auxilliary.dbo.p_FileToSelect ' + cast(@number_cols as varchar(20)) + '
go

select * from ' + @table_name

select @cmd

SET NOCOUNT off
end
go


