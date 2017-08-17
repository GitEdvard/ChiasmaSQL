USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetPostsByCustomerNumberId_TableVersion1]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetPostsByCustomerNumberId_TableVersion1](
@customer_number_id INTEGER)

AS
BEGIN
SET NOCOUNT ON

SELECT * from post_table_version_1_view
WHERE customer_number_id = @customer_number_id

SET NOCOUNT OFF
END
