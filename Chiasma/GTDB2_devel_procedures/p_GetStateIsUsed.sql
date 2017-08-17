USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetStateIsUsed]    Script Date: 11/20/2009 16:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetStateIsUsed](@id SMALLINT)

AS
BEGIN
SET NOCOUNT ON

IF EXISTS(SELECT state_id FROM sample WHERE state_id = @id
	UNION SELECT state_id FROM aliquot WHERE state_id = @id
	UNION SELECT state_id FROM tube_aliquot WHERE state_id = @id)
	SELECT 1 AS is_used
ELSE
	SELECT 0 AS is_used

SET NOCOUNT OFF
END
