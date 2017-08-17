USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteAssayMapping]    Script Date: 11/20/2009 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteAssayMapping](
	@id INTEGER,
	@assay_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete assay to assay working set mapping.
DELETE FROM wset_member
WHERE
	wset_id = @id AND
	identifiable_id = @assay_id

SET NOCOUNT OFF
END
