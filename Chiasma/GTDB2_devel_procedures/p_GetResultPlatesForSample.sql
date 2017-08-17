USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlatesForSample]    Script Date: 11/20/2009 16:06:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetResultPlatesForSample](@sample_id INTEGER)

AS
BEGIN

SELECT 
	result_plate_id AS id,
	identifier,
	project_id,
	gt_method_id,
	uploading_flag,
	description
FROM result_plate
WHERE result_plate_id IN
	(SELECT result_plate_id FROM genotype WHERE sample_id = @sample_id)
ORDER BY identifier ASC

END
