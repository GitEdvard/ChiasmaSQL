use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_CloneGTDB2DevelLatestReleaseAdmin]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Create a 'personal' devel database by cloning the common devel db backup in the merge folder
-- The database created will match the person calling this procedure
-- who must exists in tables map_devel_table and map_devel_user in master
-- User procedure p_CreateDevelUserSQL if current user is not present in above tables

create procedure p_CloneGTDB2DevelLatestReleaseAdmin(
	@devel_login varchar(255)
)

as
begin
SET NOCOUNT ON

declare @devel_db_name varchar(255)
declare @sql varchar(max)
declare @sqltable table(sql varchar(max))
declare @counter int
-- Find 'personal' devel db name for current user
select @devel_db_name = devel_db_name from map_devel_table where login = @devel_login and operation_db_name = 'gtdb2'

if isnull(@devel_db_name, '###') = '###' begin
	raiserror('Could not find devel db name for database GTDB2 (table map_devel_table in master)', 15,1)
end

-- Restore backup from latest merge folder
set @sql = 
'if exists (select name from master.dbo.sysdatabases where name = ''' + @devel_db_name + ''') begin
	alter database ' + @devel_db_name + ' set single_user with rollback immediate
end
'

set @sql = @sql + 
'restore database ' + @devel_db_name + ' from disk = ''D:\Scripts\Proc_references\Devel_backups\Latest release\gtdb2_devel2_backup.bak''
with move ''GTDB2_devel2_Data'' to ''D:\SQLUserDBData\' + @devel_db_name + '.MDF'',
move ''GTDB2_devel2_Log''to ''D:\SQLUserDBTransLogs\' + @devel_db_name + '.ldf'',
replace, recovery

alter database ' + @devel_db_name + '  modify file (name = GTDB2_devel2_Data, newname = ' + @devel_db_name + '_Data)
alter database ' + @devel_db_name + ' modify file (name = GTDB2_devel2_Log, newname = ' + @devel_db_name + '_Log)

alter database ' + @devel_db_name + ' set multi_user
'

exec (@sql)

-- Remove all owner roles associated with sql users beginning with 'User_'
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

-- Add current associated database user as db owner

if not exists( select * from map_devel_user where login = SYSTEM_USER) begin
	raiserror('Could not find matching user in devel-db for current system user', 15,1)
end

select @sql = '
alter role db_owner add member ' + devel_user
from map_devel_user where login = SYSTEM_USER

exec (@sql)

SET NOCOUNT off
end
go


