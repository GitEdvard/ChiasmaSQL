USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateWorkingSet]    Script Date: 11/16/2009 13:40:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateWorkingSet](
	@identifier VARCHAR(255),
	@working_set_type VARCHAR(255),
	@project_id INTEGER,
	@description VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

--Test
--Test2
DECLARE @wset_type_id INTEGER

-- Get wset_type_id for wset type
SELECT @wset_type_id = wset_type_id FROM wset_type_code WHERE name = @working_set_type
IF @wset_type_id IS NULL
BEGIN
	RAISERROR('wset_type_id for type %s was not found', 15, 1, @working_set_type)
	RETURN
END

-- Create working set.
INSERT INTO wset (identifier, project_id, authority_id, wset_type_id, description)
	VALUES (@identifier, @project_id,  dbo.fGetAuthorityId(), @wset_type_id, @description)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create working set with name: %s', 15, 1, @identifier)
	RETURN
END

SELECT 
	wset_id AS id,
	identifier,
	project_id,
	@working_set_type AS working_set_type,
	description
FROM wset
WHERE
	identifier = @identifier AND
	project_id = @project_id

SET NOCOUNT OFF
END
