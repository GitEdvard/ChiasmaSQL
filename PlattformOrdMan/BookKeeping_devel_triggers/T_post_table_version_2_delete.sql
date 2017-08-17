--USE [BookKeeping_devel]
--GO
/****** Object:  Trigger [dbo].[T_post_table_version_2_insert_delete]    Script Date: 11/20/2009 15:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Logs insert and update operations to the aliquot table.


ALTER TRIGGER [dbo].[T_post_table_version_2_delete] ON [dbo].[post_table_version_2]
AFTER DELETE
 
AS
BEGIN
SET NOCOUNT ON

INSERT INTO post_history_table_version_2
	(post_id,
	 article_number_id,
	 comment,
	 authority_id_booker,
	 book_date,
	 merchandise_id,
	 supplier_id,
	 predicted_arrival,
	 arrival_date,
	 arrival_sign,
	 amount,
	 currency_id,
	 final_prize,
	 delivery_deviation,
	 order_summary_id,
	 table_version,
	 invoice_id,
	 place_of_purchase_id,
	 appr_prize,
	 changed_action)
SELECT
	 post_id,
	 article_number_id,
	 comment,
	 authority_id_booker,
	 book_date,
	 merchandise_id,
	 supplier_id,
	 predicted_arrival,
	 arrival_date,
	 arrival_sign,
	 amount,
	 currency_id,
	 final_prize,
	 delivery_deviation,
	 order_summary_id,
	 table_version,
	 invoice_id,
	 place_of_purchase_id,
	 appr_prize,
     'D'
FROM deleted
	
SET NOCOUNT OFF
END