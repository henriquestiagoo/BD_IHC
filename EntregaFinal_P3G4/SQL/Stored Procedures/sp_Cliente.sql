

use p3g4;

-- ##############################################################################################
-- #											CLIENTE												#
-- ##############################################################################################

--DROP PROCEDURE sp_AddCliente;
GO
--Criação de um Servico
CREATE PROCEDURE sp_AddCliente
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9)	
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo ou telefone não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the client already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pessoa JOIN gestaoHotel.Cliente ON idPessoa=id WHERE Pnome=@Pnome AND Unome=@Unome AND email=@email
			AND dataNasc=@dataNasc AND endereco=@endereco AND codigoPostal=@codigoPostal AND sexo=@sexo AND nrTelefone=@nrTelefone;
		IF @COUNT != 0
			BEGIN
				RAISERROR ('O Cliente que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		-- check the max person id
		DECLARE @MaxPerson INT
		SELECT @MaxPerson = MAX(idPessoa) FROM gestaoHotel.Pessoa;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Pessoa([idPessoa],[Pnome],[Unome],[email],[dataNasc],[endereco],[codigoPostal],[sexo],[nrTelefone]) 
				VALUES (@MaxPerson+1,@Pnome,@Unome,@email,@dataNasc,@endereco,@codigoPostal,@sexo,@nrTelefone)
			INSERT INTO GestaoHotel.Cliente([id]) 
				VALUES (@MaxPerson+1)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do cliente!', 14, 1)
		END CATCH;

GO
--DROP PROCEDURE sp_UpdateCliente;
--Atualização de um Cliente
CREATE PROCEDURE sp_UpdateCliente
	@idPessoa			INT,
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9)	
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo ou telefone não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the client already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pessoa WHERE idPessoa = @idPessoa;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Cliente em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Pessoa SET idPessoa = @idPessoa, Pnome = @Pnome, Unome = @Unome,
				email = @email, dataNasc = @dataNasc, endereco = @endereco, codigoPostal = @codigoPostal, sexo=@sexo,
					nrTelefone=@nrTelefone WHERE idPessoa = @idPessoa;
			UPDATE  gestaoHotel.Cliente SET id = @idPessoa WHERE id = @idPessoa;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do cliente!', 14, 1)
		END CATCH;

-- DROP PROCEDURE sp_DeleteCliente
GO
CREATE PROCEDURE sp_DeleteCliente
	@idPessoa		INT
	AS 
	IF @idPessoa is NULL
	BEGIN
		PRINT 'O Cliente não pode ser estar vazio!'
		RETURN
	END
	-------------------------------------------------------------------
	BEGIN TRY
		DELETE FROM gestaoHotel.Cliente WHERE id = @idPessoa;	
		DELETE FROM gestaoHotel.Pessoa WHERE idPessoa = @idPessoa;
	END TRY
	BEGIN CATCH
		RAISERROR ('O cliente possui reversas ou serviços logo não pode ser eliminado!', 14, 1)
	END CATCH

