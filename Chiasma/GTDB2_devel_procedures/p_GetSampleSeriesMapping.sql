USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeriesMapping]    Script Date: 11/20/2009 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetSampleSeriesMapping] (@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT sample_series_id
FROM sample_series_mapping
WHERE sample_series_group_id = @id

SET NOCOUNT OFF
END
