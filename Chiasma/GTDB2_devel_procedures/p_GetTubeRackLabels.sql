USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeRackLabels]    Script Date: 11/20/2009 16:09:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetTubeRackLabels]( @tube_rack_type_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM tube_rack_label WHERE tube_rack_type_id = @tube_rack_type_id

SET NOCOUNT OFF
END
