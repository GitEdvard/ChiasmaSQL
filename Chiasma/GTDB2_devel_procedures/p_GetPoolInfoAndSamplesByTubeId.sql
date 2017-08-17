USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoAndSamplesByTubeId]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPoolInfoAndSamplesByTubeId](@tube_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM 
	pool_info_for_samples_view 
where tube_id = @tube_id
SET NOCOUNT OFF

SELECT sv.* FROM 
	sample_view sv inner join pool_info_for_samples pifs 
	on sv.pool_info_for_samples_id = pifs.pool_info_for_samples_id
where pifs.tube_id = @tube_id

END
