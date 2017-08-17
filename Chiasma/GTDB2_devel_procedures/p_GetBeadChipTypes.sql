USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipTypes]    Script Date: 11/20/2009 15:56:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetBeadChipTypes]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	bead_chip_type_id AS id,
	identifier,
	size_x,
	size_y,
	chiptype,
	default_batch_size,
	status
FROM bead_chip_type
ORDER BY identifier ASC

SET NOCOUNT OFF
END


SET ANSI_NULLS OFF
