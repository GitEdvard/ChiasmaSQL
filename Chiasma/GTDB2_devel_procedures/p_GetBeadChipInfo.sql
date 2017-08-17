USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipInfo]    Script Date: 11/16/2009 13:37:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetBeadChipInfo](
	@id INTEGER)

AS
BEGIN
SET NOCOUNT ON


SELECT
	bead_chip_info_id as id,
	plate_id,
	n_completed_batches,
	multiple_batches,	
	batch_size,
	default_bead_chip_type_id
FROM bead_chip_info
WHERE bead_chip_info_id = @id

SET NOCOUNT OFF
END
