USE [Administration]
GO

/****** Object:  StoredProcedure [dbo].[p_Backup_Order_DevelLatestMerge]    Script Date: 2021-02-24 1:20:17 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE procedure [dbo].[p_Backup_Order_DevelLatestMerge]
as
begin
SET NOCOUNT ON

backup database BookKeeping_devel to disk = 'D:\Proc_references\Devel_backups\Latest merge\order_devel_backup.bak'
with init, skip


SET NOCOUNT off
end
GO


