USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateTubeRack]    Script Date: 11/20/2009 16:30:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_UpdateTubeRack](
	@id INTEGER,
	@identifier VARCHAR (255),
	@tube_rack_type_id int,
	@empty_slots int,
	@tube_rack_number int,
	@comment varchar(1024),
	@status varchar(30)
)

AS
BEGIN
SET NOCOUNT ON


update tube_rack set
	identifier = @identifier,
	tube_rack_type_id = @tube_rack_type_id,
	empty_slots = @empty_slots,
	tube_rack_number = @tube_rack_number,
	comment = @comment,
	status = @status
where tube_rack_id  = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update tube rack with id: %d', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
