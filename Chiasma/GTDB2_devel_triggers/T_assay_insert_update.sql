USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_assay_insert_update]    Script Date: 11/20/2009 15:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations in the assay table.

CREATE TRIGGER [dbo].[T_assay_insert_update] ON [dbo].[assay]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
	@action
FROM inserted
	
SET NOCOUNT OFF
END








