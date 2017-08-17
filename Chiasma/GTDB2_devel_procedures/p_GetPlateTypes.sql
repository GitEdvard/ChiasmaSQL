USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateTypes]    Script Date: 11/20/2009 16:03:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPlateTypes]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	plate_type_id AS id,
	identifier,
	size_x,
	size_y,
	description
FROM plate_type
ORDER BY identifier ASC

SET NOCOUNT OFF
END
