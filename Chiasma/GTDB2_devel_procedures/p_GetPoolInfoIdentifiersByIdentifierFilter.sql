USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPoolInfoIdentifiersByIdentifierFilter]    Script Date: 11/20/2009 16:02:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPoolInfoIdentifiersByIdentifierFilter](@identifier_filter varchar(255))

AS
BEGIN
SET NOCOUNT ON

SELECT pifa.identifier FROM 
	pool_info_for_aliquots_view pifa 
where pifa.identifier like '%' + @identifier_filter + '%'
union
SELECT pifs.identifier FROM
	pool_info_for_samples pifs
where pifs.identifier like '%' + @identifier_filter + '%'
SET NOCOUNT OFF

END
