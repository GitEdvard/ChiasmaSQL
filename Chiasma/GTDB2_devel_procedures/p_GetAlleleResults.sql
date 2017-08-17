USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetAlleleResults]    Script Date: 11/20/2009 15:54:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetAlleleResults]

AS
BEGIN
SET NOCOUNT ON

SELECT 
	allele_result_id AS id,
	name,
	complement
FROM allele_result

SET NOCOUNT ON
END
