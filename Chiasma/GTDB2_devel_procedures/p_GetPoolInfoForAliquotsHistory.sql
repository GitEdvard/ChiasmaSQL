USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoForAliquotsHistory]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPoolInfoForAliquotsHistory](@pool_info_for_aliquots_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM 
	pool_info_for_aliquots_history_view 
where pool_info_for_aliquots_id = @pool_info_for_aliquots_id
order by changed_date asc
SET NOCOUNT OFF

END
