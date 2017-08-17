USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_QCInsertWsetOffset]    Script Date: 11/20/2009 16:26:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_QCInsertWsetOffset] (@targetDB VARCHAR(255), @offset INTEGER, @errorMessage VARCHAR(255) OUTPUT)
AS
BEGIN

SET NOCOUNT ON

DECLARE @cmd VARCHAR(1500)
DECLARE @useTarget VARCHAR(24)
DECLARE @e INTEGER

SET @useTarget = 'USE ' + @targetDB + ' '

SET @cmd = '
DECLARE @authorityId INTEGER
DECLARE @wsetTypeId INTEGER

SELECT TOP 1 @authorityId = authority_id FROM authority  --Take any authority.

SELECT @wsetTypeId = wset_type_id FROM wset_type
WHERE name = ''SavedSession''

INSERT INTO wset (wset_id, identifier, authority_id, wset_type_id)
VALUES (' + CAST(@offset AS VARCHAR(30)) + ', ''<Offset ' + CAST(@targetDB AS VARCHAR(32)) + '>'', @authorityId, @wsetTypeId) 
'

EXEC (@useTarget + @cmd)

SET @e = @@ERROR IF @e <> 0 BEGIN SET @errorMessage = 'Error inserting wset offset: ' + CAST(@e AS VARCHAR) RETURN -100 END

SET NOCOUNT OFF

END
