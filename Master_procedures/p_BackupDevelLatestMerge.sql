use Administration
GO

/****** Object:  StoredProcedure [dbo].[p_BackupDevelLatestMerge]    Script Date: 2014-02-27 14:07:56 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


create procedure p_BackupDevelLatestMerge
as
begin
SET NOCOUNT ON

backup database gtdb2_devel2 to disk = 'D:\Scripts\Proc_references\Devel_backups\Latest merge\gtdb2_devel2_backup.bak'
with init, skip


SET NOCOUNT off
end
go


