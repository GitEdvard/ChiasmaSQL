USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlates]    Script Date: 11/20/2009 16:03:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPlates] (
	@identifier_filter VARCHAR(255), 
	@include_disposed_plates BIT)

AS
BEGIN
SET NOCOUNT ON

-- Get plates.
SELECT * from plate_view 
WHERE identifier LIKE @identifier_filter AND
	(status = 'Active' OR @include_disposed_plates = 1)

SET NOCOUNT OFF
END
