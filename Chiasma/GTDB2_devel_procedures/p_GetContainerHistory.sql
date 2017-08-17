USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContainerHistory]    Script Date: 11/20/2009 15:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetContainerHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	ch.container_id AS id,
	ch.identifier,
	ct.name AS type,
	ch.size_x,
	ch.size_y,
	ch.size_z,
	ch.status,
	ch.comment,
	ch.changed_date,
	ch.changed_authority_id,
	ch.changed_action
FROM container_history ch
	LEFT OUTER JOIN container_type ct ON ct.container_type_id = ch.container_type_id
WHERE ch.container_id = @id
ORDER BY ch.changed_date ASC

SET NOCOUNT OFF
END
