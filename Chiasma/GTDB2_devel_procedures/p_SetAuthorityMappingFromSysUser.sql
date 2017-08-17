USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_SetAuthorityMappingFromSysUser]    Script Date: 11/20/2009 16:30:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_SetAuthorityMappingFromSysUser]

AS
BEGIN
SET NOCOUNT ON

declare @old_authority_id int
declare @session_id int

-- Get process id for this session
set @session_id = @@spid

if isnull(@session_id, -1) = -1
begin
	raiserror('Session id could not be retrieved', 15, 1)
	return
end

-- Update authority_mapping
select @old_authority_id = authority_id 
from authority_session_mapping 
where session_id = @session_id


-- First check if the session id already exists in the authority_session-mapping table,
-- if so, update the table and write a row in the conflict row
-- else, insert a new row in the authority_session_mapping table
if not isnull(@old_authority_id, -1) = -1
begin
	insert into authority_session_conflict_logg
	(conflict_date, old_authority_id, new_authority_id, session_id)
	values
	(getdate(), @old_authority_id, dbo.fGetAuthorityIdFromSysUser(), @session_id)

	update authority_session_mapping set
		session_id = @session_id,
		authority_id = dbo.fGetAuthorityIdFromSysUser()
	where session_id = @session_id
end
else
begin
	insert into authority_session_mapping
	(session_id, authority_id)
	values
	(@session_id, dbo.fGetAuthorityIdFromSysUser())
end



IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to set authority mapping from sys user', 15, 1)
	RETURN
END

select authority_id 
from authority_session_mapping
where session_id = @session_id

SET NOCOUNT OFF
END
