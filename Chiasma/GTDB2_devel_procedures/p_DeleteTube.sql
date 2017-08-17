USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteTube]    Script Date: 11/20/2009 15:46:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteTube](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM contents WHERE child_container_id = @id

UPDATE sample SET tube_id = NULL WHERE tube_id = @id

DELETE FROM tube_aliquot WHERE tube_id = @id

DELETE FROM pool_info_for_aliquots where tube_id = @id

DELETE FROM tube WHERE tube_id = @id

DELETE FROM generic_container WHERE generic_container_id = @id


SET NOCOUNT OFF
END
