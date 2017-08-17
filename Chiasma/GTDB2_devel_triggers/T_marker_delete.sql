USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_marker_delete]    Script Date: 11/20/2009 15:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the marker table.

CREATE TRIGGER [dbo].[T_marker_delete] ON [dbo].[marker]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO marker_history
	(marker_id,
	 identifier,
	 species_id,
	 comment,
	 changed_action)
SELECT
	marker_id,
	identifier,
	species_id,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END



