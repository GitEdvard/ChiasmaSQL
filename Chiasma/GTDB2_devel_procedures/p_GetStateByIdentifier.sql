USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetStateByIdentifier]    Script Date: 11/20/2009 16:08:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetStateByIdentifier](@identifier VARCHAR(255))

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
WHERE identifier = @identifier

SET NOCOUNT OFF
END
