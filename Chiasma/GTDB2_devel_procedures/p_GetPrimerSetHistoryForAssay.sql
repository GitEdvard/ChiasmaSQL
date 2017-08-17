USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPrimerSetHistoryForAssay]    Script Date: 11/20/2009 16:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPrimerSetHistoryForAssay]( @assay_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	assay_id,
	primer_id,
	changed_date,
	changed_authority_id,
	changed_action 
FROM primer_set_history
WHERE assay_id = @assay_id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
