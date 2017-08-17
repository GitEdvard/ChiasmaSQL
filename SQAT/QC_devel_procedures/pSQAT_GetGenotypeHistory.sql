USE [QC_devel]
GO
/****** Object:  StoredProcedure [dbo].[pSQAT_GetGenotypeHistory]    Script Date: 11/20/2009 16:45:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Returns the update history for a certain genotype.

CREATE PROCEDURE [dbo].[pSQAT_GetGenotypeHistory](@genotypeId INTEGER) 
AS
BEGIN
SET NOCOUNT ON

--
-- Return history data.
--
SELECT sl.status_log_id,
'status' AS [Modified field],
so.name AS [Old value],
sn.name AS [New value],
a.name AS [User],
sl.created AS [Time]
FROM dbo.status_log sl
INNER JOIN dbo.status so ON so.status_id = sl.old_status_id
INNER JOIN dbo.status sn ON sn.status_id = sl.new_status_id
INNER JOIN dbo.authority a ON a.authority_id = sl.authority_id
WHERE sl.genotype_id = @genotypeId
ORDER BY sl.created ASC

SET NOCOUNT OFF

END  





