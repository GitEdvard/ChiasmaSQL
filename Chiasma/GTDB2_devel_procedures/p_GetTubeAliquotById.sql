USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeAliquotById]    Script Date: 11/20/2009 15:54:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeAliquotById](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_aliquot_sample_view
WHERE id = @id

SET NOCOUNT OFF
END
