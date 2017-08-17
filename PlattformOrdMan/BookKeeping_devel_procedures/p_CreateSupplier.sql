USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSupplier]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateSupplier](
@identifier VARCHAR(255),
@short_name VARCHAR(255),
@comment VARCHAR(1024),
@tel_nr VARCHAR(30),
@contract_terminate VARCHAR(255)
)

AS
BEGIN
SET NOCOUNT ON

DECLARE @supplier_id INTEGER

INSERT INTO supplier
(identifier,
short_name,
comment,
tel_nr,
contract_terminate)
VALUES
(@identifier,
@short_name,
@comment,
@tel_nr,
@contract_terminate)

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create supplier with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET @supplier_id = NULL
SELECT @supplier_id = supplier_id FROM supplier WHERE identifier = @identifier
IF @supplier_id IS NULL
BEGIN
	RAISERROR('supplier_id for supplier was not found', 15, 1)
	RETURN
END

SELECT * from supplier_view
WHERE id = @supplier_id

SET NOCOUNT OFF
END
