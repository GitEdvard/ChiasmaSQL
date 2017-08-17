use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_DeleteDevelUserSQL]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- @user_name should either match a windows login without domain name, or a sql user name
-- Generate script to delete all database users and the login

create procedure p_DeleteDevelUserSQL(@user_name varchar(255))
as
begin
SET NOCOUNT ON

declare @counter int
declare @command1 varchar(max)
declare @str varchar(max)
declare @sqltable table(str varchar(max))
declare @dbs table(db varchar(255), rn int)

insert into @dbs
(db, rn)
select name, ROW_NUMBER() over (order by name desc) from sys.databases


-- Generate scripts

set @counter = 1

set @str = 'declare @command varchar(max)
set @command = ''''
'

while exists( select db from @dbs where rn = @counter)
begin
	-- Drop and sql user
	select @str = @str  + 
		'if exists(SELECT name FROM ' + db + '.sys.database_principals where (type = ''s'') and name = ''User_' + @user_name + ''')
		begin
			set @command = @command + 
			''
			use ' + db + '
			drop user User_' + @user_name + '''
		end
		' 
	from @dbs where rn = @counter


	set @counter = @counter + 1
end


-- drop sql login
select @str = @str + 
'if exists(select name from master.sys.server_principals where type = ''s'' and name = ''' + @user_name + ''')
begin
	set @command = @command + ''
	use master
	drop login ' + @user_name + ' 
	''
end
'

set @str = @str + 'select @command'

insert into @sqltable
exec (@str)

select @str = str from @sqltable

select (@str)



SET NOCOUNT off
end
go


