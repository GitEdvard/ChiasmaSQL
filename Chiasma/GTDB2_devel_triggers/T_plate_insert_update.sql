USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_plate_insert_update]    Script Date: 11/20/2009 15:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the plate table.

ALTER TRIGGER [dbo].[T_plate_insert_update] ON [dbo].[plate]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO plate_history
	(plate_id,
	 identifier,
	 plate_type_id,
	 status,
	 plate_usage,
	 comment,
	 sample_series_id,
	 plate_number,
	 changed_action,
	 method)
SELECT
	plate_id,
	identifier,
	plate_type_id,
	status,
	plate_usage,
	comment,
	sample_series_id,
	plate_number,
	@action,
	method
FROM inserted
	
SET NOCOUNT OFF
END
