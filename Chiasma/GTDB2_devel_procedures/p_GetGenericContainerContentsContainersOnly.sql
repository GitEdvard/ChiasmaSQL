USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericContainerContentsContainersOnly]    Script Date: 11/20/2009 15:59:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Get containers inside this container.
ALTER PROCEDURE [dbo].[p_GetGenericContainerContentsContainersOnly] (
	@id INTEGER)

AS
BEGIN

select * 
from container_view cv
where cv.id in (
	select cs.child_container_id from contents cs
	where cs.parent_container_id = @id
	)

END
