USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainers]    Script Date: 11/20/2009 15:59:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetGenericContainers] (@selectCommand VARCHAR (1024))

AS
BEGIN
SET NOCOUNT ON

CREATE TABLE #generic_container_id_table (generic_container_id INTEGER NOT NULL PRIMARY KEY)

-- Get generic container ids
EXECUTE ('INSERT INTO #generic_container_id_table (generic_container_id) '  + @selectCommand)

-- Get containers.
select * from container_view 
WHERE
	id IN (SELECT generic_container_id FROM #generic_container_id_table)

-- Get Tube racks.
SELECT * from tube_rack_view 
where id in (select generic_container_id from #generic_container_id_table)


-- Get FlowCells.
SELECT
	flow_cell.flow_cell_id AS id,
	flow_cell.bead_chip_type_id,
	flow_cell.identifier,
	flow_cell.status AS status,
	flow_cell.comment,
	barcode.code as barcode
FROM flow_cell
LEFT OUTER JOIN barcode ON barcode.identifiable_id = flow_cell.flow_cell_id AND barcode.kind = 'CONTAINER'
WHERE flow_cell_id IN (SELECT generic_container_id FROM #generic_container_id_table)


-- Get BeadChips.
SELECT
	bead_chip.bead_chip_id AS id,
	bead_chip.bead_chip_type_id,
	bead_chip.identifier,
	bead_chip.status AS status,
	bead_chip.comment,
	barcode.code as barcode
FROM bead_chip
LEFT OUTER JOIN barcode ON barcode.identifiable_id = bead_chip.bead_chip_id AND barcode.kind = 'CONTAINER'
WHERE bead_chip_id IN (SELECT generic_container_id FROM #generic_container_id_table)

-- Get plates.
SELECT
	plate.plate_id AS id,
	plate.identifier,
	plate.plate_usage,
	plate.plate_type_id,
	plate.status AS status,
	plate.comment,
	plate.bead_chip_info_id,
	barcode.code AS barcode,
	plate.plate_number,
	plate.sample_series_id,
	plate.method
FROM plate
LEFT JOIN barcode ON barcode.identifiable_id = plate.plate_id AND barcode.kind = 'CONTAINER'
LEFT OUTER JOIN bead_chip_info bci ON bci.plate_id = plate.plate_id
WHERE plate.plate_id IN (SELECT generic_container_id FROM #generic_container_id_table)

-- Get tubes.
SELECT * FROM tube_view

WHERE id IN (SELECT generic_container_id FROM #generic_container_id_table)



SET NOCOUNT OFF
END

SET ANSI_NULLS OFF

