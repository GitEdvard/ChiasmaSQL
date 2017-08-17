USE [FP_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetPersonId]    Script Date: 11/20/2009 16:49:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[fGetPersonId]() RETURNS INTEGER
AS
BEGIN
	DECLARE @person_id INTEGER 
	SET @person_id = -1
	DECLARE @sys_user VARCHAR(255)
	
	SET @sys_user = SYSTEM_USER
	-- PICKING OUT THE ID OF THE CURRENT USER
	SELECT @person_id = id FROM person WHERE
	user_handel = @sys_user
	IF @person_id = -1
	BEGIN
		RETURN -100
	END
		
	
	RETURN @person_id
END
	

