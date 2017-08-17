USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPrimerByIdentifier]    Script Date: 11/20/2009 16:03:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPrimerByIdentifier]( @identifier VARCHAR(255) )

AS
BEGIN

SELECT 
	primer_id AS id,
	identifier,
	type,
	sequence_str,
	orientation,
	modification,
	comment
FROM primer
WHERE identifier = @identifier

END
