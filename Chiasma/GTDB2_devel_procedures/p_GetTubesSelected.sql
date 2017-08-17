USE [GTDB2_devel]
GO
/****** Object:  StoredProcedure [dbo].[p_GetTubesSelected]    Script Date: 11/20/2009 15:54:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_GetTubesSelected]

AS
BEGIN
SET NOCOUNT ON

SELECT tv.* from tube_view tv inner join #SelectedTubes st on
tv.identifier = st.identifier

SET NOCOUNT OFF
END
