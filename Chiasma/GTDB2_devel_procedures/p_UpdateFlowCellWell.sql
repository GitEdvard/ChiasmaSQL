USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateFlowCellWell]    Script Date: 11/20/2009 16:27:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateFlowCellWell](
	@flow_cell_id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER,
	@source_container_id INTEGER = NULL,
	@source_container_position_x INTEGER = NULL,
	@source_container_position_y INTEGER = NULL,
	@source_container_position_z INTEGER = NULL,
	@comment VARCHAR(1024) = NULL
)

AS
BEGIN
SET NOCOUNT ON

-- Update FlowCell well.
UPDATE flow_cell_well SET
	source_container_id = @source_container_id,
	source_container_position_x = @source_container_position_x,
	source_container_position_y = @source_container_position_y,
	source_container_position_z = @source_container_position_z,
	comment = @comment
WHERE flow_cell_id = @flow_cell_id AND position_x = @position_x AND position_y = @position_y
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update FlowCell well with id: %d', 15, 1, @flow_cell_id)
	RETURN
END

SET NOCOUNT OFF
END
