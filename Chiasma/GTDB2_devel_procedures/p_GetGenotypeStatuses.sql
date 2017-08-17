USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenotypeStatuses]    Script Date: 11/20/2009 15:59:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGenotypeStatuses] 

AS
BEGIN
SET NOCOUNT ON

SELECT 
	status_id AS id,
	name
FROM status_code

SET NOCOUNT OFF
END
