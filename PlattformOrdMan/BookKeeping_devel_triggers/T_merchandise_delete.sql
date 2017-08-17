USE [BookKeeping_devel]
GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.

CREATE TRIGGER [dbo].[T_merchandise_delete] ON [dbo].[merchandise]
AFTER DELETE

AS
BEGIN
SET NOCOUNT ON

INSERT INTO merchandise_history
	(merchandise_id,
	 identifier,
	 supplier_id,
	 enabled, 
	 comment,
	 amount,
	 appr_prize,
	 storage,
	 category,
	 invoice_category_id,
	 currency_id,
	 changed_action)
SELECT
	 merchandise_id,
	 identifier,
	 supplier_id,
	 enabled, 
	 comment,
	 amount,
	 appr_prize,
	 storage,
	 category,
	 invoice_category_id,
	 currency_id,
     'D'
FROM deleted
	
SET NOCOUNT OFF
END