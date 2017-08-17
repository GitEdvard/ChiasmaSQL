USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetContactCategory]    Script Date: 11/20/2009 15:56:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_GetContactCategory] (@identifier VARCHAR(255))

AS
BEGIN
SET NOCOUNT ON

SELECT 
	contact_category_id AS id,
	identifier,
	description
FROM contact_category
WHERE identifier = @identifier

SET NOCOUNT OFF
END
