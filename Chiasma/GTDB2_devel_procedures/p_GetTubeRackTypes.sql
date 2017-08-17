USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeRackTypes]    Script Date: 11/20/2009 16:09:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetTubeRackTypes]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	tube_rack_type_id AS id,
	identifier,
	size_x,
	size_y,
	description
FROM tube_rack_type
ORDER BY identifier ASC

SET NOCOUNT OFF
END
