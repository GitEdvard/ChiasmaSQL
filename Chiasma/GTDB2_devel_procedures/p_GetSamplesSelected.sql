USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetSamplesSelected]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_GetSamplesSelected]

AS
BEGIN
SET NOCOUNT ON

SELECT sv.* from sample_view sv inner join #SelectedSamples ss on
sv.identifier = ss.identifier

SET NOCOUNT OFF
END
