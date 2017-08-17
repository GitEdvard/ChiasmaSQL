USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetProjectsForFlowCellDisc]    Script Date: 11/20/2009 16:05:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetProjectsForFlowCellDisc](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT 
p.project_id as id,
p.identifier,
p.qcdb_id,
p.comment
FROM
project p,
flow_cell_disc_project_link fcdpl
WHERE
fcdpl.flow_cell_disc_id = @id AND
fcdpl.project_id = p.project_id

SET NOCOUNT OFF
END
