USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPrimerHistory]    Script Date: 11/20/2009 16:03:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPrimerHistory]( @id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT 
	primer_id AS id,
	identifier,
	type,
	sequence_str,
	orientation,
	modification,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM primer_history
WHERE primer_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
