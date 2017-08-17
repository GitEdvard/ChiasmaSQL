USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPrimersForAssay]    Script Date: 11/20/2009 16:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPrimersForAssay]( @assay_id INTEGER )

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
WHERE primer_id IN (SELECT primer_id FROM primer_set WHERE assay_id = @assay_id)
ORDER BY type, identifier ASC

END
