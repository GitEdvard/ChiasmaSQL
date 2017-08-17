USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlatesForProject]    Script Date: 11/20/2009 16:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetResultPlatesForProject](
	@id INTEGER,
	@identifier_filter VARCHAR (255) )

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
WHERE
	project_id = @id AND
	identifier LIKE @identifier_filter
ORDER BY identifier ASC

END
