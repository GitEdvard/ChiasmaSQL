USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteTubeRack]    Script Date: 11/20/2009 15:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DeleteTubeRack](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM contents WHERE child_container_id = @id

delete from tube_rack_slot_for_tag_source where tube_rack_id = @id

delete from tube_rack where tube_rack_id = @id

DELETE FROM generic_container WHERE generic_container_id = @id


SET NOCOUNT OFF
END
