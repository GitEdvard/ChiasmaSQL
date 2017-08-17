USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_sample_series_mapping_insert]    Script Date: 11/20/2009 15:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_sample_series_mapping_insert] ON [dbo].[sample_series_mapping]
AFTER INSERT

AS
BEGIN
SET NOCOUNT ON

INSERT INTO sample_series_mapping_history
	(sample_series_group_id,
	 sample_series_id,
	 changed_action)
SELECT
	sample_series_group_id,
	sample_series_id,
	'I'
FROM inserted
	
SET NOCOUNT OFF
END
