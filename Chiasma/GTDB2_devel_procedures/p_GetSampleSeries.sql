USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleSeries]    Script Date: 11/20/2009 16:06:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetSampleSeries]

AS
BEGIN
SET NOCOUNT ON

SELECT
	sample_series.sample_series_id AS id,
	sample_series.identifier AS identifier,
	sample_series.comment  AS comment,
	contact.contact_id AS contact_id,
	contact.identifier AS contact_identifier,
	contact.name AS contact_name,
	contact.comment AS contact_comment
FROM sample_series
INNER JOIN contact ON contact.contact_id = sample_series.contact_id
ORDER BY sample_series.identifier ASC

SET NOCOUNT OFF
END
