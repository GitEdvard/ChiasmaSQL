USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipWellHistory]    Script Date: 11/20/2009 15:56:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetBeadChipWellHistory]
	(@id INTEGER,
	 @position_x INTEGER,
	 @position_y INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from bead_chip_well_history_view bcwhv
LEFT OUTER JOIN sample_prefix_view spv
ON spv.sample_sample_id = bcwhv.sample_id
WHERE
	bcwhv.id = @id AND
	bcwhv.position_x = @position_x AND
	bcwhv.position_y = @position_y
ORDER BY bcwhv.changed ASC

SET NOCOUNT OFF
END
