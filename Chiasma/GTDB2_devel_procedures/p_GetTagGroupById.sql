USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetTagGroupById](
@id int
)

AS
BEGIN
SET NOCOUNT ON

SELECT
	tag_group_id AS id,
	identifier,
	comment,
	enabled
FROM tag_group WHERE tag_group_id = @id 

SET NOCOUNT OFF
END
