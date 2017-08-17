USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateProjectGroup]    Script Date: 11/16/2009 13:38:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateProjectGroup] (@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

-- Create project group.
INSERT INTO project_group (identifier, comment)
VALUES (@identifier, NULL)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create project group with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Return created object.
SELECT 
	project_group_id AS id,
	identifier,
	comment
FROM project_group WHERE identifier = @identifier

SET NOCOUNT OFF
END
