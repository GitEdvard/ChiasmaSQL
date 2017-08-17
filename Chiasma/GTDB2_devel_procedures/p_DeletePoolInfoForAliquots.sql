USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeletePoolInfoForAliquots]    Script Date: 11/20/2009 15:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_DeletePoolInfoForAliquots](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

delete from tube_aliquot where pool_info_for_aliquots_id = @id

delete from pool_info_for_aliquots where pool_info_for_aliquots_id = @id

SET NOCOUNT OFF
END
