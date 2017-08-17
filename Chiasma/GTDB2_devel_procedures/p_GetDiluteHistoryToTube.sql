USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetDiluteHistoryToTube]    Script Date: 11/20/2009 15:57:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetDiluteHistoryToTube]
	(@to_tube_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	from_container_id,
	from_container_position_x,
	from_container_position_y,
	from_container_position_z,
	to_tube_id,
	to_plate_id,
	to_plate_position_x,
	to_plate_position_y,
	new_state_id,
	sample_volume,
	water_volume,
	diluted,
	authority_id
FROM dilute_history
WHERE to_tube_id = @to_tube_id
ORDER BY diluted ASC


SET NOCOUNT OFF
END
