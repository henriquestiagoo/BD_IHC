
use p3g4;

GO
--DROP FUNCTION udf_TipoQuarto_DataGrid;
CREATE FUNCTION udf_TipoQuarto_DataGrid(@tipo VARCHAR(10)=null)
RETURNS @table TABLE (tipo VARCHAR(10), descricao VARCHAR(50), numCamasExtraDisp INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@tipo is NULL)
		BEGIN
			INSERT @table SELECT tipo, descricao, numCamasExtraDisp FROM gestaoHotel.TipoQuarto
		END;

	ELSE
		BEGIN
			INSERT @table SELECT tipo, descricao, numCamasExtraDisp FROM gestaoHotel.TipoQuarto
				WHERE gestaoHotel.TipoQuarto.tipo = @tipo
		END;
	RETURN;
END;