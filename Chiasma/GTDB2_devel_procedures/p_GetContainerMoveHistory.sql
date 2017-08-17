USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContainerMoveHistory]    Script Date: 11/20/2009 15:57:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetContainerMoveHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT  moved_container_id,
	from_container_id,
	to_container_id,
	moved AS changed_date,
	authority_id AS changed_authority_id,
	CASE WHEN (NOT to_container_id IS NULL) THEN 'Put' ELSE 'Take' END AS changed_action
FROM container_move
WHERE moved_container_id = @id
ORDER BY moved ASC

	
SET NOCOUNT OFF
END
