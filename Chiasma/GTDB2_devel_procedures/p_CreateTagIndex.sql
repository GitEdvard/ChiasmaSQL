USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateTagIndex](
	@tag_index VARCHAR(255),
	@sequence VARCHAR(255),
	@tag_group_id int,
	@enabled bit = 1)

AS
BEGIN
SET NOCOUNT ON

declare @id int

-- Create State.
INSERT INTO tag_index
	(tag_index,
	 sequence,
	 tag_group_id,
	 enabled)
VALUES
	(@tag_index,
	 @sequence,
	 @tag_group_id,
	 @enabled)

set @id = scope_identity()

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create tag_index with index: %s', 15, 1, @tag_index)
	RETURN
END

-- Return tagGroup.
SELECT
	tag_index_id AS id,
	tag_index,
	sequence,
	tag_group_id,
	enabled
FROM tag_index
WHERE tag_index_id = @id

SET NOCOUNT OFF
END
