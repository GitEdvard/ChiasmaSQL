USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateWorkingSetComment]    Script Date: 11/20/2009 16:31:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateWorkingSetComment](
	@id INTEGER,
	@description VARCHAR(2000) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update working set.
UPDATE wset SET
	description = @description
WHERE wset_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update working set with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
