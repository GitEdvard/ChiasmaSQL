USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_container_delete]    Script Date: 11/20/2009 15:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the container table.

CREATE TRIGGER [dbo].[T_container_delete] ON [dbo].[container]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

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
	'D'
FROM deleted
	
SET NOCOUNT OFF
END

