USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateFlowCellDisc]    Script Date: 11/16/2009 13:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateFlowCellDisc](
	@identifier VARCHAR(255),
	@project_id INTEGER,
	@barcode_length TINYINT,
	@comment VARCHAR(1024) = NULL,
	@external_barcode VARCHAR(32) = NULL)

--Test 1

-- Test 2

AS
BEGIN
SET NOCOUNT ON

DECLARE @disc_id INTEGER

-- Create disc.
INSERT INTO flow_cell_disc
	(identifier,
	 comment)
VALUES
	(@identifier,
	 @comment)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create FlowCellDisc with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get disc_id.
SET @disc_id = NULL

SELECT @disc_id = flow_cell_disc_id FROM flow_cell_disc WHERE identifier = @identifier
IF @disc_id IS NULL
BEGIN
	RAISERROR('flow_cell_disc_id for FlowCellDisc was not found', 15, 1)
	RETURN
END

IF @external_barcode IS NULL
BEGIN
	EXECUTE p_CreateInternalBarcode @identifiable_id = @disc_id, @kind = 'FLOW_CELL_DISC', @code_length = @barcode_length
END
ELSE
BEGIN
	EXECUTE p_CreateExternalBarcode @barcode = @external_barcode,  @identifiable_id = @disc_id, @kind = 'FLOW_CELL_DISC'
END

-- Create a disc - project link

EXECUTE p_SetFlowCellDiscToProject @project_id = @project_id, @flow_cell_disc_id = @disc_id

--INSERT INTO flow_cell_disc_project_link
--(project_id, 
-- flow_cell_disc_id)
--VALUES
--(@project_id,
-- @disc_id)
--
--IF @@ERROR <> 0
--BEGIN
--	RAISERROR('Failed to create a FlowCellDisc - Project link', 15, 1)
--	RETURN
--END

SELECT
	disc.flow_cell_disc_id AS id,
	disc.identifier as identifier,
	disc.status as status,
	disc.comment as comment,
	barcode.code as barcode
FROM flow_cell_disc disc
LEFT OUTER JOIN barcode ON barcode.identifiable_id = disc.flow_cell_disc_id AND barcode.kind = 'FLOW_CELL_DISC'
WHERE disc.flow_cell_disc_id = @disc_id

SET NOCOUNT OFF
END
