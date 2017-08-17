USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeletePoolInfoForSamples]    Script Date: 11/20/2009 15:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DeletePoolInfoForSamples](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

delete from pool_info_for_samples where pool_info_for_samples_id = @id

SET NOCOUNT OFF
END
