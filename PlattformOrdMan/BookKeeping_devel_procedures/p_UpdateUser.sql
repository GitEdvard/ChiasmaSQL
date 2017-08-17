USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_UpdateUser]    Script Date: 11/20/2009 16:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[p_UpdateUser](
@id INTEGER,
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

-- Get current user
UPDATE authority SET
identifier = @identifier,
name = @name,
account_status = @account_status,
comment = @comment,
user_type = @user_type,
place_of_purchase_id = pop.place_of_purchase_id
from place_of_purchase pop 
WHERE authority_id = @id and pop.code = @place_of_purchase

SET NOCOUNT OFF
END
