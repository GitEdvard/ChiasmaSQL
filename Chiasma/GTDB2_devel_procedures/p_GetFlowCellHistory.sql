USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellHistory]    Script Date: 11/20/2009 15:58:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellHistory](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	flow_cell_id AS id,
	bead_chip_type_id,
	identifier,
	status,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM flow_cell_history
WHERE flow_cell_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
