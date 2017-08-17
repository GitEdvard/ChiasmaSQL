USE [GTDB2_devel]

GO
/****** Object:  StoredProcedure [dbo].[p_AddPrimerToAssay]    Script Date: 11/16/2009 13:15:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_AddPrimerToAssay] (
	@primer_id INTEGER,
	@assay_id INTEGER)

AS
BEGIN
SET NOCOUNT OFF

INSERT INTO primer_set (primer_id, assay_id)
VALUES (@primer_id, @assay_id)

SET NOCOUNT ON
END
