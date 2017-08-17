USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSampleByIdentifier]    Script Date: 11/20/2009 16:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_GetSeqSampleByIdentifier]( @identifier VARCHAR (255) )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_seq_info_view
WHERE identifier = @identifier

SET NOCOUNT OFF
END

