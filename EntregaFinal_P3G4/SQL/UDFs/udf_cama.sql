
use p3g4;

GO
--DROP FUNCTION udf_Cama_DataGrid;
CREATE FUNCTION udf_Cama_DataGrid(@tipo VARCHAR(10)=null)
RETURNS @table TABLE (tipo VARCHAR(10), preco MONEY)
WITH SCHEMABINDING
AS
BEGIN
	IF (@tipo is NULL)
		BEGIN
			INSERT @table SELECT tipo, preco FROM gestaoHotel.Cama;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT tipo, preco FROM gestaoHotel.Cama
				WHERE gestaoHotel.Cama.tipo = @tipo;
		END;
	RETURN;
END;