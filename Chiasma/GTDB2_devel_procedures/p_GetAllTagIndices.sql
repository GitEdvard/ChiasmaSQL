USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetAllTagIndices]

AS
BEGIN
SET NOCOUNT ON

SELECT
	tag_index_id AS id,
	tag_index,
	sequence,
	tag_group_id,
	enabled
FROM tag_index ORDER BY tag_group_id, tag_index ASC

SET NOCOUNT OFF
END
