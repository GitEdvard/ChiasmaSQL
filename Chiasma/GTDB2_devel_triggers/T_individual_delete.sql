USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_individual_delete]    Script Date: 11/20/2009 15:11:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs delete operations in the individual table.

CREATE TRIGGER [dbo].[T_individual_delete] ON [dbo].[individual]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO individual_history
	(individual_id,
	 identifier,
	 external_name,
	 species_id,
	 sex,
	 father_id,
	 mother_id,
	 individual_usage,
	 comment,
	 changed_action)
SELECT
	individual_id,
	identifier,
	external_name,
	species_id,
	sex,
	father_id,
	mother_id,
	individual_usage,
	comment,
	'D'
FROM deleted
	
SET NOCOUNT OFF
END
