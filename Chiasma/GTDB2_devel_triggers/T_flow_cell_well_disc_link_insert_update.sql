USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_flow_cell_well_disc_link_insert_update]    Script Date: 11/20/2009 15:11:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the flow_cell table.

CREATE TRIGGER [dbo].[T_flow_cell_well_disc_link_insert_update] ON [dbo].[flow_cell_well_disc_link]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

SET @action = 'U'
IF EXISTS(SELECT flow_cell_well_id FROM deleted)
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
		 i.flow_cell_well_id,
 		 fcd.identifier,
 		 i.copied_to_disc,
		 i.archived,
		 i.delivered_to_customer_disc,
		 i.delivered_to_customer_uppmax,
		 i.response_from_customer,
		 i.transfered_to_ftp,
		 i.deleted,
		 i.pictures_included,
		 @action
	FROM inserted i 
	LEFT OUTER JOIN flow_cell_disc fcd ON
	(i.flow_cell_disc_id = fcd.flow_cell_disc_id)
END	
SET NOCOUNT OFF
END
