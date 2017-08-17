USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlateLabels]    Script Date: 11/20/2009 16:03:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPlateLabels]( @plate_type_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM plate_label WHERE plate_type_id = @plate_type_id

SET NOCOUNT OFF
END
