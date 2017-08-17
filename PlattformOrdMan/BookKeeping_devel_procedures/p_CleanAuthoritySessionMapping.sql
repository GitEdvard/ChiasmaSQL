USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CleanAuthoritySessionMapping]    Script Date: 11/20/2009 16:30:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CleanAuthoritySessionMapping]

AS
BEGIN
SET NOCOUNT ON

declare @tmp as table(
spid int,
ecid int,
status varchar(255),
logname varchar(255),
hostname varchar(255),
blk bit,
dbname varchar(255),
cmd varchar(255),
request_id int
)

insert into @tmp
exec sp_who

delete from authority_session_mapping
where session_id not in (
select t.spid as session_id from @tmp t
	inner join sys.dm_exec_sessions es 
	on t.spid = es.session_id
where es.is_user_process = 1 and t.dbname = db_name())

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to clean authority mapping : %d', 15, 1)
	RETURN
END



SET NOCOUNT OFF
END
