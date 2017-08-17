USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_DeleteIndividual]    Script Date: 11/20/2009 15:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_DeleteIndividual](@id INTEGER)

AS
BEGIN
SET NOCOUNT ON

--Delete the individual.
DELETE FROM individual WHERE individual_id = @id


SET NOCOUNT OFF
END
