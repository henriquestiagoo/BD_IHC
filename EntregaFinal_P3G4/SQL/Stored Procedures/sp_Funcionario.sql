
use p3g4;

-- ##############################################################################################
-- #												REC												#
-- ##############################################################################################

--DROP PROCEDURE sp_AddRec;
GO
--Criação de um rececionista
CREATE PROCEDURE sp_AddRec
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9),
	@salario			INT,
	@hotel				INT,
	@supervisor			INT
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
			OR @salario is NULL OR @hotel is NULL
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo, telefone, salário ou hotel não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the client already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id WHERE Pnome=@Pnome AND Unome=@Unome AND email=@email
			AND dataNasc=@dataNasc AND endereco=@endereco AND codigoPostal=@codigoPostal AND sexo=@sexo AND nrTelefone=@nrTelefone;
		IF @COUNT != 0
			BEGIN
				RAISERROR ('O Funcionario que pretende adicionar já existe!', 14, 1)
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
			INSERT INTO GestaoHotel.Funcionario([id],[salario],[hotel]) 
				VALUES (@MaxPerson+1,@salario,@hotel)
			INSERT INTO GestaoHotel.Recepcionista([nrFuncionario],[supervisor]) 
				VALUES (@MaxPerson+1,@supervisor)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do recepcionista!', 14, 1)
		END CATCH;


GO
--DROP PROCEDURE sp_UpdateRec;
--Update de um recepcionista
CREATE PROCEDURE sp_UpdateRec
	@idPessoa			INT,
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9),
	@salario			INT,
	@hotel				INT,
	@supervisor			INT
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
			OR @salario is NULL OR @hotel is NULL
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo, telefone, salário ou hotel não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the recepcionist already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Recepcionista WHERE nrFuncionario = @idPessoa;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Recepcionista em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Pessoa SET idPessoa = @idPessoa, Pnome = @Pnome, Unome = @Unome,
				email = @email, dataNasc = @dataNasc, endereco = @endereco, codigoPostal = @codigoPostal, sexo=@sexo,
					nrTelefone=@nrTelefone WHERE idPessoa = @idPessoa;
			UPDATE  gestaoHotel.Funcionario SET id = @idPessoa, salario=@salario, hotel=@hotel WHERE id = @idPessoa;
			UPDATE gestaoHotel.Recepcionista SET nrFuncionario = @idPessoa, supervisor=@supervisor WHERE nrFuncionario=@idPessoa;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do recepcionista!', 14, 1)
		END CATCH;

-- DROP PROCEDURE sp_DeleteRec
GO
CREATE PROCEDURE sp_DeleteRec
	@idPessoa	INT
	AS 
	IF @idPessoa is NULL
	BEGIN
		PRINT 'O id da Pessoa não pode ser estar vazio!'
		RETURN
	END
	-------------------------------------------------------------------------
	-- check if employee has services
	DECLARE @COUNT2 INT
	SELECT @COUNT2 = COUNT(*) FROM gestaoHotel.Servico WHERE funcionario=@idPessoa;
	IF @COUNT2 != 0
		BEGIN
			RAISERROR ('Impossível eliminar recepcionista pois participou em serviços!', 14, 1)
			RETURN
		END;
	-------------------------------------------------------------------------
	-- check if employee has reservations
	DECLARE @COUNT3 INT
	SELECT @COUNT3 = COUNT(*) FROM gestaoHotel.Reserva WHERE recepcionista=@idPessoa;
	IF @COUNT3 != 0
		BEGIN
			RAISERROR ('Impossível eliminar recepcionista pois participou em reservas!', 14, 1)
			RETURN
		END;
	-------------------------------------------------------------------------
	-- check if employee is another employee supervisor
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM gestaoHotel.Recepcionista WHERE supervisor = @idPessoa;
	IF @COUNT != 0
		BEGIN
			UPDATE gestaoHotel.Recepcionista SET supervisor = NULL WHERE supervisor=@idPessoa;
		END;
	-------------------------------------------------------------------------
	BEGIN TRY
		DELETE FROM gestaoHotel.Recepcionista WHERE nrFuncionario=@idPessoa;
		DELETE FROM gestaoHotel.Funcionario WHERE id = @idPessoa;	
		DELETE FROM gestaoHotel.Pessoa WHERE idPessoa = @idPessoa;
	END TRY
	-------------------------------------------------------------------------
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do recepcionista!', 14, 1)
	END CATCH;



