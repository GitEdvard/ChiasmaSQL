USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_marker_details_insert_update]    Script Date: 11/20/2009 15:13:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_marker_details_insert_update] ON [dbo].[marker_details]
AFTER INSERT, UPDATE

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
	m.identifier,
	m.species_id,
	m.comment,
	i.marker_reference,
	i.fiveprime_flank,
	i.threeprime_flank,
	i.gene,
	i.position,
	i.position_reference,
	i.chromosome,
	@action
FROM inserted i
INNER JOIN marker m ON m.marker_id = i.marker_id
	
SET NOCOUNT OFF
END
