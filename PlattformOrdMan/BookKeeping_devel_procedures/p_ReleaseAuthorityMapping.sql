USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_ReleaseAuthorityMapping]    Script Date: 11/20/2009 16:30:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_ReleaseAuthorityMapping]

AS
BEGIN
SET NOCOUNT ON

-- Remove row from authority_session_mapping table
-- with session_id matching @@spid

delete from authority_session_mapping 
where session_id = @@spid


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed release authority mapping with session id: %d', 15, 1, @@spid)
	RETURN
END

SET NOCOUNT OFF
END
