USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlatesForWorkingSet]    Script Date: 11/20/2009 16:06:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetResultPlatesForWorkingSet](
	@id INTEGER,
	@identifier_filter VARCHAR (255) )

AS
BEGIN

SELECT 
	result_plate.result_plate_id AS id,
	result_plate.identifier AS identifier,
	result_plate.project_id AS project_id,
	result_plate.gt_method_id AS gt_method_id,
	result_plate.uploading_flag,
	result_plate.description AS description
FROM result_plate
INNER JOIN wset_member ON result_plate.result_plate_id = wset_member.identifiable_id
WHERE
	wset_member.wset_id = @id AND
	result_plate.identifier LIKE @identifier_filter
ORDER BY result_plate.identifier ASC

END
