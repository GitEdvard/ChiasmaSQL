USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_marker_update]    Script Date: 11/20/2009 15:12:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_marker_update] ON [dbo].[marker]
AFTER UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO marker_history (marker_id,
		identifier,
		species_id,
		comment,
		marker_reference,
		fiveprime_flank,
		threeprime_flank,
		gene,
		position,
		position_reference,
		chromosome,
		changed_action
)
SELECT i.marker_id,
	i.identifier,
	i.species_id,
	i.comment,
	md.marker_reference,
	md.fiveprime_flank,
	md.threeprime_flank,
	md.gene,
	md.position,
	md.position_reference,
	md.chromosome,
	@action
FROM inserted i
LEFT OUTER JOIN marker_details md ON md.marker_id = i.marker_id
	
SET NOCOUNT OFF
END
