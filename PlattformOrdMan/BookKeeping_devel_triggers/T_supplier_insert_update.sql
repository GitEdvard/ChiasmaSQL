USE [BookKeeping_devel]
GO
/****** Object:  Trigger [dbo].[T_aliquot_insert_update]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.

CREATE TRIGGER [dbo].[T_supplier_insert_update] ON [dbo].[supplier]
AFTER INSERT, UPDATE

AS
BEGIN 
SET NOCOUNT ON

DECLARE @action CHAR(1)

IF EXISTS(SELECT * FROM deleted) SET @action = 'U' ELSE SET @action = 'I'

INSERT INTO supplier_history
	(supplier_id,
	 identifier,
	 enabled, 
	 comment,
	 tel_nr,
	 customer_nr_inst,
	 customer_nr_clin,
	 contract_terminate,
	 short_name,
	 changed_action)
SELECT
	 supplier_id,
	 identifier,
	 enabled, 
	 comment,
	 tel_nr,
	 customer_nr_inst,
	 customer_nr_clin,
	 contract_terminate,
	 short_name,
     @action
FROM inserted
	
SET NOCOUNT OFF
END
