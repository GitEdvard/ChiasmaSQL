USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_tube_rack_insert_update]    Script Date: 11/20/2009 15:13:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the plate table.

CREATE TRIGGER [dbo].[T_tube_rack_insert_update] ON [dbo].[tube_rack]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
		@action
FROM inserted
	
SET NOCOUNT OFF
END
