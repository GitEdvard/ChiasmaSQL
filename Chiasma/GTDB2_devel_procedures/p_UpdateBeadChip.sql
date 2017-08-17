USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateBeadChip]    Script Date: 11/20/2009 16:27:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateBeadChip](
	@id INTEGER,
	@identifier VARCHAR (255),
	@status VARCHAR (30),
	@status_changed BIT,
	@comment VARCHAR(1024) = NULL)

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

-- Update BeadChip.
UPDATE bead_chip
SET
	identifier = @identifier,
	status = @status,
	comment = @comment
WHERE bead_chip_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update BeadChip with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
