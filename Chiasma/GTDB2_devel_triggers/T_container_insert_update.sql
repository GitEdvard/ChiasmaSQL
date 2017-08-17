USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_container_insert_update]    Script Date: 11/20/2009 15:10:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the container table.

CREATE TRIGGER [dbo].[T_container_insert_update] ON [dbo].[container]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO container_history
	(container_id,
	 identifier,
	 container_type_id,
	 size_x,
	 size_y,
	 size_z,
	 status,
	 comment,
	 changed_action)
SELECT
	container_id,
	identifier,
	container_type_id,
	size_x,
	size_y,
	size_z,
	status,
	comment,
	@action
FROM inserted
	
SET NOCOUNT OFF
END
