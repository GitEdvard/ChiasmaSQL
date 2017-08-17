USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPlatesByIdentifierLeftMatch]    Script Date: 11/20/2009 16:03:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_GetPlatesByIdentifierLeftMatch] (
	@identifier_filter varchar(255), 
	@include_disposed_plates BIT)

-- Exact match on the beginning of the string, free end
AS
BEGIN
SET NOCOUNT ON

-- Get plates.
SELECT * from plate_view 
WHERE identifier like @identifier_filter + '%' AND
	(status = 'Active' OR @include_disposed_plates = 1)

SET NOCOUNT OFF
END
