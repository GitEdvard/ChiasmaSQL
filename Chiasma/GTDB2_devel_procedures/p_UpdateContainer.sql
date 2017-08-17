USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateContainer]    Script Date: 11/20/2009 16:27:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateContainer](
	@id INTEGER,
	@identifier VARCHAR (255),
	@status VARCHAR (30),
	@status_changed BIT,
	@comment VARCHAR(2048) = NULL)

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

UPDATE container
SET
	identifier = @identifier,
	status = @status,
	comment = @comment
WHERE container_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update container with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
