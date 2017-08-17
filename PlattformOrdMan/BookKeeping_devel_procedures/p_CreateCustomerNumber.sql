USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateCustomerNumber]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateCustomerNumber](
	@identifier VARCHAR(255),
	@description varchar(255),
	@supplier_id int,
	@place_of_purchase varchar(30),
	@enabled bit = 1
)

AS
BEGIN
SET NOCOUNT ON

declare @place_of_purchase_id int


select @place_of_purchase_id = place_of_purchase_id
from place_of_purchase 
where code = @place_of_purchase

insert into customer_number
(identifier, description, supplier_id, place_of_purchase_id, enabled)
values
(@identifier, @description, @supplier_id, @place_of_purchase_id, @enabled)

SELECT * FROM customer_number_view
where id = SCOPE_IDENTITY()

SET NOCOUNT OFF
END
