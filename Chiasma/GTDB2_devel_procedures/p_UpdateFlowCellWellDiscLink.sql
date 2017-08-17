USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateFlowCellWellDiscLink]    Script Date: 11/20/2009 16:27:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateFlowCellWellDiscLink](
	@id INTEGER,
	 @copied_to_disc BIT,
	 @archived BIT,
	 @delivered_to_customer_disc BIT,
	 @delivered_to_customer_uppmax BIT,
	 @response_from_customer BIT,
	 @transfered_to_ftp BIT,
	 @deleted BIT,
	 @pictures_included BIT,
	 @flow_cell_disc_id INTEGER = NULL,
	 @enabled BIT)
AS
BEGIN
SET NOCOUNT ON

-- Update link.
UPDATE flow_cell_well_disc_link
SET
	 copied_to_disc = @copied_to_disc,
	 archived = @archived,
	 delivered_to_customer_disc = @delivered_to_customer_disc,
	 delivered_to_customer_uppmax = @delivered_to_customer_uppmax,
	 response_from_customer = @response_from_customer,
	 transfered_to_ftp = @transfered_to_ftp,
	 deleted = @deleted,
	 pictures_included = @pictures_included,
	 flow_cell_disc_id = @flow_cell_disc_id,
	 enabled = @enabled
WHERE flow_cell_well_disc_link_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update flow_cell_well_disc_link with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
