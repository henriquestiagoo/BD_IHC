
use p3g4;


GO
--DROP FUNCTION udf_Quarto_DataGrid;
CREATE FUNCTION udf_Quarto_DataGrid(@idQuarto INT=null)
RETURNS @table TABLE (idQuarto INT, fumador BINARY, estado BINARY, telefone INT, tipoQuarto VARCHAR(10), hotel INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idQuarto is NULL)
		BEGIN
			INSERT @table SELECT idQuarto, fumador, estado, telefone, tipoQuarto, hotel FROM gestaoHotel.Quarto;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idQuarto, fumador, estado, telefone, tipoQuarto, hotel FROM gestaoHotel.Quarto
				WHERE gestaoHotel.Quarto.idQuarto = @idQuarto;
		END;
	RETURN;
END;