USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetGenericMasterContainers]    Script Date: 11/20/2009 15:59:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_GetGenericMasterContainers] (@identifier_filter VARCHAR (255))

AS
BEGIN
SET NOCOUNT ON

-- Get plates.
select 
	* 
from plate_view pv
where
	pv.identifier like @identifier_filter and
	pv.status = 'Active' and
	pv.plate_usage = 'MasterPlate'
-- Get tubes.
select 
	* 
from tube_view tv
where 
	tv.identifier like @identifier_filter and
	tv.status = 'Active' and
	tv.tube_usage = 'MasterTube'

SET NOCOUNT OFF
END
