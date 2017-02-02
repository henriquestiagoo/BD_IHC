
use p3g4;

GO
--DROP FUNCTION udf_Pensao_DataGrid;
CREATE FUNCTION udf_Pensao_DataGrid(@tipo VARCHAR(3)=null)
RETURNS @table TABLE (tipo VARCHAR(3), descricao VARCHAR(50))
WITH SCHEMABINDING
AS
BEGIN
	IF (@tipo is NULL)
		BEGIN
			INSERT @table SELECT tipo, descricao FROM gestaoHotel.Pensao
		END;

	ELSE
		BEGIN
			INSERT @table SELECT tipo, descricao FROM gestaoHotel.Pensao
				WHERE gestaoHotel.Pensao.tipo = @tipo
		END;
	RETURN;
END;
