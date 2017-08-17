USE [GTDB2_devel]
GO
/****** Object:  Trigger [dbo].[T_individual_insert_update]    Script Date: 11/20/2009 15:11:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the individual table.

CREATE TRIGGER [dbo].[T_individual_insert_update] ON [dbo].[individual]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

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
	@action
FROM inserted
	
SET NOCOUNT OFF
END
