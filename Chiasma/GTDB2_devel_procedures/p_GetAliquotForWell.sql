USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAliquotForWell]    Script Date: 05/03/2010 13:27:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetAliquotForWell](
@plate_id INTEGER,
@position_x INTEGER,
@position_y INTEGER)

AS
BEGIN
SET NOCOUNT ON


select * from aliquot_sample_view
WHERE plate_id = @plate_id AND position_x = @position_x AND position_y = @position_y

SET NOCOUNT OFF
END

