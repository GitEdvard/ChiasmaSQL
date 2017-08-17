use bookkeeping

GO
/****** Object:  StoredProcedure [dbo].[p_QCRebuildAll]    Script Date: 11/20/2009 16:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_ScheduledProcedureDisableProducts]
AS
BEGIN

SET NOCOUNT ON


-- SELECT satserna:
-- Lista alla produkter som ?r kopplade till en post, d?r n?gon av posterna ?r nyare ?n 18 m?nader 
-- Lista alla produkter som inte ?r kopplade till en post, och som ?r skapade inom 18 m?nader
update m set enabled = 0 from merchandise m where m.enabled = 1 and m.merchandise_id not in
(select merchandise_id from post group by post_id, book_date, merchandise_id 
having getdate() < dateadd(month, 18, max(book_date))
union 
select m.merchandise_id from merchandise m inner join merchandise_history mh on 
m.merchandise_id = mh.merchandise_id where mh.changed_action = 'i' and
getdate() < dateadd(month, 18, mh.changed_date))

end
