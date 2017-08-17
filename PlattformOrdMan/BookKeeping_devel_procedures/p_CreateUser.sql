USE [bookkeeping_devel]

GO
/****** Object:  StoredProcedure [dbo].[p_CreateUser]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_CreateUser](
@identifier VARCHAR(255),
@name VARCHAR(255),
@account_status BIT,
@comment VARCHAR(1024) = NULL,
@user_type VARCHAR(32),
@place_of_purchase varchar(30)
)

AS
BEGIN
SET NOCOUNT ON
declare @place_of_purchase_id int

select @place_of_purchase_id = place_of_purchase_id 
from place_of_purchase 
where code = @place_of_purchase


-- Get current user
INSERT INTO authority
(identifier,
name,
account_status,
comment,
user_type,
place_of_purchase_id)
VALUES
(@identifier,
@name,
@account_status,
@comment,
@user_type,
@place_of_purchase_id)

SELECT 
	authority_id AS id,
	identifier,
	name,
	account_status,
	user_type,
	pop.code as place_of_purchase,
	comment
FROM authority a
	inner join place_of_purchase pop on pop.place_of_purchase_id = a.place_of_purchase_id
WHERE identifier = @identifier

SET NOCOUNT OFF
END
