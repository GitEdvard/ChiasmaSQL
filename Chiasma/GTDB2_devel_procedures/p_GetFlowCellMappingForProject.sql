USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellMappingForProject]    Script Date: 11/20/2009 15:58:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetFlowCellMappingForProject](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

CREATE TABLE #flow_cell_table (flow_cell_well_id INTEGER NOT NULL PRIMARY KEY,
								flow_cell_id INTEGER NOT NULL) ON [PRIMARY]

--Get all flow_cell_wells with samples belonging to the specified project,
--special treatment for sequencing-control samples:
--only get the flowcellWell if the other wells on the same flowcells belong
--to the specified project

INSERT INTO #flow_cell_table
(flow_cell_well_id,
	flow_cell_id)
(SELECT fcw.flow_cell_well_id, fc.flow_cell_id FROM
project p
INNER JOIN sample_series_group ssg ON 
(p.project_id = ssg.identifiable_id AND ssg.sample_series_group_type = 'project')
INNER JOIN sample_series_mapping ssm ON 
(ssg.sample_series_group_id = ssm.sample_series_group_id)
INNER JOIN sample_series ss ON
(ss.sample_series_id = ssm.sample_series_id)
INNER JOIN sample s ON
(s.sample_series_id = ss.sample_series_id)
INNER JOIN individual i ON
(i.individual_id = s.individual_id)
INNER JOIN flow_cell_well fcw ON
(fcw.sample_id = s.sample_id)
INNER JOIN flow_cell fc ON
(fc.flow_cell_id = fcw.flow_cell_id)
WHERE 
p.project_id = @id AND
fc.status = 'Active' AND
(NOT i.individual_usage = 'SequencingControl' OR
(i.individual_usage = 'SequencingControl' AND
@id IN 
(SELECT p2.project_id FROM
project p2
INNER JOIN sample_series_group ssg2 ON 
(p2.project_id = ssg2.identifiable_id AND ssg2.sample_series_group_type = 'project')
INNER JOIN sample_series_mapping ssm2 ON 
(ssg2.sample_series_group_id = ssm2.sample_series_group_id)
INNER JOIN sample_series ss2 ON
(ss2.sample_series_id = ssm2.sample_series_id)
INNER JOIN sample s2 ON
(s2.sample_series_id = ss2.sample_series_id)
INNER JOIN individual i2 ON
(i2.individual_id = s2.individual_id)
INNER JOIN flow_cell_well fcw2 ON
(fcw2.sample_id = s2.sample_id)
WHERE fcw2.flow_cell_id = fc.flow_cell_id AND
NOT i2.individual_usage = 'SequencingControl')))
)

SELECT
fc.flow_cell_id as id,
fc.bead_chip_type_id,
fc.identifier,
fc.comment,
fc.status,
fc.flow_cell_type,
fc.is_clustered,
fc.is_sequenced,
fc.is_analysed,
fc.is_failed,
fc.runfolder,
fc.no_of_cycles
FROM flow_cell fc 
WHERE fc.flow_cell_id IN (SELECT fct.flow_cell_id FROM #flow_cell_table fct)

SELECT 
fcw.flow_cell_well_id as id,
fcw.flow_cell_id,
fcw.position_x,
fcw.position_y,
fcw.source_container_id,
fcw.source_container_position_x,
fcw.source_container_position_y,
fcw.source_container_position_z,
fcw.sample_id,
fcw.comment,
fcw.is_control,
sample.sample_id AS sample_id,
sample.individual_id AS sample_individual_id,
sample.identifier AS sample_identifier,
sample.sample_series_id AS sample_sample_series_id,
sample.state_id AS sample_state_id,
sample.external_name AS sample_external_name,
sample.container_id AS sample_container_id,
sample.pos_x AS sample_pos_x,
sample.pos_y AS sample_pos_y,
sample.pos_z AS sample_pos_z,
sample.volume_customer AS sample_volume_customer,
sample.concentration_customer AS sample_concentration_customer,
sample.volume_current AS sample_volume_current,
sample.concentration_current AS sample_concentration_current,
sample.concentration_current_device_id AS sample_concentration_current_device_id,
sample.comment AS sample_comment,
sample.fragment_length AS sample_fragment_length,
sample.molar_concentration AS sample_molar_concentration,
sample.is_highlighted AS sample_is_highlighted
FROM flow_cell_well fcw LEFT OUTER JOIN sample
ON sample.sample_id = fcw.sample_id
WHERE fcw.flow_cell_well_id IN (SELECT flow_cell_well_id FROM #flow_cell_table)


SELECT 
	fcwdl.flow_cell_well_disc_link_id as id,
	fcwdl.flow_cell_well_id,
	fcwdl.flow_cell_disc_id,
	fcwdl.flow_cell_id,
	fcwdl.copied_to_disc,
	fcwdl.archived,
	fcwdl.delivered_to_customer_disc,
	fcwdl.delivered_to_customer_uppmax,
	fcwdl.response_from_customer,
	fcwdl.transfered_to_ftp,
	fcwdl.deleted,
	fcwdl.pictures_included,
	fcd.identifier,
	fcd.comment,
	fcd.status,
	barcode.code as barcode
FROM flow_cell_well_disc_link fcwdl
	LEFT OUTER JOIN flow_cell_disc fcd ON
(fcd.flow_cell_disc_id = fcwdl.flow_cell_disc_id)
	LEFT OUTER JOIN barcode 
ON (barcode.identifiable_id = fcd.flow_cell_disc_id AND barcode.kind = 'FLOW_CELL_DISC')
WHERE fcwdl.flow_cell_well_id IN (SELECT flow_cell_well_id FROM #flow_cell_table)

EXECUTE p_GetFlowCellDiscsForProject @id = @id

SET NOCOUNT OFF
END
