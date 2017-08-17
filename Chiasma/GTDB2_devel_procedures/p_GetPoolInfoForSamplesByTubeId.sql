USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoForSamplesByTubeId]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPoolInfoForSamplesByTubeId](@tube_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM 
	pool_info_for_samples_view 
where tube_id = @tube_id
SET NOCOUNT OFF

END
