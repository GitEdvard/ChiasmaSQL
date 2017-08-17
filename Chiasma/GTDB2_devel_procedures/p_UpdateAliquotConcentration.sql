USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateAliquotConcentration]    Script Date: 11/20/2009 16:26:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateAliquotConcentration](
	@plate_id INTEGER,
	@position_x INTEGER,
	@position_y INTEGER,
	@concentration FLOAT,
	@concentration_device_id INTEGER,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update aliquot.
UPDATE aliquot SET
	concentration = @concentration,
	concentration_device_id = @concentration_device_id,
	comment = @comment
WHERE plate_id = @plate_id AND position_x = @position_x AND position_y = @position_y
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update aliquot with id: %d', 15, 1, @plate_id)
	RETURN
END

SET NOCOUNT OFF
END
