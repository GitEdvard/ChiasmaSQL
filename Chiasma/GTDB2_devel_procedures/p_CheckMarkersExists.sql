USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CheckMarkersExists]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CheckMarkersExists]

AS
BEGIN
SET NOCOUNT ON
-- temp table #marker_identifier must be initialized in a separate call

select m.identifier 
	from marker m inner join #marker_identifier mi on mi.marker = m.identifier

SET NOCOUNT OFF
END
