USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetDiluteHistoryFromWell]    Script Date: 11/20/2009 15:57:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetDiluteHistoryFromWell]
	(@from_container_id INTEGER,
	 @from_container_position_x INTEGER,
	 @from_container_position_y INTEGER)

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
	to_tube_id,
	authority_id
FROM dilute_history
WHERE
	from_container_id = @from_container_id AND
	from_container_position_x = @from_container_position_x AND
	from_container_position_y = @from_container_position_y
ORDER BY diluted ASC

SET NOCOUNT OFF
END
