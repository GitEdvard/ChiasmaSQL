USE [BookKeeping_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateArticleNumberNoSelect]    Script Date: 11/20/2009 16:10:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p_CreateArticleNumberNoSelect](
@identifier VARCHAR(255),
@merchandise_id INTEGER,
@active bit = 1
)

AS
BEGIN
SET NOCOUNT ON

declare @id integer

if @active = 1 
-- Make all previous article numbers for this merchandise_id inactive
begin
UPDATE article_number SET active = 0 WHERE merchandise_id = @merchandise_id
end

INSERT INTO article_number
(identifier,
merchandise_id)
VALUES
(@identifier,
@merchandise_id)

set @id = scope_identity()

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create article number with identifier: %s', 15, 1, @identifier)
	RETURN
END

SET NOCOUNT OFF
END
