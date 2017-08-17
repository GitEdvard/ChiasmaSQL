use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_GrantExecute]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

create procedure p_GrantExecute (
	@db_name varchar(255),
	@role_name varchar(255)
)
as
begin
SET NOCOUNT ON


declare @name varchar(255)
declare @str varchar(max)

declare cur cursor local for
SELECT 'GRANT EXECUTE ON [' + name + '] TO ' + @role_name
FROM sys.all_objects
WHERE is_ms_shipped = 0
AND (type = 'P' or type = 'FN')
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


