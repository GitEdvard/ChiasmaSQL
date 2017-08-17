USE [BookKeeping_devel]
GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.

CREATE TRIGGER [dbo].[T_article_number_delete] ON [dbo].[article_number]
AFTER DELETE

AS
BEGIN 
SET NOCOUNT ON

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
     'D'
FROM deleted
	
SET NOCOUNT OFF
END
