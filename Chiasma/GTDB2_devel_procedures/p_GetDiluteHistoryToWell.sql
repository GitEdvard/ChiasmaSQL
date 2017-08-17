USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetDiluteHistoryToWell]    Script Date: 11/20/2009 15:57:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetDiluteHistoryToWell]
	(@to_plate_id INTEGER,
	 @to_plate_position_x INTEGER,
	 @to_plate_position_y INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	from_container_id,
	from_container_position_x,
	from_container_position_y,
	from_container_position_z,
	to_plate_id,
	to_plate_position_x,
	to_plate_position_y,
	new_state_id,
	sample_volume,
	water_volume,
	diluted,
	authority_id
FROM dilute_history
WHERE
	to_plate_id = @to_plate_id AND
	to_plate_position_x = @to_plate_position_x AND
	to_plate_position_y = @to_plate_position_y
ORDER BY diluted ASC

SET NOCOUNT OFF
END
