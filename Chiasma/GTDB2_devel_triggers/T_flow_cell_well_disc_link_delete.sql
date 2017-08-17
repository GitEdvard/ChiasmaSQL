USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_flow_cell_well_disc_link_delete]    Script Date: 11/20/2009 15:11:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the flow_cell table.

CREATE TRIGGER [dbo].[T_flow_cell_well_disc_link_delete] ON [dbo].[flow_cell_well_disc_link]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

SET @action = 'D'
IF (EXISTS(SELECT flow_cell_well_id FROM deleted) AND
EXISTS(SELECT fcw.flow_cell_well_id FROM flow_cell_well fcw, deleted d WHERE fcw.flow_cell_well_id = d.flow_cell_well_id))
BEGIN
	INSERT INTO flow_cell_well_disc_link_history
		(flow_cell_well_id,
 		 disc_identifier,
 		 copied_to_disc,
		 archived,
		 delivered_to_customer_disc,
		 delivered_to_customer_uppmax,
		 response_from_customer,
		 transfered_to_ftp,
		 deleted,
		 pictures_included,
		 changed_action)
	SELECT
		 d.flow_cell_well_id,
 		 fcd.identifier,
 		 d.copied_to_disc,
		 d.archived,
		 d.delivered_to_customer_disc,
		 d.delivered_to_customer_uppmax,
		 d.response_from_customer,
		 d.transfered_to_ftp,
		 d.deleted,
		 d.pictures_included,
		 @action
	FROM deleted d 
	LEFT OUTER JOIN flow_cell_disc fcd ON
	(d.flow_cell_disc_id = fcd.flow_cell_disc_id)
END	
SET NOCOUNT OFF
END
