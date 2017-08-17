USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGtMethodByIdentifier]    Script Date: 11/20/2009 15:59:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetGtMethodByIdentifier](@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT
	gt_method_id AS id,
	identifier,
	is_bulk,
	comment
FROM gt_method
WHERE identifier = @identifier

SET NOCOUNT OFF
END
