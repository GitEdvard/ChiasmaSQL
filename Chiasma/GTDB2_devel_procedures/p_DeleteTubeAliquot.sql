USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteTubeAliquot]    Script Date: 11/20/2009 15:46:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeleteTubeAliquot](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM tube_aliquot 
WHERE tube_aliquot_id = @id

SET NOCOUNT OFF
END
