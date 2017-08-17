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

alter procedure p_FileToSelect(
	 @number_cols int = 1
)

as
begin
SET NOCOUNT ON

declare @col_name varchar(30)
declare @counter int
declare @cmd varchar(max)

set @counter = 1

create table #tmp (data varchar(255))

while @counter < @number_cols begin
	set @col_name = 'data' + cast(@counter as varchar(30))
	set @cmd = 'alter table #tmp add ' + @col_name + ' varchar(255)'
	exec (@cmd)
	set @counter = @counter + 1
end

declare @path varchar(512)

if dbo.fn_FileExists('E:\Edvards_share2\Proc_refs\FileToSelect\Data.txt') = 1 begin 
	set @path = 'E:\Edvards_share2\Proc_refs\FileToSelect\Data.txt'
end
else begin
	set @path = '\\mm-wchs001\Edvards_share2\Proc_refs\FileToSelect\Data.txt'
end


set @cmd = 
'bulk insert #tmp from ''' + @path + 
''' with (
	fieldterminator = ''\t'',
	rowterminator = ''\n''
)

select * from #tmp
'
exec (@cmd)

SET NOCOUNT off
end
go


