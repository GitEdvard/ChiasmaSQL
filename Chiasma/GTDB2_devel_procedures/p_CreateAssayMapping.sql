USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateAssayMapping]    Script Date: 11/16/2009 13:34:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateAssayMapping](
	@id INTEGER,
	@assay_id INTEGER)

AS
BEGIN
SET NOCOUNT ON
 
DECLARE @kind_id INTEGER

-- Get kind_id for Assay type
SELECT @kind_id = kind_id FROM kind WHERE name = 'ASSAY'
IF @kind_id IS NULL
BEGIN
	RAISERROR('kind_id for type ASSAY was not found', 15, 1)
	RETURN
END

-- Create mapping between assay and assay working set
INSERT INTO wset_member (identifiable_id, kind_id, wset_id) VALUES (@assay_id, @kind_id, @id)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create assay mapping for assay working set: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END