use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_BackupDevelLatestRelease]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create procedure p_Backup_Order_DevelLatestRelease
as
begin
SET NOCOUNT ON

backup database BookKeeping_devel to disk = 'D:\Proc_references\Devel_backups\Latest release\order_devel_backup.bak'
with init, skip


SET NOCOUNT off
end
go


