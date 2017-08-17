USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateFlowCellWell]    Script Date: 11/16/2009 13:36:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[p_CreateFlowCellWell](
	@flow_cell_id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER,
	@source_container_id INTEGER = NULL,
	@source_container_position_x INTEGER = NULL,
	@source_container_position_y INTEGER = NULL,
	@source_container_position_z INTEGER = NULL,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Create FlowCellWell.
INSERT INTO flow_cell_well
	(flow_cell_id,
	 position_x,
	 position_y,
	 source_container_id,
	 source_container_position_x,
	 source_container_position_y,
	 source_container_position_z,
	 comment
)
VALUES
	(@flow_cell_id,
	 @position_x,
	 @position_y,
	 @source_container_id,
	 @source_container_position_x,
	 @source_container_position_y,
	 @source_container_position_z,
	 @comment
)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create FlowCellWell', 15, 1)
	RETURN
END


SET NOCOUNT OFF
END
