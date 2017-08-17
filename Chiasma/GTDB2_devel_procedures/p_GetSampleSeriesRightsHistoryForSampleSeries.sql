USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeriesRightsHistoryForSampleSeries]    Script Date: 11/20/2009 16:07:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetSampleSeriesRightsHistoryForSampleSeries]( @sample_series_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	authority_group.identifiable_id AS sample_series_id,
	authority_mapping_history.authority_id AS user_id,
	authority_mapping_history.changed_date,
	authority_mapping_history.changed_authority_id,
	authority_mapping_history.changed_action
FROM authority_mapping_history
INNER JOIN authority_group ON authority_group.authority_group_id = authority_mapping_history.authority_group_id
WHERE authority_group.authority_group_type = 'SampleSeries'
AND authority_group.identifiable_id = @sample_series_id 
ORDER BY authority_mapping_history.changed_date ASC

SET NOCOUNT OFF
END
