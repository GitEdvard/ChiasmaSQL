USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateState]    Script Date: 11/20/2009 16:30:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateTagIndex](
	@id INT,
	@tag_index varchar(255),
	@sequence VARCHAR(255),
	@tag_group_id int,
	@enabled bit)

AS
BEGIN
SET NOCOUNT ON

-- Update state.
UPDATE tag_index SET
	tag_index = @tag_index,
	sequence = @sequence,	
	tag_group_id = @tag_group_id,
	enabled = @enabled
WHERE tag_index_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update TagIndex with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF

END
