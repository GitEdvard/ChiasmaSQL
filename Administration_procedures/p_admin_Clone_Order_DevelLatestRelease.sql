use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_admin_CloneGTDB2DevelLatestRelease]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Create a 'personal' devel database by cloning the common devel db backup in the merge folder
-- The database created will match the person calling this procedure
-- who must exists in tables map_devel_table and map_devel_user in Administration
-- Use procedure p_CreateDevelUserSQL if current user is not present in above tables

create procedure p_admin_Clone_Order_DevelLatestRelease(
	@devel_login varchar(255),
	@devel_db_version_nr int = null
)

as
begin
SET NOCOUNT ON

declare @devel_db_name varchar(255)
declare @sql varchar(max)
declare @sqltable table(sql varchar(max))
declare @counter int
declare @current_user varchar(20)
declare @current_login varchar(30)

-- Find 'personal' devel db name for current user
select @devel_db_name = devel_db_name from map_devel_table where login = @devel_login and operation_db_name = 'BookKeeping'

if isnull(@devel_db_name, '###') = '###' begin
	raiserror('Could not find devel db name for database BookKeeping (table map_devel_table in Administration)', 15,1)
end

if isnull(@devel_db_version_nr, -1) > -1 begin
	set @devel_db_name = @devel_db_name + cast( @devel_db_version_nr as varchar(10))
end

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Restore backup from latest release folder
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
set @sql = 
'if exists (select name from Administration.dbo.sysdatabases where name = ''' + @devel_db_name + ''') begin
	alter database ' + @devel_db_name + ' set single_user with rollback immediate
end
'

set @sql = @sql + 
'restore database ' + @devel_db_name + ' from disk = ''D:\Proc_references\Devel_backups\Latest release\order_devel_backup.bak''
with move ''BookKeeping_devel'' to ''D:\SQLUserDBData\' + @devel_db_name + '.MDF'',
move ''BookKeeping_devel_log''to ''D:\SQLUserDBTransLogs\' + @devel_db_name + '.ldf'',
replace, recovery

alter database ' + @devel_db_name + '  modify file (name = BookKeeping_devel, newname = ' + @devel_db_name + '_Data)
alter database ' + @devel_db_name + ' modify file (name = BookKeeping_devel_log, newname = ' + @devel_db_name + '_Log)

alter database ' + @devel_db_name + ' set multi_user
'

exec (@sql)

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Remove all owner roles associated with sql users beginning with 'User_'
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
set @sql = '
declare @owners table(db_user varchar(255), rn int)
declare @sql varchar(max)
declare @counter int
'

set @sql = @sql + 
'
use ' + @devel_db_name + '
insert into @owners
(db_user, rn)
select mp.name as database_user, ROW_NUMBER() over (order by mp.name)
from sys.database_role_members drm
  inner join sys.database_principals rp on (drm.role_principal_id = rp.principal_id)
  inner join sys.database_principals mp on (drm.member_principal_id = mp.principal_id)
where rp.name = ''db_owner'' and mp.name like ''User%'' and mp.type =  ''s''
'


set @sql = @sql + 'use ' + @devel_db_name + '
set @counter = 1
set @sql = ''''
while exists (select * from @owners where rn = @counter) begin
	select @sql = @sql + ''
	use ' + @devel_db_name + '
	alter role db_owner drop member '' + db_user
	from @owners where rn = @counter
	set @counter = @counter + 1
end
select @sql
'

insert into @sqltable 
(sql)
exec (@sql)

select @sql = sql from @sqltable

exec (@sql)

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Add current associated database user as db owner
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

if not exists( select * from map_devel_user where login = @devel_login) begin
	raiserror('Could not find matching user in devel-db specified login, %s', 15,1, @devel_login)
end

select @sql = '
declare @sql2 varchar(max)
set @sql2 = ''
use ' + @devel_db_name + '''
if not exists(select name from ' + @devel_db_name + '.sys.database_principals where type = ''s'' and name = ''' + devel_user + ''') begin
	set @sql2 = @sql2 + ''
	create user ' + devel_user + ' for login ' + @devel_login + '
	''
end
else begin
	set @sql2 = @sql2 + ''
	alter user ' + devel_user + ' with login = ' + @devel_login + '
	''
end
set @sql2 = @sql2 + ''
alter role db_owner add member ' + devel_user + '
grant alter any role to ' + devel_user + '''
select @sql2'
from map_devel_user where login = @devel_login

delete from @sqltable
insert into @sqltable
(sql)
exec (@sql)

select @sql = sql from @sqltable

exec (@sql)

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Add all members in map_table_user as datareaders
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
set @sql = ''
declare cur cursor local for
select login, devel_user from Administration.dbo.map_devel_user mdu
inner join master.sys.server_principals sp on mdu.login = sp.name
where sp.type = 's'

open cur

fetch next from cur into @current_login, @current_user

while @@FETCH_STATUS = 0 begin
	set @sql = @sql + '
	use ' + @devel_db_name + '
	if not exists(select name from ' + @devel_db_name + '.sys.database_principals where type = ''s'' and name = ''' + @current_user + ''') begin
		create user ' + @current_user + ' for login [' + @current_login + ']
	end
	alter role db_datareader add member ' + @current_user + '
	'
	fetch next from cur into @current_login, @current_user
end

close cur

deallocate cur

exec (@sql)



SET NOCOUNT off
end
go



