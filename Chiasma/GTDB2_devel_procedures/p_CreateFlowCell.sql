USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateFlowCell]    Script Date: 11/16/2009 13:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateFlowCell](
	@identifier VARCHAR(255),
	@bead_chip_type_id INTEGER,
	@external_barcode VARCHAR(255) = NULL
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @flow_cell_id INTEGER

-- Get the ID from the generic_container table.
INSERT INTO generic_container (generic_container_type) VALUES ('FlowCell')

SET @flow_cell_id = SCOPE_IDENTITY()

-- Create FlowCell.
INSERT INTO flow_cell
	(flow_cell_id,
	 identifier,
	 bead_chip_type_id
)
VALUES
	(@flow_cell_id,
	 @identifier, 
	 @bead_chip_type_id
)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create FlowCell with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Get flow_cell_id.
SET @flow_cell_id = NULL

SELECT @flow_cell_id = flow_cell_id FROM flow_cell WHERE identifier = @identifier
IF @flow_cell_id IS NULL
BEGIN
	RAISERROR('flow_cell_id for FlowCell was not found', 15, 1)
	RETURN
END

-- Create bar code.
IF NOT isnull(@external_barcode, 'aaa##bbb') = 'aaa##bbb'
BEGIN
	EXECUTE p_CreateExternalBarcode @barcode = @external_barcode,  @identifiable_id = @flow_cell_id, @kind = 'CONTAINER'
END

---- Return FlowCell.
SELECT
	flow_cell.flow_cell_id AS id,
	flow_cell.bead_chip_type_id,
	flow_cell.identifier,
	flow_cell.status,
	flow_cell.comment,
	barcode.code as barcode
FROM flow_cell
LEFT OUTER JOIN barcode ON barcode.identifiable_id = flow_cell.flow_cell_id AND barcode.kind = 'CONTAINER'
WHERE flow_cell_id = @flow_cell_id

SET NOCOUNT OFF
END


SET ANSI_NULLS ON
