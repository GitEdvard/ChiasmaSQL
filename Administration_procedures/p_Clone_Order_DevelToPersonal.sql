use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_CloneGTDB2DevelLatestRelease]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Create a 'personal' devel database by cloning the common devel db backup in the release folder
-- The database created will match the person calling this procedure
-- who must exists in tables map_devel_table and map_devel_user in Administration
-- Use procedure p_admin_CreateDevelUserSQL if current user is not present in above tables

-- @version:	If the caller wants to have more than one devel databases. E.g. if @version = 2 and user
--				initials is 'ee', then a devel database with name GTDB2_devel_ee2 will be created. If there
--				is an existing database with name GTDB2_devel_ee, it will not be affected. 

create procedure p_Clone_Order_DevelToPersonal @version int = null, @latest_release bit = 1, @latest_merge bit = 0

as
begin
SET NOCOUNT ON

declare @devel_db_name varchar(255)
declare @sql varchar(max)
declare @sqltable table(sql varchar(max))
declare @counter int
declare @backup_file varchar(1024)


if @latest_merge = 1 begin
	set @backup_file = '''D:\Proc_references\Devel_backups\Latest merge\order_devel_backup.bak'''
end
if @latest_release = 1 begin
	set @backup_file = '''D:\Proc_references\Devel_backups\Latest release\order_devel_backup.bak'''
end

-- Find 'personal' devel db name for current user
select @devel_db_name = devel_db_name from map_devel_table where login = SYSTEM_USER and operation_db_name = 'BookKeeping'

if isnull(@devel_db_name, '###') = '###' begin
	raiserror('Could not find devel db name for database BookKeeping (table map_devel_table in Administration)', 15,1)
end

if isnull(@version, -1) > -1 begin
	set @devel_db_name = @devel_db_name + cast(@version as varchar(10))
end

-- Restore backup from latest release folder
set @sql = 
'if exists (select name from Administration.dbo.sysdatabases where name = ''' + @devel_db_name + ''') begin
	alter database ' + @devel_db_name + ' set single_user with rollback immediate
end
'

set @sql = @sql + 
'restore database ' + @devel_db_name + ' from disk = '+ @backup_file + '
with move ''BookKeeping_devel'' to ''D:\SQLUserDBData\' + @devel_db_name + '.MDF'',
move ''BookKeeping_devel_log''to ''D:\SQLUserDBTransLogs\' + @devel_db_name + '.ldf'',
replace, recovery

alter database ' + @devel_db_name + ' set multi_user
'

exec (@sql)

-- Remove all owner roles associated with sql users beginning with 'User_'
set @sql = '
declare @owners table(db_user varchar(255), rn int)
declare @sql varchar(max)
declare @counter int
'

if not exists( select * from map_devel_user where login = SYSTEM_USER) begin
	raiserror('Could not find matching user in devel-db for current system user', 15,1)
end


select @sql = @sql + 
'
use ' + @devel_db_name + '
insert into @owners
(db_user, rn)
select mp.name as database_user, ROW_NUMBER() over (order by mp.name)
from sys.database_role_members drm
  inner join sys.database_principals rp on (drm.role_principal_id = rp.principal_id)
  inner join sys.database_principals mp on (drm.member_principal_id = mp.principal_id)
where rp.name = ''db_owner'' and mp.name like ''User%'' and mp.type =  ''s'' 
and not mp.name = ''' + devel_user + '''
'
from map_devel_user where login = system_user


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


SET NOCOUNT off
end
go


