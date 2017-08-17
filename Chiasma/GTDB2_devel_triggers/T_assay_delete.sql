USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_assay_delete]    Script Date: 11/20/2009 15:07:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the assay table.

CREATE TRIGGER [dbo].[T_assay_delete] ON [dbo].[assay]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO assay_history
	(assay_id,
	 marker_id,
	 identifier,
	 allele_variant_id,
	 comment,
	 changed_action)
SELECT
	assay_id,
	marker_id,
	identifier,
	allele_variant_id,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END







