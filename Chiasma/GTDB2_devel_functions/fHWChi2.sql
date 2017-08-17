USE [GTDB2_devel]
GO
/****** Object:  UserDefinedFunction [dbo].[fHWChi2]    Script Date: 11/20/2009 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fHWChi2](@internal_report_id INTEGER, @marker_id INTEGER)
RETURNS DECIMAL(9,3)

--The function will return the Hardy-Weinberg Chi2 value for a certain
--marker in a certain internal report.

AS
BEGIN

DECLARE @XX_actual DECIMAL(9,3)
DECLARE @YY_actual DECIMAL(9,3)
DECLARE @XY_actual DECIMAL(9,3)
DECLARE @X_actual DECIMAL(9,3)
DECLARE @Y_actual DECIMAL(9,3)
DECLARE @n DECIMAL(9,3)
DECLARE @p_estimated DECIMAL(9,8)
DECLARE @q_estimated DECIMAL(9,8)
DECLARE @XX_expected DECIMAL(9,3)
DECLARE @YY_expected DECIMAL(9,3)
DECLARE @XY_expected DECIMAL(9,3)
DECLARE @chi2 DECIMAL(9,3)

SET @n = 0

--Store actual values for the marker from the internal report.
SELECT @XX_actual = XX,
@YY_actual = YY,
@XY_actual = XY,
@X_actual = (2*XX + XY),
@Y_actual = (2*YY + XY),
@n = (XX + YY + XY)
FROM internal_report_marker_stat
WHERE internal_report_id = @internal_report_id AND marker_id = @marker_id

--Return NULL if no results were found.
IF @n <= 0 RETURN NULL

--Estimate the p and q parameters (note that X + Y > 0 when @n > 0,
--no need to check that again)
SET @p_estimated = @X_actual / (@X_actual + @Y_actual)

SET @q_estimated = @Y_actual / (@X_actual + @Y_actual)


SET @XX_expected = @n * @p_estimated * @p_estimated

SET @YY_expected = @n * @q_estimated * @q_estimated

SET @XY_expected = 2 * @n * @p_estimated * @q_estimated

IF @XX_expected > 0 AND @YY_expected > 0 AND @XY_expected > 0
	SET @chi2 = (@XX_actual - @XX_expected) * (@XX_actual - @XX_expected) / @XX_expected +
			(@YY_actual - @YY_expected) * (@YY_actual - @YY_expected)/ @YY_expected +
			(@XY_actual - @XY_expected) * (@XY_actual - @XY_expected) / @XY_expected
ELSE
	RETURN NULL


RETURN @chi2
END


