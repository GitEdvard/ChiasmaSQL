USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_sample_series_insert_update]    Script Date: 11/20/2009 15:15:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations in the sample_series table.

CREATE TRIGGER [dbo].[T_sample_series_insert_update] ON [dbo].[sample_series]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
	 @action
FROM inserted
	
SET NOCOUNT OFF
END
