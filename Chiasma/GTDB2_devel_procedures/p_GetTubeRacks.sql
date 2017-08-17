USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeRacks]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetTubeRacks]

AS
BEGIN
SET NOCOUNT ON

SELECT * from tube_rack_view
SET NOCOUNT OFF

END
