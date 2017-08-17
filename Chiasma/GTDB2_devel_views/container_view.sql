use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW container_view AS
SELECT 
	container.container_id AS id,
	container.identifier,
	container_type.name AS type,
	container.status AS status,
	barcode.code AS barcode,
	container.comment AS comment
FROM container
INNER JOIN container_type ON container_type.container_type_id = container.container_type_id
LEFT OUTER JOIN barcode ON barcode.identifiable_id = container.container_id AND barcode.kind = 'CONTAINER'
