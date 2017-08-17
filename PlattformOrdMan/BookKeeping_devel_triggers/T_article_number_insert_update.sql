
USE [BookKeeping_devel]
GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.

CREATE TRIGGER [dbo].[T_article_number_insert_update] ON [dbo].[article_number]
AFTER INSERT, UPDATE

AS
BEGIN
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO article_number_history
	(article_number_id,
	 identifier,
	 merchandise_id,
	 active, 
	 changed_action)
SELECT
	 article_number_id,
	 identifier,
	 merchandise_id,
	 active,      
	 @action
FROM inserted
	
SET NOCOUNT OFF
END
