use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_BackupDevelLatestRelease]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


alter procedure p_BackupDevelLatestRelease
as
begin
SET NOCOUNT ON

backup database gtdb2_devel to disk = 'D:\Proc_references\Devel_backups\Latest release\gtdb2_devel_backup.bak'
with init, skip


SET NOCOUNT off
end
go


