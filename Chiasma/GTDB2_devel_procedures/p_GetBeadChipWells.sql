USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipWells]    Script Date: 11/20/2009 15:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetBeadChipWells](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM bead_chip_well_view 
WHERE id = @id

SET NOCOUNT OFF
END


--SELECT
--	bead_chip_well.bead_chip_id AS id,
--	bead_chip_well.position_x,
--	bead_chip_well.position_y,
--	bead_chip_well.source_container_id,
--	bead_chip_well.source_container_position_x,
--	bead_chip_well.source_container_position_y,
--	bead_chip_well.source_container_position_z,
--	bead_chip_well.sample_id,
--	bead_chip_well.comment,
--	sample.sample_id AS sample_id,
--	sample.individual_id AS sample_individual_id,
--	sample.identifier AS sample_identifier,
--	sample.sample_series_id AS sample_sample_series_id,
--	sample.state_id AS sample_state_id,
--	sample.external_name AS sample_external_name,
--	sample.container_id AS sample_container_id,
--	sample.pos_x AS sample_pos_x,
--	sample.pos_y AS sample_pos_y,
--	sample.pos_z AS sample_pos_z,
--	sample.volume_customer AS sample_volume_customer,
--	sample.concentration_customer AS sample_concentration_customer,
--	sample.volume_current AS sample_volume_current,
--	sample.concentration_current AS sample_concentration_current,
--	sample.concentration_current_device_id AS sample_concentration_current_device_id,
--	sample.comment AS sample_comment,
--	sample.fragment_length AS sample_fragment_length,
--	sample.molar_concentration AS sample_molar_concentration,
--	sample.is_highlighted AS sample_is_highlighted,
--	sample.fragment_length_device_id AS sample_fragment_length_device_id,
--	sample.molar_concentration_device_id AS sample_molar_concentration_device_id
--FROM bead_chip_well
--LEFT OUTER JOIN sample
--ON sample.sample_id = bead_chip_well.sample_id
--WHERE bead_chip_well.bead_chip_id = @id
