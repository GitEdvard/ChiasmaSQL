--USE [GTDB2_devel]
--GO
/****** Object:  Trigger [dbo].[T_result_plate_delete]    Script Date: 11/20/2009 15:12:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_result_plate_delete] ON [dbo].[result_plate]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO result_plate_history 
	(
		result_plate_id,
		identifier,
		authority_id,
		created,
		description,
		project_id,
		gt_method_id,
		changed_action,
		uploading_flag
	)
SELECT
	rp.result_plate_id,
	rp.identifier,
	rp.authority_id,
	rp.created,
	rp.description,
	rp.project_id,
	rp.gt_method_id,
	'D',
	rp.uploading_flag
FROM deleted rp

	
SET NOCOUNT OFF
END
