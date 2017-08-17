USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSexes]    Script Date: 11/20/2009 16:08:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetSexes]

AS
BEGIN
SET NOCOUNT ON

SELECT CONVERT( INTEGER, sex) AS id, name AS identifier, description FROM sex_code
ORDER BY identifier ASC

SET NOCOUNT OFF
END
