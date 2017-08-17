USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_CreateSampleSeries]    Script Date: 11/16/2009 13:39:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_CreateSampleSeries](
	@identifier VARCHAR(255),
	@contact_id INTEGER,
	@comment VARCHAR(2000) = NULL)

AS
BEGIN
SET NOCOUNT ON

-- Create sample serie.
INSERT INTO sample_series (identifier, contact_id, comment)
	VALUES (@identifier, @contact_id, @comment)
IF @@ERROR <> 0
BEGIN
	RAISERROR('Failed to create sample_series with identifier: %s', 15, 1, @identifier)
	RETURN
END

SELECT ss.sample_series_id AS id,
	ss.identifier AS identifier,
	ISNULL(ss.comment, '') AS comment,
	c.contact_id AS contact_id,
	c.identifier AS contact_identifier,
	c.name AS contact_name,
	c.comment AS contact_comment
FROM sample_series ss
INNER JOIN contact c ON c.contact_id = ss.contact_id
WHERE ss.identifier = @identifier

SET NOCOUNT OFF

END
