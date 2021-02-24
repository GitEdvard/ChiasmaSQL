USE [Administration]
GO

/****** Object:  StoredProcedure [dbo].[p_Backup_Order_DevelLatestRelease]    Script Date: 2021-02-24 1:22:02 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



create procedure [dbo].[p_Backup_Order_DevelLatestRelease]
as
begin
SET NOCOUNT ON

backup database BookKeeping_devel to disk = 'D:\Proc_references\Devel_backups\Latest release\order_devel_backup.bak'
with init, skip


SET NOCOUNT off
end
GO


