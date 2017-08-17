USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateState]    Script Date: 11/16/2009 13:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_CreateState](
	@identifier VARCHAR(255),
	@comment VARCHAR(1024) = NULL,
	@enabled bit,
	@tag varchar(30) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Create State.
INSERT INTO state
	(identifier,
	 comment,
	 enabled,
	 tag)
VALUES
	(@identifier,
	 @comment,
	 @enabled,
	 @tag)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create State with identifier: %s', 15, 1, @identifier)
	RETURN
END

-- Return State.
SELECT
	state_id AS id,
	identifier,
	comment,
	enabled,
	tag,
	'State' as category_type
FROM state
WHERE identifier = @identifier

SET NOCOUNT OFF
END
