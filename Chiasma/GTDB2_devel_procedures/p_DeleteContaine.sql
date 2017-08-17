USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteContainer]    Script Date: 11/20/2009 15:43:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DeleteContainer](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM contents WHERE child_container_id = @id

DELETE FROM container WHERE container_id = @id

DELETE FROM generic_container WHERE generic_container_id = @id


SET NOCOUNT OFF
END
