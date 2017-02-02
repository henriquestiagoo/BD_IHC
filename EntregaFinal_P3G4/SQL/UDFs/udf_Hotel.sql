
use p3g4;

GO
--DROP FUNCTION udf_Hotel_DataGrid;
CREATE FUNCTION udf_Hotel_Datagrid(@idHotel INT=null)
RETURNS @table TABLE (idHotel INT, nome VARCHAR(30), classificacao INT, localizacao VARCHAR(50), codigoPostal VARCHAR(10), gerente INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idHotel is NULL)
		BEGIN
			INSERT @table SELECT idHotel, nome, classificacao, localizacao, codigoPostal, gerente FROM gestaoHotel.Hotel
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idHotel, nome, classificacao, localizacao, codigoPostal, gerente FROM gestaoHotel.Hotel
				WHERE gestaoHotel.Hotel.idHotel = @idHotel
		END;
	RETURN;
END;

GO
-- DROP FUNCTION udf_Hotel_func;
CREATE FUNCTION udf_Hotel_func(@id_func INT=NULL) 
RETURNS @table TABLE (idHotel INT, nome VARCHAR(30))
WITH SCHEMABINDING
AS
BEGIN
	IF (@id_func is NULL)
		BEGIN
			INSERT @table SELECT idHotel, nome FROM gestaoHotel.Hotel;
		END;
	ELSE
		BEGIN
			INSERT @table SELECT gestaoHotel.Funcionario.hotel, gestaoHotel.Hotel.nome
						  FROM (gestaoHotel.Hotel JOIN gestaoHotel.Funcionario
						  ON gestaoHotel.Hotel.idHotel = gestaoHotel.Funcionario.hotel)
						  WHERE gestaoHotel.Funcionario.id = @id_func;
		END;
	RETURN;
END;
