USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteSampleSeriesMapping]    Script Date: 11/20/2009 15:45:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteSampleSeriesMapping](
	@id INTEGER,
	@sample_series_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete sample series mapping.
DELETE FROM sample_series_mapping
WHERE
	sample_series_group_id = @id AND
	sample_series_id = @sample_series_id

SET NOCOUNT OFF
END
