USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateBeadChipWell]    Script Date: 11/20/2009 16:27:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateBeadChipWell](
	@id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER,
	@source_container_id INTEGER = NULL,
	@source_container_position_x INTEGER = NULL,
	@source_container_position_y INTEGER = NULL,
	@source_container_position_z INTEGER = NULL,
	@sample_id INTEGER = NULL,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update BeadChip well.
UPDATE bead_chip_well SET
	source_container_id = @source_container_id,
	source_container_position_x = @source_container_position_x,
	source_container_position_y = @source_container_position_y,
	source_container_position_z = @source_container_position_z,
	sample_id = @sample_id,
	comment = @comment
WHERE bead_chip_id = @id AND position_x = @position_x AND position_y = @position_y
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update BeadChip well with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
