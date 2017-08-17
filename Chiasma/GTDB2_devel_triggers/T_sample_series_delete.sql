USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_sample_series_delete]    Script Date: 11/20/2009 15:15:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the sample_series table.

CREATE TRIGGER [dbo].[T_sample_series_delete] ON [dbo].[sample_series]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO sample_series_history
	(sample_series_id,
	 identifier,
	 contact_id,
	 comment,
	 changed_action)
SELECT
	 sample_series_id,
	 identifier,
	 contact_id,
	 comment,
	 'D'
FROM deleted
	
SET NOCOUNT OFF
END
