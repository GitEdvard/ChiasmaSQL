USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteState]    Script Date: 11/20/2009 15:46:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DeleteTagGroup](@id SMALLINT)

AS
BEGIN
SET NOCOUNT ON

DELETE FROM tag_group WHERE tag_group_id = @id


SET NOCOUNT OFF
END
