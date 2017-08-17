USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeriesGroups]    Script Date: 11/20/2009 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetSampleSeriesGroups]

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
WHERE identifiable_id IS NULL
ORDER BY identifier ASC

SET NOCOUNT OFF
END
