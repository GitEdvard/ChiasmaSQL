USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetBeadChipLabels]    Script Date: 11/20/2009 15:55:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetBeadChipLabels]( @bead_chip_type_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM bead_chip_label
WHERE bead_chip_type_id = @bead_chip_type_id

SET NOCOUNT OFF
END
