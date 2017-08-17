USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteMarkerMapping]    Script Date: 11/20/2009 15:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_DeleteMarkerMapping](
	@id INTEGER,
	@marker_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Delete marker to marker working set mapping.
DELETE FROM wset_member
WHERE
	wset_id = @id AND
	identifiable_id = @marker_id

SET NOCOUNT OFF
END
