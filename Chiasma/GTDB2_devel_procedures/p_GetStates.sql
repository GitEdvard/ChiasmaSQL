USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetStates]    Script Date: 11/20/2009 16:08:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetStates]

AS
BEGIN
SET NOCOUNT ON

SELECT
	state_id AS id,
	identifier,
	comment,
	enabled,
	tag, 
	'State' as category_type
FROM state
ORDER BY identifier ASC

SET NOCOUNT OFF
END
