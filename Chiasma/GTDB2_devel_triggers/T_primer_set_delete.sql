USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_primer_set_delete]    Script Date: 11/20/2009 15:14:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[T_primer_set_delete] ON [dbo].[primer_set]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO primer_set_history
	(assay_id,
	 primer_id,
	 changed_action)
SELECT
	assay_id,
	primer_id,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END









