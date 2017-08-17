USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeriesForUser]    Script Date: 11/20/2009 16:06:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Get id for all sample series that the user has access rights to.
CREATE PROCEDURE [dbo].[p_GetSampleSeriesForUser]( @user_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

-- Get all sample series that the user has access rights to. 
SELECT
	authority_group.identifiable_id AS sample_series_id
FROM authority_group
INNER JOIN authority_mapping ON authority_group.authority_group_id = authority_mapping.authority_group_id 
WHERE 
	authority_group.authority_group_type = 'SampleSeries' AND
	authority_mapping.authority_id = @user_id

UNION

-- Get all sample series for all projects that the user has access rights to. 
SELECT
	sample_series_mapping.sample_series_id AS sample_series_id
FROM sample_series_mapping
INNER JOIN sample_series_group ON sample_series_mapping.sample_series_group_id = sample_series_group.sample_series_group_id
INNER JOIN authority_group ON sample_series_group.identifiable_id = authority_group.identifiable_id
INNER JOIN authority_mapping ON authority_group.authority_group_id = authority_mapping.authority_group_id 
WHERE
	sample_series_group.sample_series_group_type = 'Project' AND
	authority_group.authority_group_type = 'Project' AND
	authority_mapping.authority_id = @user_id

SET NOCOUNT OFF
END
