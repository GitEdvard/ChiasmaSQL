use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_admin_DeleteDevelUser]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- @login_name should either match a windows login with domain name, or a sql user name
-- Generate script to delete all database users and the login

alter procedure p_admin_DeleteDevelUser(@login_name varchar(255))
as
begin
SET NOCOUNT ON

declare @counter int
declare @command1 varchar(max)
declare @str varchar(max)
declare @sqltable table(str varchar(max))
declare @dbs table(db varchar(255), rn int)
declare @db_user_name varchar(255)

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Find out db user name
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if exists (select * from master.sys.server_principals where name = @login_name and type = 's') begin
	select @db_user_name = devel_user from map_devel_user where login = @login_name
end

if exists(select * from master.sys.server_principals where name = @login_name and type = 'u') begin
	select @db_user_name = db_user_name from client_logins where login = @login_name
end

if isnull(@db_user_name, '') = '' begin
	raiserror('db user name could not be found', 15,1)
	return	
end	

insert into @dbs
(db, rn)
select name, ROW_NUMBER() over (order by name desc) from sys.databases


--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Drop database users
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
set @counter = 1

set @str = 'declare @command varchar(max)
set @command = ''''
'

while exists( select db from @dbs where rn = @counter)
begin
	-- Drop and sql user
	select @str = @str  + 
		'if exists(SELECT name FROM ' + db + '.sys.database_principals where name = ''' + @db_user_name + ''')
		begin
			set @command = @command + 
			''
			use ' + db + '
			drop user ' + @db_user_name + '''
		end
		' 
	from @dbs where rn = @counter


	set @counter = @counter + 1
end


--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- drop sql login
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
select @str = @str + 
'if exists(select name from master.sys.server_principals where name = ''' + @login_name + ''')
begin
	set @command = @command + ''
	use master
	drop login [' + @login_name + ']
	''
end
'

set @str = @str + 'select @command'

insert into @sqltable
exec (@str)

select @str = str from @sqltable

exec (@str)

delete from map_devel_table where login = @login_name

delete from map_devel_user where login = @login_name


SET NOCOUNT off
end
go


