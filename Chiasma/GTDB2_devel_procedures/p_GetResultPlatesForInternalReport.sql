USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlatesForInternalReport]    Script Date: 11/20/2009 16:05:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetResultPlatesForInternalReport]( @id INTEGER )

AS
BEGIN

SELECT 
	rp.result_plate_id AS id,
	rp.identifier AS identifier,
	rp.project_id AS project_id,
	rp.gt_method_id AS gt_method_id,
	rp.uploading_flag,	
	rp.description AS description
FROM result_plate rp
	INNER JOIN internal_report_result_plate irrp ON irrp.result_plate_id = rp.result_plate_id
WHERE
irrp.internal_report_id = @id
ORDER BY rp.identifier ASC

END
