use gtdb2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW tube_rack_view AS
SELECT
	tube_rack.tube_rack_id AS id,
	tube_rack.identifier,
	tube_rack.tube_rack_type_id,
	tube_rack.empty_slots,
	tube_rack.tube_rack_number,
	tube_rack.comment,
	tube_rack.status,
	barcode.code AS barcode
FROM tube_rack
LEFT OUTER JOIN barcode ON barcode.identifiable_id = tube_rack.tube_rack_id AND barcode.kind = 'CONTAINER'
