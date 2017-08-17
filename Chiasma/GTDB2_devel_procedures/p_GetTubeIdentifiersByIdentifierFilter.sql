USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeIdentifiersByIdentifierFilter]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetTubeIdentifiersByIdentifierFilter](@identifier_filter varchar(255))

AS
BEGIN
SET NOCOUNT ON

SELECT t.identifier FROM 
	tube t 
where t.identifier like '%' + @identifier_filter + '%'
SET NOCOUNT OFF

END
