use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW tube_aliquot_sample_view AS
SELECT
	* 
FROM 
tube_aliquot_view tav
LEFT OUTER JOIN sample_prefix_view spv ON
tav.sample_id = spv.sample_sample_id
