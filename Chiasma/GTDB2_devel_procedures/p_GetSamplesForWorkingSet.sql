USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesForWorkingSet]    Script Date: 11/20/2009 16:08:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSamplesForWorkingSet](
	@id INTEGER,
	@identifier_filter VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT sv.* FROM sample_view sv
INNER JOIN wset_member ON sv.id = wset_member.identifiable_id
WHERE
	wset_member.wset_id = @id AND
	sv.identifier LIKE @identifier_filter
ORDER BY sv.identifier ASC


SET NOCOUNT OFF
END

