USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipHistory]    Script Date: 11/20/2009 15:55:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetBeadChipHistory](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT
	bead_chip_id AS id,
	bead_chip_type_id,
	identifier,
	status,
	comment,
	changed_date,
	changed_authority_id,
	changed_action
FROM bead_chip_history
WHERE bead_chip_id = @id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
