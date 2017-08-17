USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlateByIdentifier]    Script Date: 11/20/2009 16:05:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetResultPlateByIdentifier]( @identifier VARCHAR (255) )

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
WHERE identifier = @identifier

END
