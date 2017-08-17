USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateFlowCell]    Script Date: 11/20/2009 16:27:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateFlowCell](
	@id INTEGER,
	@identifier VARCHAR (255),
	@status VARCHAR (30),
	@status_changed BIT,
	@comment VARCHAR(1024) = NULL
)

AS
BEGIN
SET NOCOUNT ON

IF @status_changed = 1 AND @status = 'Active'
BEGIN
	EXECUTE p_RestoreGenericContainer @id
END

IF @status_changed = 1 AND @status = 'Disposed'
BEGIN
	EXECUTE p_DisposeGenericContainer @id
END

-- Update FlowCell.
UPDATE flow_cell
SET
	identifier = @identifier,
	status = @status,
	comment = @comment
WHERE flow_cell_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update FlowCell with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
