USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContainersTopLevel]    Script Date: 11/20/2009 15:57:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetContainersTopLevel]

AS
BEGIN
SET NOCOUNT ON

-- Get containers.

select * from 
container_view cv
WHERE cv.type = 'TopLevel' AND cv.status = 'Active'


SET NOCOUNT OFF
END
