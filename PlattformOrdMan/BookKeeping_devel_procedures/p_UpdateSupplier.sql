USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateSupplier]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateSupplier](
@id INTEGER,
@identifier VARCHAR(255),
@short_name VARCHAR(255),
@enabled BIT,
@comment VARCHAR(1024),
@tel_nr VARCHAR(30),
@contract_terminate VARCHAR(255)
)

AS
BEGIN
SET NOCOUNT ON

UPDATE supplier SET
identifier = @identifier,
short_name = @short_name,
enabled = @enabled,
comment = @comment,
tel_nr = @tel_nr,
contract_terminate = @contract_terminate
WHERE supplier_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update supplier with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
