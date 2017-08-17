USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateMarkerMapping]    Script Date: 11/16/2009 13:37:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateMarkerMapping](
	@id INTEGER,
	@marker_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DECLARE @kind_id INTEGER

-- Get kind_id for Marker type
SELECT @kind_id = kind_id FROM kind WHERE name = 'MARKER'
IF @kind_id IS NULL
BEGIN
	RAISERROR('kind_id for type MARKER was not found', 15, 1)
	RETURN
END

-- Create mapping between marker and marker working set
INSERT INTO wset_member (identifiable_id, kind_id, wset_id) VALUES (@marker_id, @kind_id, @id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create marker mapping for marker working set: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
