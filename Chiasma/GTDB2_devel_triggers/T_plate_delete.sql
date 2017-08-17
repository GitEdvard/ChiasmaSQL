USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_plate_delete]    Script Date: 11/20/2009 12:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the plate table.

ALTER TRIGGER [dbo].[T_plate_delete] ON [dbo].[plate]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

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
	'D',
	method
FROM deleted
	
SET NOCOUNT OFF
END


