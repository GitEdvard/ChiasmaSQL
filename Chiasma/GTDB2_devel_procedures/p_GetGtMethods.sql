USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGtMethods]    Script Date: 11/20/2009 16:00:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGtMethods]

AS
BEGIN
SET NOCOUNT ON

SELECT
	gt_method_id AS id,
	identifier,
	is_bulk,
	comment
FROM gt_method

SET NOCOUNT OFF
END
