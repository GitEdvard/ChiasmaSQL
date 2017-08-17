USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetDiluteHistoryToPlate]    Script Date: 11/20/2009 15:57:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetDiluteHistoryToPlate]
	(@to_plate_id INTEGER,
	 @include_wells BIT)

AS
BEGIN
SET NOCOUNT ON

IF @include_wells = 1
BEGIN
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
	WHERE to_plate_id = @to_plate_id
	ORDER BY diluted ASC
END
ELSE
BEGIN
	SELECT DISTINCT
		from_container_id,
		to_plate_id,
		diluted,
		authority_id
	FROM dilute_history
	WHERE to_plate_id = @to_plate_id
	ORDER BY diluted ASC
END

SET NOCOUNT OFF
END
