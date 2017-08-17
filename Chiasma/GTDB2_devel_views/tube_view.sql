use GTDB2_devel

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter VIEW tube_view AS
SELECT
	tube.tube_id AS id,
	tube.tube_usage,
	tube.identifier,
	tube.status,
	tube.comment,
	tube.tube_number,
	tube.method,
	tube.is_highlighted,
	tube.is_failed,
	barcode.code AS barcode,
	tm.sample_comment as tube_metadata_sample_comment,
	tm.tube_aliquot_comment as tube_metadata_tube_aliquot_comment,
	tm.pool_info_for_aliquot_comment as tube_metadata_pool_info_for_aliquots_comment
FROM tube
inner join tube_metadata tm on tube.tube_metadata_id = tm.tube_metadata_id
LEFT OUTER JOIN barcode ON barcode.identifiable_id = tube.tube_id AND barcode.kind = 'CONTAINER'
