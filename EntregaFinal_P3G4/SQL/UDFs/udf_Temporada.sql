
use p3g4;

GO
--DROP FUNCTION udf_Temp_DataGrid;
CREATE FUNCTION udf_Temp_DataGrid(@idTemporada INT=null)
RETURNS @table TABLE (idTemporada INT, dataComeco DATE, dataTermino DATE, razao VARCHAR(30), precoSimples INT,
	precoDouble INT, precoTwin INT, precoMiniSuite INT, precoSuite INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idTemporada is NULL)
		BEGIN
			INSERT @table SELECT idTemporada, dataComeco, dataTermino, razao, precoSimples,
	precoDouble, precoTwin, precoMiniSuite, precoSuite FROM gestaoHotel.Temporada
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idTemporada, dataComeco, dataTermino, razao, precoSimples,
	precoDouble, precoTwin, precoMiniSuite, precoSuite FROM gestaoHotel.Temporada 
		WHERE gestaoHotel.Temporada.idTemporada = @idTemporada
		END;
	RETURN;
END;
