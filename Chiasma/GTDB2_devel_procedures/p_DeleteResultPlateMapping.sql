USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteResultPlateMapping]    Script Date: 11/20/2009 15:45:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteResultPlateMapping](
	@id INTEGER,
	@result_plate_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete result plate to working set mapping.
DELETE FROM wset_member
WHERE
	identifiable_id = @result_plate_id AND
	wset_id = @id

SET NOCOUNT OFF
END
