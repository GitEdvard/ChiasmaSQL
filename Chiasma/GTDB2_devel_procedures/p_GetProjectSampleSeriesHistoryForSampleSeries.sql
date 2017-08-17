USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectSampleSeriesHistoryForSampleSeries]    Script Date: 11/20/2009 16:05:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetProjectSampleSeriesHistoryForSampleSeries]( @sample_series_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	sample_series_group.identifiable_id AS project_id,
	sample_series_mapping_history.sample_series_id,
	sample_series_mapping_history.changed_date,
	sample_series_mapping_history.changed_authority_id,
	sample_series_mapping_history.changed_action
FROM sample_series_mapping_history
INNER JOIN sample_series_group ON sample_series_group.sample_series_group_id = sample_series_mapping_history.sample_series_group_id
WHERE sample_series_group.sample_series_group_type = 'Project'
AND sample_series_mapping_history.sample_series_id = @sample_series_id 
ORDER BY sample_series_mapping_history.changed_date ASC

SET NOCOUNT OFF
END
