
use p3g4;


-- ##############################################################################################
-- #											Funcionarios										#
-- ##############################################################################################

GO
--DROP FUNCTION udf_Func_DataGrid;
CREATE FUNCTION udf_Func_DataGrid(@id INT=null)
RETURNS @table TABLE (id INT, Pnome VARCHAR(15), Unome VARCHAR(30), sexo CHAR(1), email VARCHAR(50), dataNasc DATE, 
	endereco VARCHAR(50), nrTelefone CHAR(9), codigoPostal VARCHAR(10), salario INT, hotel INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@id is NULL)
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id;
		END;
	ELSE
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id
			WHERE id=@id;
		END;
	RETURN;
END;

-- ##############################################################################################
-- #											Recepcionistas										#
-- ##############################################################################################

GO
--DROP FUNCTION udf_Rec_DataGrid;
CREATE FUNCTION udf_Rec_DataGrid(@id INT=null)
RETURNS @table TABLE (id INT, Pnome VARCHAR(15), Unome VARCHAR(30), sexo CHAR(1), email VARCHAR(50), dataNasc DATE, 
	endereco VARCHAR(50), nrTelefone CHAR(9), codigoPostal VARCHAR(10), salario INT, hotel INT, supervisor INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@id is NULL)
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel, supervisor FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id JOIN
		gestaoHotel.Recepcionista ON Funcionario.id=Recepcionista.nrFuncionario;
		END;
	ELSE
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel, supervisor FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id JOIN
		gestaoHotel.Recepcionista ON Funcionario.id=Recepcionista.nrFuncionario WHERE id=@id;
		END;
	RETURN;
END;

-- ##############################################################################################
-- #											Empregados											#
-- ##############################################################################################

GO
--DROP FUNCTION udf_Emp_DataGrid;
CREATE FUNCTION udf_Emp_DataGrid(@id INT=null)
RETURNS @table TABLE (id INT, Pnome VARCHAR(15), Unome VARCHAR(30), sexo CHAR(1), email VARCHAR(50), dataNasc DATE, 
	endereco VARCHAR(50), nrTelefone CHAR(9), codigoPostal VARCHAR(10), salario INT, hotel INT, supervisor INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@id is NULL)
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel, supervisor FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id JOIN
	gestaoHotel.Empregado ON Funcionario.id=Empregado.nrFuncionario;
		END;
	ELSE
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel, supervisor FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id JOIN
	gestaoHotel.Empregado ON Funcionario.id=Empregado.nrFuncionario WHERE id=@id;
		END;
	RETURN;
END;

-- ##############################################################################################
-- #											Gerentes											#
-- ##############################################################################################

GO
--DROP FUNCTION udf_Ger_DataGrid;
CREATE FUNCTION udf_Ger_DataGrid(@id INT=null)
RETURNS @table TABLE (id INT, Pnome VARCHAR(15), Unome VARCHAR(30), sexo CHAR(1), email VARCHAR(50), dataNasc DATE, 
	endereco VARCHAR(50), nrTelefone CHAR(9), codigoPostal VARCHAR(10), salario INT, hotel INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@id is NULL)
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id JOIN
	gestaoHotel.Gerente ON Funcionario.id=Gerente.nrFuncionario;;
		END;
	ELSE
		BEGIN
			INSERT @table SELECT id, Pnome, Unome, sexo, email, dataNasc, 
	endereco, nrTelefone, codigoPostal, salario, hotel FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id JOIN
	gestaoHotel.Gerente ON Funcionario.id=Gerente.nrFuncionario WHERE id=@id;
		END;
	RETURN;
END;