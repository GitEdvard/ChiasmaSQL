USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeRackSlotsForTagSource]    Script Date: 11/20/2009 15:54:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeRackSlotsForTagSource]

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_rack_slot_for_tag_source

SET NOCOUNT OFF
END
