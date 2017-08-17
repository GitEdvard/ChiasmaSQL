use gtdb2_devel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view aliquot_view as
SELECT
	a.plate_id,
	a.position_x,
	a.position_y,
	a.state_id,
	a.source_container_id,
	a.source_container_position_x,
	a.source_container_position_y,
	a.source_container_position_z,
	a.sample_id,
	a.concentration,
	a.concentration_device_id,
	a.volume,
	a.sample_dilute_factor,
	a.comment,
	a.is_highlighted,
	a.aliquot_id AS id,
	ac.identifier as source_container_identifier
FROM aliquot AS a
left outer join all_containers ac on a.source_container_id = ac.generic_container_id

