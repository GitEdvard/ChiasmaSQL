use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW plate_view AS
SELECT
	plate.plate_id AS id,
	plate.plate_usage,
	plate.plate_type_id,
	plate.identifier,
	plate.status,
	plate.comment,
	plate.bead_chip_info_id,
	barcode.code AS barcode,
	plate.plate_number,
	plate.method,
	plate.sample_series_id
FROM plate
LEFT OUTER JOIN barcode ON barcode.identifiable_id = plate.plate_id AND barcode.kind = 'CONTAINER'
