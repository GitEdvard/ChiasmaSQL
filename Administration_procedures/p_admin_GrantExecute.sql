use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_admin_GrantExecute]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Execute 'Grant Execute' to all stored procedures in a db to the specified role name
-- Parameters:
-- @db_name			Name of the database
-- @role_name		Name of the database role

alter procedure p_admin_GrantExecute (
	@db_name varchar(255),
	@role_name varchar(255)
)
as
begin
SET NOCOUNT ON

declare @sql varchar(max)

set @sql = '
use ' + @db_name + '
declare @name varchar(255)
declare cur cursor local for
SELECT ' + Char(39) + 'GRANT EXECUTE ON [' + char(39) + ' + name + ' + char(39) + '] TO ' + @role_name + char(39) + ' 
FROM  sys.all_objects
WHERE is_ms_shipped = 0
AND (type = ' + CHar(39) + 'P'+ char(39) + ' or type = ' + char(39) + 'FN' + char(39) + ')
ORDER BY name

open cur

fetch next from cur into @name

while @@FETCH_STATUS = 0 begin
	exec (@name)
--	select @name
	fetch next from cur into @name
end

close cur
deallocate cur'

exec (@sql)

SET NOCOUNT off
end
go


