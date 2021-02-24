use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_CloneGTDB2DevelLatestRelease]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


-- Restore GTDB2_devel from backup. 
-- Parameters:
-- @latest_version			Restores from the latest release backup
-- @latest_merge			Restores from the latest merge backup

create procedure p_RestoreOrderDevel @latest_release bit = 1, @latest_merge bit = 0

as
begin
SET NOCOUNT ON

declare @devel_db_name varchar(255)
declare @sql varchar(max)
declare @backup_file varchar(1024)

set @devel_db_name = 'BookKeeping_devel'

if @latest_merge = 1 begin
	set @backup_file = '''D:\Proc_references\Devel_backups\Latest merge\order_devel_backup.bak'''
end
if @latest_release = 1 begin
	set @backup_file = '''D:\Proc_references\Devel_backups\Latest release\order_devel_backup.bak'''
end

-- Restore backup from latest release folder
set @sql = 
'if exists (select name from Administration.dbo.sysdatabases where name = ''' + @devel_db_name + ''') begin
	alter database ' + @devel_db_name + ' set single_user with rollback immediate
end
'

set @sql = @sql + 
'restore database ' + @devel_db_name + ' from disk = '+ @backup_file + '
with 
replace, recovery

alter database ' + @devel_db_name + ' set multi_user
'

--select @sql
--return

exec (@sql)


SET NOCOUNT off
end
go


