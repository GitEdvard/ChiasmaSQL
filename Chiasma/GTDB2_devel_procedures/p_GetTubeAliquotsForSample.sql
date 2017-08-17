USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeAliquotsForSample]    Script Date: 11/20/2009 15:54:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_GetTubeAliquotsForSample](@sample_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_aliquot_sample_view
WHERE sample_id = @sample_id

SET NOCOUNT OFF
END

