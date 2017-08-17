USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoForSamplesById]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPoolInfoForSamplesById](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM 
	pool_info_for_samples_view 
where id = @id
SET NOCOUNT OFF

END
