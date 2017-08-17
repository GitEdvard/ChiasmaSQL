USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesForSeqPlate]    Script Date: 11/20/2009 16:07:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_GetSamplesForSeqPlate]( @plate_id INTEGER )

AS
BEGIN
SET NOCOUNT ON

SELECT * FROM sample_seq_info_view
WHERE plate_id = @plate_id

SET NOCOUNT OFF
END
