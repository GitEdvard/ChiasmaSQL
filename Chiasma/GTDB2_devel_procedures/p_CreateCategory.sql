USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateCategory](
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL,
	@enabled bit,
	@tag varchar(30) = NULL,
	@category_type varchar(50))

AS
BEGIN
SET NOCOUNT ON

declare @id int

-- Create State.
INSERT INTO category
	(identifier,
	 comment,
	 enabled,
	 tag,
	 category_type)
VALUES
	(@identifier,
	 @comment,
	 @enabled,
	 @tag,
	 @category_type)

set @id = scope_identity()

IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create category with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Return category.
SELECT
	category_id AS id,
	identifier,
	comment,
	enabled,
	tag,
	category_type
FROM category
WHERE category_id = @id

SET NOCOUNT OFF
END
