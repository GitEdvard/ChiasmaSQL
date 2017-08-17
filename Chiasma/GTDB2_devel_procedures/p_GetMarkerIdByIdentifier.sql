USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkerIdByIdentifier]    Script Date: 11/20/2009 16:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkerIdByIdentifier]( @identifier VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker_id AS id
FROM marker
WHERE identifier = @identifier

SET NOCOUNT OFf
END
