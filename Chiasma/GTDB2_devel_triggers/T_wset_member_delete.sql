USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_wset_member_delete]    Script Date: 11/20/2009 15:16:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_wset_member_delete] ON [dbo].[wset_member]
AFTER DELETE

AS
BEGIN

SET NOCOUNT ON

DECLARE @authority_id		INTEGER	
DECLARE @wset_type_name		VARCHAR(255)

SET @wset_type_name = (SELECT TOP 1 name FROM wset_type_code WHERE wset_type_id IN 
(SELECT wset_type_id FROM wset WHERE wset_id IN (SELECT wset_id FROM deleted)) )

--LOG ONLY FOR THESE WSET TYPES
IF	@wset_type_name = 'GenotypeSet' OR 
	@wset_type_name = 'MarkerSet' OR 
	@wset_type_name = 'SampleSet' OR
	@wset_type_name = 'IndividualSet' OR
	@wset_type_name = 'PrimerSet' OR
	@wset_type_name = 'AssaySet' OR
	@wset_type_name = 'PlateSet'		
BEGIN
	SET @authority_id = (SELECT authority_id FROM authority WHERE identifier = SYSTEM_USER)
	
	INSERT INTO wset_member_log (identifiable_id, kind_id, wset_id, operation, authority_id) 
		SELECT identifiable_id, kind_id, wset_id, 'D', @authority_id FROM deleted
	
END	



SET NOCOUNT OFF
END








