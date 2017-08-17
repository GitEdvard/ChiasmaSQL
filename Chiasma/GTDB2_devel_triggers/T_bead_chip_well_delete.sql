USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_bead_chip_well_delete]    Script Date: 11/20/2009 15:09:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[T_bead_chip_well_delete] ON [dbo].[bead_chip_well]
AFTER DELETE

-- Test 1


AS
BEGIN
SET NOCOUNT ON

INSERT INTO bead_chip_well_history
	(bead_chip_id,
	 position_x,
	 position_y,
	 source_container_id,
	 source_container_position_x,
	 source_container_position_y,
	 source_container_position_z,
	 sample_id,
	 comment)
SELECT
	bead_chip_id,
	position_x,
	position_y,
	source_container_id,
	source_container_position_x,
	source_container_position_y,
	source_container_position_z,
	sample_id,
	comment
FROM deleted
	
SET NOCOUNT OFF
END

