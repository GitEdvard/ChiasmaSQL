USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateTagGroup](
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL,
	@enabled bit = 1)

AS
BEGIN
SET NOCOUNT ON

declare @id int

-- Create State.
INSERT INTO tag_group
	(identifier,
	 comment,
	 enabled)
VALUES
	(@identifier,
	 @comment,
	 @enabled)

set @id = scope_identity()

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create tag_group with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Return tagGroup.
SELECT
	tag_group_id AS id,
	identifier,
	comment,
	enabled
FROM tag_group
WHERE tag_group_id = @id

SET NOCOUNT OFF
END
