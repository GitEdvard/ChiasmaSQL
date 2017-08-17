USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetStateById]    Script Date: 11/20/2009 16:08:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetStateById](@id SMALLINT)

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
WHERE state_id = @id

SET NOCOUNT OFF
END
