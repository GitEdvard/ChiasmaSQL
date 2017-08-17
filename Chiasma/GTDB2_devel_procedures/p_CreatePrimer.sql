USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreatePrimer]    Script Date: 11/16/2009 13:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreatePrimer] (
	@identifier VARCHAR(255),
	@type VARCHAR(255),
	@sequence_str VARCHAR(4000),
	@orientation CHAR(1),
	@modification VARCHAR(255) = NULL,
	@comment VARCHAR(1024) = NULL)

AS
BEGIN
SET NOCOUNT ON

INSERT INTO primer
	(identifier,
	type,
	sequence_str,
	orientation,
	modification,
	comment)
VALUES
	(@identifier,
	@type,
	@sequence_str,
	@orientation,
	@modification,
	@comment)

SELECT 
	primer_id AS id,
	identifier,
	type,
	sequence_str,
	orientation,
	modification,
	comment
FROM primer
WHERE identifier = @identifier

SET NOCOUNT OFF
END
