use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_admin_GrantExecuteThis]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Execute 'Grant Execute' to a set of procedures in the Administration db to the role 'develuser'.
-- The set of procedures is defined as:
-- All stored procedures (or functions) declared by a user (not ms) 
-- The procedure no not begin with 'p_admin'

create procedure p_admin_GrantExecuteThis
as
begin
SET NOCOUNT ON


declare @name varchar(255)
declare @db_name varchar(255)
declare @str varchar(max)

declare cur cursor local for
SELECT 'GRANT EXECUTE ON [' + name + '] TO develuser'
FROM sys.all_objects
WHERE is_ms_shipped = 0
AND (type = 'P' or type = 'FN')
and not name like 'p_admin_%'
ORDER BY name

open cur

fetch next from cur into @name

while @@FETCH_STATUS = 0 begin
	exec (@name)
	fetch next from cur into @name
end

close cur
deallocate cur

SET NOCOUNT off
end
go


