USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPrimerTypes]    Script Date: 11/20/2009 16:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetPrimerTypes]

AS
BEGIN

SELECT type FROM primer_type_code
ORDER BY type ASC

END
