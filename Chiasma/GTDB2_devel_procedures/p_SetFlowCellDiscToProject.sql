USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_SetFlowCellDiscToProject]    Script Date: 11/20/2009 16:26:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_SetFlowCellDiscToProject](
	@project_id INTEGER,
	@flow_cell_disc_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

-- Create a disc - project link

INSERT INTO flow_cell_disc_project_link
(project_id, 
 flow_cell_disc_id)
VALUES
(@project_id,
 @flow_cell_disc_id)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create a FlowCellDisc - Project link', 15, 1)
	RETURN
END

SET NOCOUNT OFF
END
