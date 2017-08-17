USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubeAliquotHistory]    Script Date: 11/20/2009 15:54:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetTubeAliquotHistory]
	(@tube_aliquot_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

select * from tube_aliquot_history_view
WHERE
	tube_aliquot_id = @tube_aliquot_id
ORDER BY changed_date ASC

SET NOCOUNT OFF
END
