USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoAndAliquotsByTubeId]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPoolInfoAndAliquotsByTubeId](@tube_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM 
	pool_info_for_aliquots_view 
where tube_id = @tube_id
SET NOCOUNT OFF

SELECT * FROM 
	tube_aliquot_sample_view 
where tube_id = @tube_id

END
