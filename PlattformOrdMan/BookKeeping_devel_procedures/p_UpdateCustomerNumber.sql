USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateCustomerNumber]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateCustomerNumber](
@id INTEGER,
@identifier VARCHAR(255),
@description varchar(255),
@place_of_purchase VARCHAR(30),
@supplier_id int,
@enabled bit
)

AS
BEGIN
SET NOCOUNT ON

declare @place_of_purchase_id int

select @place_of_purchase_id = place_of_purchase_id
from place_of_purchase where code = @place_of_purchase

update customer_number set
	identifier = @identifier,
	description = @description,
	place_of_purchase_id = @place_of_purchase_id,
	supplier_id = @supplier_id,
	enabled = @enabled
where customer_number_id = @id

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to update customer number with id: %s', 15, 1, @id)
	RETURN
END

SET NOCOUNT OFF
END
