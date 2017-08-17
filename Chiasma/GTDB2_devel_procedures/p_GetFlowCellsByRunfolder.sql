USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellsByRunfolder]    Script Date: 11/20/2009 16:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellsByRunfolder]( @runfolder VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	flow_cell_id AS id,
	bead_chip_type_id,
	identifier,
	comment,
	status,
	flow_cell_type,
	no_of_cycles,
	is_clustered,
	runfolder,
	is_analysed,
	is_failed,
	is_sequenced
FROM flow_cell
WHERE runfolder LIKE @runfolder
ORDER BY identifier ASC

SET NOCOUNT OFF
END
