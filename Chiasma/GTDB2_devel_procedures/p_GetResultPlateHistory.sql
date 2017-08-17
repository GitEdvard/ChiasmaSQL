USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetResultPlateHistory]    Script Date: 11/20/2009 16:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetResultPlateHistory](@project_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

--Selects information about result_plates deleted from
--project with the project id @project_id.

SELECT
	result_plate_id AS id,
	identifier AS identifier,
	authority_id AS owner,
	created AS created,
	description AS description,
	project_id,
	uploading_flag,
	changed_authority_id,
	changed_date,
	changed_action
FROM result_plate_history
WHERE project_id = @project_id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
