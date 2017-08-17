USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGtMethodById]    Script Date: 11/20/2009 15:59:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGtMethodById](@id TINYINT)

AS
BEGIN
SET NOCOUNT ON

SELECT
	gt_method_id AS id,
	identifier,
	is_bulk,
	comment
FROM gt_method
WHERE gt_method_id = @id

SET NOCOUNT OFF
END
