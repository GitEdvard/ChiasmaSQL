USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetFlowCellWellDiscLinkHistory]    Script Date: 11/20/2009 15:58:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetFlowCellWellDiscLinkHistory]
	(@flow_cell_well_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	fcwdlh.disc_identifier,
	fcwdlh.copied_to_disc,
	fcwdlh.archived,
	fcwdlh.delivered_to_customer_disc,
	fcwdlh.delivered_to_customer_uppmax,
	fcwdlh.response_from_customer,
	fcwdlh.transfered_to_ftp,
	fcwdlh.deleted,
	fcwdlh.pictures_included,
	fcwdlh.changed,
	fcwdlh.authority_id,
	fcwdlh.changed_action
FROM flow_cell_well_disc_link_history fcwdlh
WHERE
	fcwdlh.flow_cell_well_id = @flow_cell_well_id
ORDER BY fcwdlh.changed ASC

SET NOCOUNT OFF
END
