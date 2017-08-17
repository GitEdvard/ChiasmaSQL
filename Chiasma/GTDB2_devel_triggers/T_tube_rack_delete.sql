USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_tube_rack_delete]    Script Date: 11/20/2009 15:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the plate table.

CREATE TRIGGER [dbo].[T_tube_rack_delete] ON [dbo].[tube_rack]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON



INSERT INTO tube_rack_history
	(
	    tube_rack_id,
		identifier,
		tube_rack_type_id,
		empty_slots,
		tube_rack_number,
		comment,
		status,
		changed_action
	 )
SELECT
	    tube_rack_id,
		identifier,
		tube_rack_type_id,
		empty_slots,
		tube_rack_number,
		comment,
		status,
		'D'
FROM deleted
	
SET NOCOUNT OFF
END
