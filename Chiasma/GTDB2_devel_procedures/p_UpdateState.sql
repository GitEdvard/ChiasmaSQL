USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateState]    Script Date: 11/20/2009 16:30:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateState](
	@id SMALLINT,
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL,
	@enabled bit, 
	@tag varchar(30) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update state.
UPDATE state SET
	identifier = @identifier,
	comment = @comment,
	enabled = @enabled,
	tag = @tag
WHERE state_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update state with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF

END
