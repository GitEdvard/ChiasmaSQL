USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdatePostPrizeByMerchandise]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdatePostPrizeByMerchandise](
@merchandise_id INTEGER,
@appr_prize money = null,
@currency_id int = null
)
 
AS
BEGIN
SET NOCOUNT ON

-- Update all posts with refered merchandise_id and that have invoie status = incoming
-- If currency is changed, reset final prize

UPDATE post_table_version_2
SET appr_prize = @appr_prize,
	currency_id = @currency_id,
	final_prize = case when p.currency_id = @currency_id then final_prize else null end
from post_table_version_2 p 
	left outer join invoice i on p.invoice_id = i.invoice_id
	left outer join order_summary os on os.order_summary_id = p.order_summary_id
WHERE 
	merchandise_id = @merchandise_id 
	and 
	ISNULL(i.status, 'Incoming') = 'Incoming'
	and not
	(
		os.invoice_absent = 1 and not ISNULL(p.arrival_sign, -1) = -1
	)


IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update post with merchandise_id: %s', 15, 1, @merchandise_id)
	RETURN
END

select * 
from post_table_version_2_view
where 
	merchandise_id = @merchandise_id 
	and 
	isnull(invoice_status, 'Incoming') = 'Incoming'
	and not
	(
		invoice_absent = 1 and not ISNULL(arrival_sign, -1) = -1
	)

SET NOCOUNT OFF
END
