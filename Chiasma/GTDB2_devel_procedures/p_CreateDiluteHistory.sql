
USE [GTDB2_practice]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateDiluteHistory]    Script Date: 11/16/2009 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_CreateDiluteHistory](
	@from_container_id int,
	@from_container_position_x int = null,
	@from_container_position_y int = null,
	@to_plate_id int = null,
	@to_plate_position_x int = null,
	@to_plate_position_y int = null,
	@new_state_id smallint = null,
	@sample_volume float,
	@water_volume float,
	@diluted datetime,
	@to_tube_id int = null
)
AS
BEGIN
SET NOCOUNT ON

insert into dilute_history
(from_container_id, from_container_position_x, from_container_position_y, from_container_position_z, 
	to_plate_id, to_plate_position_x, to_plate_position_y, to_tube_id, new_state_id, sample_volume, water_volume, diluted)
values
(@from_container_id, @from_container_position_x, @from_container_position_y, null, @to_plate_id, @to_plate_position_x,
	@to_plate_position_y, @to_tube_id, @new_state_id, @sample_volume, @water_volume, @diluted)


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to dilute history', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END

