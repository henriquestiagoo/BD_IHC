
use p3g4;

GO
--DROP FUNCTION udf_Cliente_DataGrid;
CREATE FUNCTION udf_Cliente_DataGrid(@id INT=null)
RETURNS @table TABLE (id INT, Pnome VARCHAR(15), Unome VARCHAR(30), sexo CHAR(1), email VARCHAR(50), dataNasc DATE, 
	endereco VARCHAR(50), nrTelefone CHAR(9), codigoPostal VARCHAR(10))
WITH SCHEMABINDING
AS
BEGIN
	IF (@id is NULL)
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal FROM gestaoHotel.Pessoa JOIN gestaoHotel.Cliente ON idPessoa=id;
		END;
	ELSE
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal FROM gestaoHotel.Pessoa JOIN gestaoHotel.Cliente ON idPessoa=id
			WHERE id=@id;
		END;
	RETURN;
END;