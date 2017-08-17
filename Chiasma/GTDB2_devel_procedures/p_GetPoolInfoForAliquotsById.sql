USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoForAliquotsById]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPoolInfoForAliquotsById](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM 
	pool_info_for_aliquots_view pifa left outer join 
	pool_info_for_samples_prefix_view pifs on pifa.pool_info_for_samples_id = pifs.pifs_id
where id = @id
SET NOCOUNT OFF

END