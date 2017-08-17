USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateResultPlate]    Script Date: 11/20/2009 16:27:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_UpdateResultPlate](
	@id int,
	@uploading_flag bit
)

AS
BEGIN
SET NOCOUNT ON

update result_plate set uploading_flag = @uploading_flag where result_plate_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to result plate with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
