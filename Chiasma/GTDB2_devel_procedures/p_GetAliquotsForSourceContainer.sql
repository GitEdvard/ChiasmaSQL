USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAliquotsForSourceContainer]    Script Date: 11/20/2009 15:54:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetAliquotsForSourceContainer](@source_container_id INTEGER,
	@source_container_position_x int = null, @source_container_position_y int = null)

AS
BEGIN
SET NOCOUNT ON

if isnull(@source_container_position_x, -1) = -1 
	or isnull(@source_container_position_y, -1) = -1
	begin
		SELECT * FROM aliquot_sample_view 
		WHERE source_container_id = @source_container_id
	end
else
	begin
		SELECT * FROM aliquot_sample_view 
		WHERE source_container_id = @source_container_id
			and source_container_position_x = @source_container_position_x
			and source_container_position_y = @source_container_position_y
	end


SET NOCOUNT OFF
END
