USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAliquotHistory]    Script Date: 11/20/2009 15:54:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetAliquotHistory]
	(@plate_id INTEGER,
	 @position_x INTEGER,
	 @position_y INTEGER)

AS
BEGIN
SET NOCOUNT ON

select * from aliquot_history_view
WHERE
	plate_id = @plate_id AND
	position_x = @position_x AND
	position_y = @position_y
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
