USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSampleConcentrationCustomer]    Script Date: 11/20/2009 16:30:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_UpdateSampleConcentrationCustomer](
	@id INTEGER,
	@concentration_customer FLOAT,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Update sample.
UPDATE sample SET
	concentration_customer = @concentration_customer,
	comment = @comment
WHERE sample_id = @id
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update sample with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