-- ##############################################################################################
-- #												EMP												#
-- ##############################################################################################

--DROP PROCEDURE sp_AddEmp;
GO
--Criação de um empregado
CREATE PROCEDURE sp_AddEmp
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9),
	@salario			INT,
	@hotel				INT,
	@supervisor			INT
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
			OR @salario is NULL OR @hotel is NULL 
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo, telefone, salário ou hotel não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the client already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id WHERE Pnome=@Pnome AND Unome=@Unome AND email=@email
			AND dataNasc=@dataNasc AND endereco=@endereco AND codigoPostal=@codigoPostal AND sexo=@sexo AND nrTelefone=@nrTelefone;
		IF @COUNT != 0
			BEGIN
				RAISERROR ('O Funcionario que pretende adicionar já existe!', 14, 1)
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
			INSERT INTO GestaoHotel.Funcionario([id],[salario],[hotel]) 
				VALUES (@MaxPerson+1,@salario,@hotel)
			INSERT INTO GestaoHotel.Empregado([nrFuncionario],[supervisor]) 
				VALUES (@MaxPerson+1,@supervisor)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do empregado!', 14, 1)
		END CATCH;
	
GO
--DROP PROCEDURE sp_UpdateEmp;
--Update de um rececionista
CREATE PROCEDURE sp_UpdateEmp
	@idPessoa			INT,
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9),
	@salario			INT,
	@hotel				INT,
	@supervisor			INT
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
			OR @salario is NULL OR @hotel is NULL
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo, telefone, salário ou hotel não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the mister already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Empregado WHERE nrFuncionario = @idPessoa;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Empregado em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Pessoa SET idPessoa = @idPessoa, Pnome = @Pnome, Unome = @Unome,
				email = @email, dataNasc = @dataNasc, endereco = @endereco, codigoPostal = @codigoPostal, sexo=@sexo,
					nrTelefone=@nrTelefone WHERE idPessoa = @idPessoa;
			UPDATE  gestaoHotel.Funcionario SET id = @idPessoa, salario=@salario, hotel=@hotel WHERE id = @idPessoa;
			UPDATE gestaoHotel.Empregado SET nrFuncionario = @idPessoa, supervisor=@supervisor WHERE nrFuncionario=@idPessoa;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do recepcionista!', 14, 1)
		END CATCH;		


-- DROP PROCEDURE sp_DeleteEmp
GO
CREATE PROCEDURE sp_DeleteEmp
	@idPessoa	INT
	AS 
	IF @idPessoa is NULL
	BEGIN
		PRINT 'O id da Pessoa não pode ser estar vazio!'
		RETURN
	END
	-------------------------------------------------------------------------
	-- check if employee has services
	DECLARE @COUNT2 INT
	SELECT @COUNT2 = COUNT(*) FROM gestaoHotel.Servico WHERE funcionario=@idPessoa;
	IF @COUNT2 != 0
		BEGIN
			RAISERROR ('Impossível eliminar empregado pois participou em serviços!', 14, 1)
			RETURN
		END;
	-------------------------------------------------------------------------
	-- check if employee is another employee supervisor
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM gestaoHotel.Empregado WHERE supervisor = @idPessoa;
	IF @COUNT != 0
		BEGIN
			UPDATE gestaoHotel.Empregado SET supervisor = NULL WHERE supervisor=@idPessoa;
		END;
	-------------------------------------------------------------------------
	BEGIN TRY
		DELETE FROM gestaoHotel.Empregado WHERE nrFuncionario=@idPessoa;
		DELETE FROM gestaoHotel.Funcionario WHERE id = @idPessoa;	
		DELETE FROM gestaoHotel.Pessoa WHERE idPessoa = @idPessoa;
	END TRY
	-------------------------------------------------------------------------
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do empregado!', 14, 1)
	END CATCH;


