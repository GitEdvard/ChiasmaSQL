USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellWells]    Script Date: 11/20/2009 15:58:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellWells](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM flow_cell_well_view 
WHERE flow_cell_id = @id

SET NOCOUNT OFF
END


