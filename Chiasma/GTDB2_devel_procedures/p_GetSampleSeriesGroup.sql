USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeriesGroup]    Script Date: 11/20/2009 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetSampleSeriesGroup]
	(@identifier VARCHAR(255),
	 @identifiable_id INTEGER = NULL,
	 @sample_series_group_type VARCHAR(32))

AS
BEGIN
SET NOCOUNT ON

SELECT 
	sample_series_group_id AS id,
	identifier,
	comment,
	identifiable_id,
	sample_series_group_type
FROM sample_series_group
WHERE 
	identifier = @identifier AND
	identifiable_id = @identifiable_id AND
	sample_series_group_type = @sample_series_group_type

SET NOCOUNT OFF
END