-- ##############################################################################################
-- #												GER												#
-- ##############################################################################################

--DROP PROCEDURE sp_AddGer;
GO
--Criação de um gerente
CREATE PROCEDURE sp_AddGer
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9),
	@salario			INT,
	@hotel				INT
	AS
		IF @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
			OR @salario is NULL OR @hotel is NULL 
		BEGIN
			PRINT 'O primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo, telefone, salário ou hotel não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the client already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pessoa JOIN gestaoHotel.Funcionario ON idPessoa=id WHERE Pnome=@Pnome AND Unome=@Unome AND email=@email
			AND dataNasc=@dataNasc AND endereco=@endereco AND codigoPostal=@codigoPostal AND sexo=@sexo AND nrTelefone=@nrTelefone;
		IF @COUNT != 0
			BEGIN
				RAISERROR ('O Funcionario que pretende adicionar já existe!', 14, 1)
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
			INSERT INTO GestaoHotel.Funcionario([id],[salario],[hotel]) 
				VALUES (@MaxPerson+1,@salario,@hotel)
			INSERT INTO GestaoHotel.Gerente([nrFuncionario]) 
				VALUES (@MaxPerson+1)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do gerente!', 14, 1)
		END CATCH;

-- DROP PROCEDURE sp_UpdateGer;
GO
--Atualização de um Gerente
CREATE PROCEDURE sp_UpdateGer
	@idPessoa			INT,
	@Pnome				VARCHAR(15),
	@Unome				VARCHAR(30),
	@email				VARCHAR(50),
	@dataNasc			DATE,
	@endereco			VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@sexo				CHAR(1),
	@nrTelefone			CHAR(9),
	@salario			INT,
	@hotel				INT
	AS
		IF @idPessoa is NULL OR @Pnome is NULL OR @Unome is NULL OR @email is NULL OR @dataNasc is NULL OR @endereco is NULL OR @codigoPostal is NULL OR @sexo is NULL OR @nrTelefone is NULL
			OR @salario is NULL OR @hotel is NULL 
		BEGIN
			PRINT 'O id, primeiro nome, último nome, email, data nascimento, endereco, codigo-postal, sexo, telefone, salário ou hotel não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the hotel manager exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pessoa WHERE idPessoa = @idPessoa;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Gerente em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE gestaoHotel.Pessoa SET idPessoa = @idPessoa, Pnome = @Pnome, Unome = @Unome,
				email = @email, dataNasc = @dataNasc, endereco = @endereco, codigoPostal = @codigoPostal, sexo=@sexo,
					nrTelefone=@nrTelefone WHERE idPessoa = @idPessoa;
			UPDATE gestaoHotel.Funcionario SET id = @idPessoa, salario=@salario, @hotel=hotel WHERE id = @idPessoa;
			UPDATE gestaoHotel.Gerente SET nrFuncionario=@idPessoa WHERE nrFuncionario = @idPessoa;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do gerente!', 14, 1)
		END CATCH;
				

-- DROP PROCEDURE sp_DeleteGer
GO
CREATE PROCEDURE sp_DeleteGer
	@idPessoa	INT
	AS 
	IF @idPessoa is NULL
	BEGIN
		PRINT 'O id da Pessoa não pode ser estar vazio!'
		RETURN
	END
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(gerente) FROM gestaoHotel.Hotel WHERE gerente=@idPessoa;
	IF @COUNT != 0
	BEGIN
		UPDATE gestaoHotel.Hotel SET gerente=null WHERE gerente=@idPessoa;
	END
	BEGIN TRY
		DELETE FROM gestaoHotel.Gerente WHERE nrFuncionario=@idPessoa;
		DELETE FROM gestaoHotel.Funcionario WHERE id = @idPessoa;	
		DELETE FROM gestaoHotel.Pessoa WHERE idPessoa = @idPessoa;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do gerente!', 14, 1)
	END CATCH
