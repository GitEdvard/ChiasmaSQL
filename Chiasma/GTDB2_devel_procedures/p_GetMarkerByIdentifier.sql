USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetMarkerByIdentifier]    Script Date: 11/20/2009 16:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetMarkerByIdentifier]( @identifier VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	marker_id AS id,
	identifier,
	species_id AS species_id,
	comment AS comment
FROM marker
WHERE identifier = @identifier

SET NOCOUNT OFf
END
