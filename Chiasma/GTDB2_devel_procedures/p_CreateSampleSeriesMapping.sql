USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSampleSeriesMapping]    Script Date: 11/16/2009 13:39:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateSampleSeriesMapping](
	@id INTEGER,
	@sample_series_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Create sample series mapping.
INSERT INTO sample_series_mapping (sample_series_group_id, sample_series_id)
VALUES (@id, @sample_series_id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create sample series mapping with sample series group id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
