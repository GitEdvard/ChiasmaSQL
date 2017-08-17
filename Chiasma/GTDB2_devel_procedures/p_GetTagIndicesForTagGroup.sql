USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTagIndicesForTagGroup](
@tag_group_id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT
	tag_index_id as id,
	tag_index,
	sequence,
	tag_group_id,
	enabled
FROM tag_index WHERE tag_group_id = @tag_group_id 

SET NOCOUNT OFF
END
