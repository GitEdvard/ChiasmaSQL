USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesForIndividual]    Script Date: 11/20/2009 16:07:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetSamplesForIndividual]( @individual_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_view
WHERE individual_id = @individual_id
ORDER BY identifier ASC

SET NOCOUNT OFF
END
