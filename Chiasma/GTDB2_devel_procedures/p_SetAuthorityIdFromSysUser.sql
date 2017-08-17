USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_SetAuthorityIdFromSysUser]    Script Date: 11/20/2009 16:30:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_SetAuthorityIdFromSysUser](
	@barcode varchar(255)
)

AS
BEGIN
SET NOCOUNT ON

declare @authority_id int
declare @old_authority_id int
declare @session_id int

-- Get authroity-id from the barcode
select @authority_id = ib.identifiable_id
from internal_barcode ib
	inner join kind k
		on k.kind_id = ib.kind_id and k.name = 'authority'
where ib.code = @barcode

if isnull(@authority_id, -1) = -1
begin
	raiserror('Barcode %d could not be linked to a user!', 15, 1, @barcode)
	return
end

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
	(getdate(), @old_authority_id, @authority_id, @session_id)

	update authority_session_mapping set
		session_id = @session_id,
		authority_id = @authority_id
	where session_id = @session_id
end
else
begin
	insert into authority_session_mapping
	(session_id, authority_id)
	values
	(@session_id, @authority_id)
end



IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to set authority mapping with barcode: %d', 15, 1, @barcode)
	RETURN
END

select authority_id 
from authority_session_mapping
where session_id = @session_id

SET NOCOUNT OFF
END
