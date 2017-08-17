USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_primer_set_insert]    Script Date: 11/20/2009 15:14:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[T_primer_set_insert] ON [dbo].[primer_set]
AFTER INSERT

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
	'I'
FROM inserted
	
SET NOCOUNT OFF
END









