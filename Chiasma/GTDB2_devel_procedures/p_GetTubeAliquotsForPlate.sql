USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAliquots]    Script Date: 11/20/2009 15:54:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeAliquotsForPlate](@plate_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_aliquot_sample_view
WHERE plate_id = @plate_id

SET NOCOUNT OFF
END
