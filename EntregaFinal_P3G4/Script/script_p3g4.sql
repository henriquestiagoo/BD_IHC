USE [p3g4]
GO
/****** Object:  Schema [gestaoHotel]    Script Date: 10/06/2016 18:09:48 ******/
CREATE SCHEMA [gestaoHotel]
GO
/****** Object:  StoredProcedure [dbo].[sp_AddCama]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de uma Cama
CREATE PROCEDURE [dbo].[sp_AddCama]
	@tipo			VARCHAR(10),
	@preco			MONEY
	AS
		IF @tipo is NULL
		BEGIN
			PRINT 'O tipo de Cama não pode estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the bed already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Cama WHERE tipo = @tipo;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O tipo de Cama que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Cama([tipo],[preco]) 
				VALUES (@tipo, @preco)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação da Cama!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddCliente]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Servico
CREATE PROCEDURE [dbo].[sp_AddCliente]
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
/****** Object:  StoredProcedure [dbo].[sp_AddEmp]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um empregado
CREATE PROCEDURE [dbo].[sp_AddEmp]
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
/****** Object:  StoredProcedure [dbo].[sp_AddEst]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Servico
CREATE PROCEDURE [dbo].[sp_AddEst]
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@lugar				VARCHAR(4)
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @lugar is NULL 
		BEGIN
			PRINT 'O custo, data, reserva, funcionario ou lugar não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check the max service id
		DECLARE @MaxServID INT
		SELECT @MaxServID = MAX(idServico) FROM gestaoHotel.Servico;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Servico([idServico],[custo],[data],[reserva],[funcionario]) 
				VALUES (@MaxServID+1,@custo,@data,@reserva,@funcionario)
			INSERT INTO GestaoHotel.Estacionamento([idServico],[lugar]) 
				VALUES (@MaxServID+1,@lugar)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do servico!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddGer]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um gerente
CREATE PROCEDURE [dbo].[sp_AddGer]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_AddHotel]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Hotel
CREATE PROCEDURE [dbo].[sp_AddHotel]
	@nome				VARCHAR(30),
	@classificacao		INT,
	@localizacao		VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@gerente			INT
	AS
		IF @nome is NULL OR @classificacao is NULL OR @localizacao is NULL OR @codigoPostal is NULL OR @gerente is NULL
		BEGIN
			PRINT 'O nome, classificação, localização ou gerente não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the hotel already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Hotel WHERE nome = @nome AND classificacao=@classificacao
			AND localizacao=@localizacao AND codigoPostal=@codigoPostal AND gerente=@gerente;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O Hotel que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		-- check the max id hotel
		DECLARE @MaxHotelID INT
		SELECT @MaxHotelID = Max(idHotel) FROM gestaoHotel.Hotel;
		BEGIN
			INSERT INTO GestaoHotel.Hotel([idHotel],[nome],[classificacao],[localizacao],[codigoPostal],[gerente]) 
				VALUES (@MaxHotelID+1,@nome,@classificacao,@localizacao,@codigoPostal,@gerente)
		END 
		---------
GO
/****** Object:  StoredProcedure [dbo].[sp_AddPag]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um pagamento
CREATE PROCEDURE [dbo].[sp_AddPag]
	@metodo				VARCHAR(20),
	@dataPagamento		DATE,
	@custoTotal			MONEY,
	@recepcionista		INT,
	@idReserva			INT
	AS
		IF @dataPagamento is NULL OR @metodo is NULL OR @custoTotal is NULL OR @recepcionista is NULL
		BEGIN
			PRINT 'A data, o método, o custo total ou o recepcionista não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		DECLARE @MAXPAG INT
		SELECT @MAXPAG = Max(idPagamento) FROM gestaoHotel.Pagamento;
		---------------------------------------------------------------------
		BEGIN 
			INSERT INTO GestaoHotel.Pagamento ([idPagamento],[metodo],[dataPagamento],[custoTotal],[recepcionista])
				VALUES (@MAXPAG+1,@metodo,@dataPagamento,@custoTotal,@recepcionista);
				--
				UPDATE GestaoHotel.Reserva SET pagamento=@MAXPAG+1 WHERE idReserva = @idReserva;
		END 
		-------------------
GO
/****** Object:  StoredProcedure [dbo].[sp_AddPensao]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de uma Pensao
CREATE PROCEDURE [dbo].[sp_AddPensao]
	@tipo				VARCHAR(3),
	@descricao			VARCHAR(50)
	AS
		IF @tipo is NULL 
		BEGIN
			PRINT 'O tipo de pensão não pode estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the pension type already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pensao WHERE tipo = @tipo;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O Tipo de Pensão que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Pensao([tipo],[descricao]) 
				VALUES (@tipo,@descricao)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação da Pensão!', 14, 1)
		END CATCH;


GO
/****** Object:  StoredProcedure [dbo].[sp_AddQuarto]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Quarto
CREATE PROCEDURE [dbo].[sp_AddQuarto]
	@idQuarto			INT,
	@fumador			INT,
	@estado				INT,
	@telefone			INT,
	@tipoQuarto			VARCHAR(10),
	@hotel				INT
	AS
		IF @idQuarto is NULL
		BEGIN
			PRINT 'O id do Quarto não pode estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the room already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Quarto WHERE idQuarto = @idQuarto;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O Quarto que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		-- check if a room already exists with the same phone number so the addition could not be completed
		DECLARE @COUNT2 INT
		SELECT @COUNT2 = COUNT(*) FROM gestaoHotel.Quarto WHERE telefone = @telefone;
		IF @COUNT2=1
			BEGIN
				RAISERROR ('Já existe um Quarto com este número de telefone!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Quarto([idQuarto],[fumador],[estado],[telefone],[tipoQuarto],[hotel]) 
				VALUES (@idQuarto, @fumador, @estado, @telefone, @tipoQuarto, @hotel)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do quarto!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddRec]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um rececionista
CREATE PROCEDURE [dbo].[sp_AddRec]
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
/****** Object:  StoredProcedure [dbo].[sp_AddReserva]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de uma Reserva
CREATE PROCEDURE [dbo].[sp_AddReserva]
	@numPessoas			INT,
	@tipoPensao			VARCHAR(3),
	@dataInicio			DATE,
	@dataFim			DATE,
	@quarto				INT,
	@recepcionista		INT,
	@cliente			INT,
	@tipo				VARCHAR(10),
	@quantidade			INT
	AS
		IF @numPessoas is NULL OR @tipoPensao is NULL OR @dataInicio is NULL OR @dataFim is NULL OR @cliente is NULL OR @quarto is NULL OR @recepcionista is NULL
		BEGIN
			PRINT 'O nº de pessoas, tipo de pensão, data de início, data de fim, quarto, recepcionista ou cliente não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the reservation already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Reserva WHERE dataInicio=@dataInicio AND quarto=@quarto;
		IF @COUNT != 0
			BEGIN
				RAISERROR ('Já existe uma reserva para esse quarto nessa data!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		-- check the max reservation id
		DECLARE @MaxRes INT
		SELECT @MaxRes  = MAX(idReserva) FROM gestaoHotel.Reserva;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT gestaoHotel.Reserva([idReserva],[numPessoas],[tipoPensao],[dataInicio],[dataFim],[quarto],[recepcionista],[cliente]) 
				VALUES (@MaxRes+1,@numPessoas,@tipoPensao,@dataInicio,@dataFim,@quarto,@recepcionista,@cliente);
			IF @tipo is NOT NULL AND @quantidade is NOT NULL
				BEGIN
					INSERT INTO gestaoHotel.Requere([tipo],[idReserva],[quantidade])
						VALUES(@tipo,@MaxRes+1,@quantidade);
				END;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação da reserva!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddRestBar]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Servico
CREATE PROCEDURE [dbo].[sp_AddRestBar]
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@tipo				VARCHAR(20),
	@descricao			VARCHAR(50)
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @tipo is NULL OR @descricao is NULL
		BEGIN
			PRINT 'O custo, data, reserva, funcionario, tipo ou descricao não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check the max service id
		DECLARE @MaxServID INT
		SELECT @MaxServID = MAX(idServico) FROM gestaoHotel.Servico;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Servico([idServico],[custo],[data],[reserva],[funcionario]) 
				VALUES (@MaxServID+1,@custo,@data,@reserva,@funcionario)
			INSERT INTO GestaoHotel.RestauranteBar([idServico],[tipo],[descricao]) 
				VALUES (@MaxServID+1,@tipo,@descricao)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do servico!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddRoomServ]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Servico
CREATE PROCEDURE [dbo].[sp_AddRoomServ]
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@idProduto			INT,
	@hora				TIME
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @idProduto is NULL OR @hora is NULL
		BEGIN
			PRINT 'O custo, data, reserva, funcionario, id Produto ou hora não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check the max service id
		DECLARE @MaxServID INT
		SELECT @MaxServID = MAX(idServico) FROM gestaoHotel.Servico;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Servico([idServico],[custo],[data],[reserva],[funcionario]) 
				VALUES (@MaxServID+1,@custo,@data,@reserva,@funcionario)
			INSERT INTO GestaoHotel.RoomService([idServico],[idProduto],[hora]) 
				VALUES (@MaxServID+1,@idProduto,@hora)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do servico!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddServExt]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Servico
CREATE PROCEDURE [dbo].[sp_AddServExt]
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@tipoServicoExt		VARCHAR(20),
	@descricao			VARCHAR(50)
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @tipoServicoExt is NULL 
		BEGIN
			PRINT 'O custo, data, reserva, funcionario ou tipo de servico externo não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check the max service id
		DECLARE @MaxServID INT
		SELECT @MaxServID = MAX(idServico) FROM gestaoHotel.Servico;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Servico([idServico],[custo],[data],[reserva],[funcionario]) 
				VALUES (@MaxServID+1,@custo,@data,@reserva,@funcionario)
			INSERT INTO GestaoHotel.ServicoExterno([idServico],[tipoServicoExt],[descricao]) 
				VALUES (@MaxServID+1,@tipoServicoExt,@descricao)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do servico!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_AddTemporada]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de uma temporada
CREATE PROCEDURE [dbo].[sp_AddTemporada]
	@idTemporada		INT,
	@dataComeco			DATE,
	@dataTermino		DATE,
	@razao				VARCHAR(30),
	@precoSimples		MONEY,
	@precoDouble		MONEY,
	@precoTwin			MONEY,
	@precoMiniSuite		MONEY,
	@precoSuite			MONEY
	AS
		IF @idTemporada	is NULL OR @dataComeco is NULL OR @dataTermino is NULL OR @razao is NULL OR @precoSimples is NULL OR
		@precoDouble is NULL OR @precoTwin	is NULL OR @precoMiniSuite is NULL OR @precoSuite is NULL 
		BEGIN
			PRINT 'O id da Temporada, a data de começo, a data de término, a razão, o preço do Quarto Simples, o preço 
			do Quarto Duplo, o preco do Quarto Twin, o preço do Quarto Mini-Suite ou 
			o preço do Quarto Suite não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the season already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Temporada WHERE idTemporada = @idTemporada;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O id da Temporada que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		-- check if the season already exists so the addition could not be completed
		DECLARE @COUNT2 INT
		SELECT @COUNT2 = COUNT(*) FROM gestaoHotel.Temporada WHERE dataComeco = @dataComeco AND dataTermino = @dataTermino;
		IF @COUNT2=1
			BEGIN
				RAISERROR ('A Temporada que pretende adicionar com essas datas já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Temporada([idTemporada],[dataComeco],[dataTermino],[razao],[precoSimples],[precoDouble],
			[precoTwin],[precoMiniSuite],[precoSuite]) 
				VALUES (@idTemporada,@dataComeco,@dataTermino,@razao,@precoSimples,@precoDouble,@precoTwin,@precoMiniSuite,@precoSuite)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação da Temporada!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddTipoQuarto]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um TipoQuarto
CREATE PROCEDURE [dbo].[sp_AddTipoQuarto]
	@tipo				VARCHAR(10),
	@descricao			VARCHAR(50),
	@numCamasExtraDisp	INT
	AS
		IF @tipo is NULL OR @numCamasExtraDisp is NULL 
		BEGIN
			PRINT 'O tipo e o número de camas extra disponíveis 
				para o tipo de quarto em questão não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the room type already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.TipoQuarto WHERE tipo = @tipo;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O Tipo de Quarto que pretende adicionar já existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.TipoQuarto([tipo],[descricao],[numCamasExtraDisp]) 
				VALUES (@tipo,@descricao,@numCamasExtraDisp)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do tipo de quarto!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_AddVideo]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de um Servico
CREATE PROCEDURE [dbo].[sp_AddVideo]
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@idFilme			INT,
	@hora				TIME
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @idFilme is NULL OR @hora is NULL
		BEGIN
			PRINT 'O custo, data, reserva, funcionario, id filme ou hora não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check the max service id
		DECLARE @MaxServID INT
		SELECT @MaxServID = MAX(idServico) FROM gestaoHotel.Servico;
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Servico([idServico],[custo],[data],[reserva],[funcionario]) 
				VALUES (@MaxServID+1,@custo,@data,@reserva,@funcionario)
			INSERT INTO GestaoHotel.Video([idServico],[idFilme],[hora]) 
				VALUES (@MaxServID+1,@idFilme,@hora)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a criação do servico!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCama]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteCama]
	@tipo			VARCHAR(10)
	AS 
	IF @tipo is NULL 
	BEGIN
		PRINT 'O tipo de Cama não pode ser estar vazio!'
		RETURN
	END
	DECLARE @COUNT int
	-- check if the Bed type has dependencies
	SELECT @COUNT = COUNT(tipo) FROM gestaoHotel.Requere WHERE tipo = @tipo
	IF @COUNT = 0
		BEGIN TRY
			DELETE FROM gestaoHotel.Cama WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a remoção do Hotel!', 14, 1)
		END CATCH
	ELSE
		BEGIN
			RAISERROR ('A Cama em questão tem Reservas associadas a este tipo de Cama logo não pode ser eliminada!', 14, 1)
			RETURN
		END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCliente]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteCliente]
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


GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteEmp]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteEmp]
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

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteEst]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteEst]
	@idServico	INT
	AS 
	IF @idServico is NULL
	BEGIN
		PRINT 'O id do Servico não pode ser estar vazio!'
		RETURN
	END
	BEGIN TRY
		DELETE FROM gestaoHotel.Estacionamento WHERE idServico = @idServico;	
		DELETE FROM gestaoHotel.Servico WHERE idServico = @idServico;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do servico!', 14, 1)
	END CATCH


GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteGer]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteGer]
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

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteHotel]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteHotel]
	@idHotel	INT
	AS 
	IF @idHotel is NULL
	BEGIN
		PRINT 'O id do Hotel não pode ser estar vazio!'
		RETURN
	END
	DECLARE @COUNT int
	-- check if the Hotel has employees
	SELECT @COUNT = COUNT(hotel) FROM gestaoHotel.Funcionario WHERE hotel = @idHotel
	IF @COUNT = 0
		BEGIN TRY
			DELETE FROM gestaoHotel.Hotel WHERE idHotel = @idHotel;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a remoção do Hotel!', 14, 1)
		END CATCH
	ELSE
		BEGIN
			RAISERROR ('O Hotel em questão tem Funcionários logo não pode ser eliminado!', 14, 1)
			RETURN
		END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeletePensao]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeletePensao]
	@tipo				VARCHAR(3)
	AS 
	IF @tipo is NULL 
	BEGIN
		PRINT 'A pensão não pode ser estar vazia!'
		RETURN
	END
	DECLARE @COUNT INT
	-- check if the pension Type has dependencies
	SELECT @COUNT = COUNT(tipoPensao) FROM gestaoHotel.Reserva WHERE tipoPensao = @tipo
	IF @COUNT = 0
		BEGIN TRY
			DELETE FROM gestaoHotel.Pensao WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a remoção da Pensão!', 14, 1)
		END CATCH
	ELSE
		BEGIN
			RAISERROR ('O tipo de Pensão em questão faz parte de reservas atuais logo não pode ser eliminada!', 14, 1)
			RETURN
		END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteQuarto]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteQuarto]
	@idQuarto				INT
	AS 
	IF @idQuarto is NULL 
	BEGIN
		PRINT 'O quarto não pode ser estar vazio!'
		RETURN
	END
	---------------------------------------------------------------------
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM gestaoHotel.Reserva WHERE quarto=@idQuarto;
	IF @COUNT != 0
	BEGIN
		RAISERROR ('O quarto está associado a reservas logo não pode ser eliminado!', 14, 1)
		RETURN;
	END;
	---------------------------------------------------------------------
	BEGIN TRY
		DELETE FROM gestaoHotel.Quarto WHERE idQuarto = @idQuarto;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do Quarto!', 14, 1)
	END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteRec]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteRec]
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


GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteReserva]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC sp_DeleteReserva;
CREATE PROCEDURE [dbo].[sp_DeleteReserva] 
@idReserva INT   
AS
IF (SELECT dataInicio FROM gestaoHotel.Reserva WHERE idReserva = @idReserva) >= Convert(date, getdate())
	BEGIN 
		DELETE FROM gestaoHotel.Requere WHERE idReserva=@idReserva;
		DELETE FROM gestaoHotel.Reserva WHERE idReserva=@idReserva;
	END;
ELSE 
	RAISERROR('Impossivel remover reserva por já ter passado data',14,1);

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteRestBar]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteRestBar]
	@idServico	INT
	AS 
	IF @idServico is NULL
	BEGIN
		PRINT 'O id do Servico não pode ser estar vazio!'
		RETURN
	END
	BEGIN TRY
		DELETE FROM gestaoHotel.RestauranteBar WHERE idServico = @idServico;	
		DELETE FROM gestaoHotel.Servico WHERE idServico = @idServico;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do servico!', 14, 1)
	END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteRoomServ]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteRoomServ]
	@idServico	INT
	AS 
	IF @idServico is NULL
	BEGIN
		PRINT 'O id do Servico não pode ser estar vazio!'
		RETURN
	END
	BEGIN TRY
		DELETE FROM gestaoHotel.RoomService WHERE idServico = @idServico;	
		DELETE FROM gestaoHotel.Servico WHERE idServico = @idServico;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do servico!', 14, 1)
	END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteServExt]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteServExt]
	@idServico	INT
	AS 
	IF @idServico is NULL
	BEGIN
		PRINT 'O id do Servico não pode ser estar vazio!'
		RETURN
	END
	BEGIN TRY
		DELETE FROM gestaoHotel.ServicoExterno WHERE idServico = @idServico;	
		DELETE FROM gestaoHotel.Servico WHERE idServico = @idServico;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do servico!', 14, 1)
	END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteTemporada]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteTemporada]
	@idTemporada	INT
	AS 
	IF @idTemporada is NULL
	BEGIN
		PRINT 'O id da Temporada não pode ser estar vazio!'
		RETURN
	END
	DECLARE @COUNT INT
	-- check if the season has reservations
	SELECT @COUNT = COUNT(idTemporada) FROM gestaoHotel.Depende WHERE idTemporada = @idTemporada
	IF @COUNT = 0
		BEGIN TRY
			DELETE FROM gestaoHotel.Temporada WHERE idTemporada = @idTemporada;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a remoção da Temporada!', 14, 1)
		END CATCH
	ELSE
		BEGIN
			RAISERROR ('A Temporada em questão tem reservas nestas datas logo não pode ser eliminada!', 14, 1)
			RETURN
		END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteTipoQuarto]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteTipoQuarto]
	@tipo				VARCHAR(10)
	AS 
	IF @tipo is NULL 
	BEGIN
		PRINT 'O tipo de quarto não pode ser estar vazio!'
		RETURN
	END
	DECLARE @COUNT int
	-- check if the Room Type has dependencies
	SELECT @COUNT = COUNT(tipoQuarto) FROM gestaoHotel.Quarto WHERE tipoQuarto = @tipo
	IF @COUNT = 0
		BEGIN TRY
			DELETE FROM gestaoHotel.TipoQuarto WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a remoção do Hotel!', 14, 1)
		END CATCH
	ELSE
		BEGIN
			RAISERROR ('O Tipo de Quarto em questão tem Quartos deste tipo logo não pode ser eliminado!', 14, 1)
			RETURN
		END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteVideo]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteVideo]
	@idServico	INT
	AS 
	IF @idServico is NULL
	BEGIN
		PRINT 'O id do Servico não pode ser estar vazio!'
		RETURN
	END
	BEGIN TRY
		DELETE FROM gestaoHotel.Video WHERE idServico = @idServico;	
		DELETE FROM gestaoHotel.Servico WHERE idServico = @idServico;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remoção do servico!', 14, 1)
	END CATCH

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCama]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de uma Cama
CREATE PROCEDURE [dbo].[sp_UpdateCama]
	@tipo				VARCHAR(10),
	@preco				MONEY
	AS 
		IF @tipo is NULL
		BEGIN
			PRINT 'O tipo de Cama não pode estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the bed exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Cama WHERE tipo = @tipo;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('A Cama em questão não existe!!', 14, 1)
			RETURN
		END
		BEGIN TRY
			UPDATE  gestaoHotel.Cama SET tipo = @tipo, preco = @preco
				 WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização da cama!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCliente]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_UpdateCliente;
--Atualização de um Cliente
CREATE PROCEDURE [dbo].[sp_UpdateCliente]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateEmp]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_UpdateEmp;
--Update de um rececionista
CREATE PROCEDURE [dbo].[sp_UpdateEmp]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateEst]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_UpdateEst;
--Atualização de um Servico RestBar
CREATE PROCEDURE [dbo].[sp_UpdateEst]
	@idServico			INT,
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@lugar				VARCHAR(4)
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @lugar is NULL 
		BEGIN
			PRINT 'O custo, data, reserva, funcionario ou lugar não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the roomserv serv already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Servico WHERE idServico = @idServico;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Servico em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Servico SET idServico = @idServico, custo = @custo, @data = @data,
				reserva = @reserva, funcionario = @funcionario WHERE idServico = @idServico;
			UPDATE  gestaoHotel.Estacionamento SET lugar = @lugar 
				WHERE idServico = @idServico;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do servico!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateGer]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de um Gerente
CREATE PROCEDURE [dbo].[sp_UpdateGer]
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
				
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateHotel]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de um Hotel
CREATE PROCEDURE [dbo].[sp_UpdateHotel]
	@idHotel			INT,
	@nome				VARCHAR(30),
	@classificacao		INT,
	@localizacao		VARCHAR(50),
	@codigoPostal		VARCHAR(10),
	@gerente			INT
	AS 
		IF @nome is NULL OR @classificacao is NULL OR @localizacao is NULL OR @codigoPostal is NULL OR @gerente is NULL
		BEGIN
			PRINT 'O nome, classificação, localização ou gerente não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the hotel already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Hotel WHERE idHotel = @idHotel;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Hotel em questão não existe!', 14, 1)
			RETURN
		END
		BEGIN 
			UPDATE  gestaoHotel.Hotel SET nome = @nome, classificacao = @classificacao, localizacao = @localizacao,
				codigoPostal = @codigoPostal, gerente = @gerente WHERE idHotel = @idHotel;
		END 
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdatePag]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualizacao de um pagamento
CREATE PROCEDURE [dbo].[sp_UpdatePag]
	@idPagamento		INT,
	@metodo				VARCHAR(20),
	@dataPagamento		DATE,
	@custoTotal			MONEY,
	@recepcionista		INT
	AS
		IF @idPagamento	is NULL OR @dataPagamento is NULL OR @metodo is NULL OR @custoTotal is NULL OR
		@recepcionista is NULL
		BEGIN
			PRINT 'O id do Pagamento, a data, o método, o custo total ou 
			o recepcionista não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the payment already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pagamento WHERE idPagamento = @idPagamento;
		IF @COUNT=0
			BEGIN
				RAISERROR ('O pagamento em questão não existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE GestaoHotel.Pagamento SET idPagamento=@idPagamento, metodo=@metodo, dataPagamento=@dataPagamento,
			custoTotal=@custoTotal, recepcionista=@recepcionista WHERE idPagamento = @idPagamento;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do Pagamento!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdatePensao]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de uma Pensao
CREATE PROCEDURE [dbo].[sp_UpdatePensao]
	@tipo				VARCHAR(3),
	@descricao			VARCHAR(50)
	AS 
		IF @tipo is NULL 
		BEGIN
			PRINT 'O tipo de pensão não pode estar por preencher!!'
			RETURN
		END
		-- check if the pension exists
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Pensao WHERE tipo = @tipo;
		IF @COUNT=0
			BEGIN
				RAISERROR ('O Tipo de Pensão em questão não existe!', 14, 1)
				RETURN
			END
		BEGIN TRY
			UPDATE  gestaoHotel.Pensao SET tipo = @tipo,
				descricao = @descricao WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização da Pensão!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateQuarto]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de um Quarto
CREATE PROCEDURE [dbo].[sp_UpdateQuarto]
	@idQuarto			INT,
	@fumador			INT,
	@estado				INT,
	@telefone			INT,
	@tipoQuarto			VARCHAR(10),
	@hotel				INT
	AS 
		IF @idQuarto is NULL
		BEGIN
			PRINT 'O id do Quarto não pode estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the room exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Quarto WHERE idQuarto = @idQuarto;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Quarto em questão não existe!!', 14, 1)
			RETURN
		END
		BEGIN TRY
			UPDATE  gestaoHotel.Quarto SET fumador = @fumador,
			 estado = @estado, telefone = @telefone, tipoQuarto = @tipoQuarto, hotel = @hotel
				 WHERE idQuarto = @idQuarto;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do quarto!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateRec]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_UpdateRec;
--Update de um recepcionista
CREATE PROCEDURE [dbo].[sp_UpdateRec]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateReserva]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Criação de uma Reserva
CREATE PROCEDURE [dbo].[sp_UpdateReserva]
	@idReserva			INT,
	@numPessoas			INT,
	@tipoPensao			VARCHAR(3),
	@dataInicio			DATE,
	@dataFim			DATE,
	@quarto				INT,
	@recepcionista		INT,
	@cliente			INT,
	@tipo				VARCHAR(10),
	@quantidade			INT
	AS
		IF @idReserva is NULL OR @numPessoas is NULL OR @tipoPensao is NULL OR @dataInicio is NULL OR @dataFim is NULL OR @cliente is NULL OR @quarto is NULL OR @recepcionista is NULL
		BEGIN
			PRINT 'O id da reserva, o nº de pessoas, tipo de pensão, data de início, data de fim, quarto, recepcionista ou cliente não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		DECLARE @COUNT INT
		-- check if the reservation exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Reserva WHERE idReserva = @idReserva;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('A reserva em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE gestaoHotel.Reserva SET idReserva=@idReserva, numPessoas=@numPessoas, tipoPensao=@tipoPensao,
				dataInicio=@dataInicio, dataFim=@dataFim, quarto=@quarto, recepcionista=@recepcionista, cliente=@cliente
					WHERE idReserva=@idReserva;
			---------------------------------------------------------------------
			-- check if exists a extra bed on this reservation
			DECLARE @COUNT2 INT
			SELECT @COUNT2 = COUNT(tipo) FROM gestaoHotel.Requere RIGHT OUTER JOIN gestaoHotel.Reserva ON Requere.idReserva=Reserva.idReserva
					WHERE Reserva.idReserva=@idReserva;	
			IF @COUNT2 != 0
					UPDATE gestaoHotel.Requere SET tipo=@tipo, idReserva=@idReserva, quantidade=@quantidade
						WHERE idReserva=@idReserva;
			-- if not, need to create bed reservation
			ELSE
				BEGIN
					INSERT INTO gestaoHotel.Requere ([tipo],[idReserva],[quantidade])
						VALUES (@tipo,@idReserva,@quantidade);
				END;			
			---------------------------------------------------------------------				
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização da reserva!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateRestBar]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de um Servico RestBar
CREATE PROCEDURE [dbo].[sp_UpdateRestBar]
	@idServico			INT,
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@tipo				VARCHAR(20),
	@descricao			VARCHAR(50)
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @tipo is NULL OR @descricao is NULL
		BEGIN
			PRINT 'O custo, data, reserva, funcionario, tipo ou descricao não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the restbar serv already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Servico WHERE idServico = @idServico;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Servico em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Servico SET idServico = @idServico, custo = @custo, @data = @data,
				reserva = @reserva, funcionario = @funcionario WHERE idServico = @idServico;
			UPDATE  gestaoHotel.RestauranteBar SET idServico = @idServico, tipo = @tipo, descricao = @descricao 
				WHERE idServico = @idServico;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do servico!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateRoomServ]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de um Servico RoomServ
CREATE PROCEDURE [dbo].[sp_UpdateRoomServ]
	@idServico			INT,
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@idProduto			INT,
	@hora				TIME
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @idProduto is NULL OR @hora is NULL
		BEGIN
			PRINT 'O custo, data, reserva, funcionario, id Produto ou hora não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the roomserv serv already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Servico WHERE idServico = @idServico;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Servico em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Servico SET idServico = @idServico, custo = @custo, @data = @data,
				reserva = @reserva, funcionario = @funcionario WHERE idServico = @idServico;
			UPDATE  gestaoHotel.RoomService SET idProduto = @idProduto, hora = @hora 
				WHERE idServico = @idServico;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do servico!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateServExt]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_UpdateServExt;
--Atualização de um Servico ServExt
CREATE PROCEDURE [dbo].[sp_UpdateServExt]
	@idServico			INT,
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@tipoServicoExt		VARCHAR(20),
	@descricao			VARCHAR(50)
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @tipoServicoExt is NULL 
		BEGIN
			PRINT 'O custo, data, reserva, funcionario ou tipo de servico externo não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the roomserv serv already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Servico WHERE idServico = @idServico;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Servico em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Servico SET idServico = @idServico, custo = @custo, @data = @data,
				reserva = @reserva, funcionario = @funcionario WHERE idServico = @idServico;
			UPDATE  gestaoHotel.ServicoExterno SET tipoServicoExt = @tipoServicoExt, descricao = @descricao
				WHERE idServico = @idServico;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do servico!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateTemporada]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualizacao de uma temporada
CREATE PROCEDURE [dbo].[sp_UpdateTemporada]
	@idTemporada		INT,
	@dataComeco			DATE,
	@dataTermino		DATE,
	@razao				VARCHAR(30),
	@precoSimples		MONEY,
	@precoDouble		MONEY,
	@precoTwin			MONEY,
	@precoMiniSuite		MONEY,
	@precoSuite			MONEY
	AS
		IF @idTemporada	is NULL OR @dataComeco is NULL OR @dataTermino is NULL OR @razao is NULL OR @precoSimples is NULL OR
		@precoDouble is NULL OR @precoTwin	is NULL OR @precoMiniSuite is NULL OR @precoSuite is NULL 
		BEGIN
			PRINT 'O id da Temporada, a data de começo, a data de término, a razão, o preço do Quarto Simples, o preço 
			do Quarto Duplo, o preco do Quarto Twin, o preço do Quarto Mini-Suite ou 
			o preço do Quarto Suite não podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the season already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Temporada WHERE idTemporada = @idTemporada;
		IF @COUNT=0
			BEGIN
				RAISERROR ('A Temporada em questão não existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE GestaoHotel.Temporada SET idTemporada=@idTemporada, dataComeco=@dataComeco, dataTermino=@dataTermino,
			razao=@razao, precoSimples=@precoSimples, precoDouble=@precoDouble, precoTwin=@precoTwin,
			precoMiniSuite=@precoMiniSuite, precoSuite=@precoSuite WHERE idTemporada = @idTemporada;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização da Temporada!', 14, 1)
		END CATCH;

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateTipoQuarto]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Atualização de um TipoQuarto
CREATE PROCEDURE [dbo].[sp_UpdateTipoQuarto]
	@tipo				VARCHAR(10),
	@descricao			VARCHAR(50),
	@numCamasExtraDisp	INT
	AS 
		IF @tipo is NULL OR @numCamasExtraDisp is NULL 
		BEGIN
			PRINT 'O tipo e o número de camas extra disponíveis 
				para o tipo de quarto em questão não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the room type exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.TipoQuarto WHERE tipo = @tipo;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Tipo de Quarto em questão não existe!', 14, 1)
			RETURN
		END
		BEGIN TRY
			UPDATE  gestaoHotel.TipoQuarto SET tipo = @tipo,
				descricao = @descricao, numCamasExtraDisp = @numCamasExtraDisp
				 WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do tipo de quarto!', 14, 1)
		END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateVideo]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE sp_UpdateVideo;
--Atualização de um Servico RestBar
CREATE PROCEDURE [dbo].[sp_UpdateVideo]
	@idServico			INT,
	@custo				MONEY,
	@data				DATE,
	@reserva			INT,
	@funcionario		INT,
	@idFilme			INT,
	@hora				TIME
	AS
		IF @custo is NULL OR @data is NULL OR @reserva is NULL OR @funcionario is NULL OR @idFilme is NULL OR @hora is NULL
		BEGIN
			PRINT 'O custo, data, reserva, funcionario, id filme ou hora não podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the roomserv serv already exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Servico WHERE idServico = @idServico;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Servico em questão não existe!', 14, 1)
			RETURN
		END
		---------------------------------------------------------------------
		BEGIN TRY
			UPDATE  gestaoHotel.Servico SET idServico = @idServico, custo = @custo, @data = @data,
				reserva = @reserva, funcionario = @funcionario WHERE idServico = @idServico;
			UPDATE  gestaoHotel.Video SET idFilme = @idFilme, hora = @hora
				WHERE idServico = @idServico;
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualização do servico!', 14, 1)
		END CATCH;

GO
/****** Object:  UserDefinedFunction [gestaoHotel].[HotelComGerenteMaisBemPago]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [gestaoHotel].[HotelComGerenteMaisBemPago]() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' -> '+CONVERT(varchar(10),salario)+'€' FROM (gestaoHotel.Gerente JOIN gestaoHotel.Funcionario ON nrFuncionario=id )JOIN gestaoHotel.Hotel ON gerente=nrFuncionario GROUP BY salario,idHotel,nome,localizacao ORDER BY salario DESC)
END

GO
/****** Object:  UserDefinedFunction [gestaoHotel].[HotelComMaisClientes]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION gestaoHotel.HotelComMaisClientes;
CREATE FUNCTION [gestaoHotel].[HotelComMaisClientes]() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' -> '+CONVERT(varchar(10),COUNT(Cliente.id))+' Clientes' FROM (gestaoHotel.Quarto JOIN (gestaoHotel.Reserva JOIN gestaoHotel.Cliente ON id=cliente) ON quarto=idQuarto) JOIN gestaoHotel.Hotel ON hotel=idHotel GROUP BY idHotel,nome,localizacao ORDER BY COUNT(Cliente.id) DESC)
END

GO
/****** Object:  UserDefinedFunction [gestaoHotel].[HotelComMaisFunc]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [gestaoHotel].[HotelComMaisFunc]() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' -> '+CONVERT(varchar(10),COUNT(id))+' Funcionarios' FROM gestaoHotel.Funcionario JOIN gestaoHotel.Hotel ON hotel=idHotel GROUP BY idHotel,nome,localizacao ORDER BY COUNT(id) DESC)
END

GO
/****** Object:  UserDefinedFunction [gestaoHotel].[HotelComMaisReservas]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION gestaoHotel.HotelComMaisReservas;
CREATE FUNCTION [gestaoHotel].[HotelComMaisReservas]() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' - > '+CONVERT(varchar(10),COUNT(idReserva))+' Reservas' FROM (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON quarto=idQuarto) JOIN gestaoHotel.Hotel ON hotel=idHotel GROUP BY idHotel,nome,localizacao ORDER BY COUNT(idReserva) DESC)
END

GO
/****** Object:  Table [gestaoHotel].[Cama]    Script Date: 10/06/2016 18:09:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Cama](
	[tipo] [varchar](10) NOT NULL,
	[preco] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Cliente]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Cliente](
	[id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Depende]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Depende](
	[idTemporada] [int] NOT NULL,
	[idReserva] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idTemporada] ASC,
	[idReserva] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Empregado]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Empregado](
	[nrFuncionario] [int] NOT NULL,
	[supervisor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[nrFuncionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Estacionamento]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Estacionamento](
	[idServico] [int] NOT NULL,
	[lugar] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[idServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Funcionario]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Funcionario](
	[id] [int] NOT NULL,
	[salario] [int] NOT NULL,
	[hotel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Gerente]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Gerente](
	[nrFuncionario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nrFuncionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Hotel]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Hotel](
	[idHotel] [int] NOT NULL,
	[nome] [varchar](30) NOT NULL,
	[classificacao] [int] NOT NULL,
	[localizacao] [varchar](50) NOT NULL,
	[codigoPostal] [varchar](10) NULL,
	[gerente] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idHotel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Pagamento]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Pagamento](
	[idPagamento] [int] NOT NULL,
	[metodo] [varchar](20) NULL,
	[dataPagamento] [date] NOT NULL,
	[custoTotal] [money] NOT NULL,
	[recepcionista] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idPagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Pensao]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Pensao](
	[tipo] [varchar](3) NOT NULL,
	[descricao] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Pessoa]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Pessoa](
	[idPessoa] [int] NOT NULL,
	[email] [varchar](50) NOT NULL,
	[Pnome] [varchar](15) NOT NULL,
	[Unome] [varchar](30) NOT NULL,
	[dataNasc] [date] NULL,
	[endereco] [varchar](50) NULL,
	[sexo] [char](1) NULL,
	[nrTelefone] [char](9) NULL,
	[codigoPostal] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[idPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Quarto]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Quarto](
	[idQuarto] [int] NOT NULL,
	[fumador] [binary](1) NOT NULL,
	[estado] [binary](1) NOT NULL,
	[telefone] [int] NOT NULL,
	[tipoQuarto] [varchar](10) NOT NULL,
	[hotel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idQuarto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Recepcionista]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Recepcionista](
	[nrFuncionario] [int] NOT NULL,
	[supervisor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[nrFuncionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Requere]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Requere](
	[tipo] [varchar](10) NOT NULL,
	[idReserva] [int] NOT NULL,
	[quantidade] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tipo] ASC,
	[idReserva] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Reserva]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Reserva](
	[idReserva] [int] NOT NULL,
	[numPessoas] [int] NOT NULL,
	[tipoPensao] [varchar](3) NULL,
	[dataInicio] [date] NOT NULL,
	[dataFim] [date] NOT NULL,
	[pagamento] [int] NULL,
	[quarto] [int] NOT NULL,
	[recepcionista] [int] NOT NULL,
	[cliente] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idReserva] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[RestauranteBar]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[RestauranteBar](
	[idServico] [int] NOT NULL,
	[tipo] [varchar](20) NOT NULL,
	[descricao] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[RoomService]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[RoomService](
	[idServico] [int] NOT NULL,
	[idProduto] [int] NOT NULL,
	[hora] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[idServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[Servico]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Servico](
	[idServico] [int] NOT NULL,
	[custo] [money] NOT NULL,
	[data] [date] NOT NULL,
	[reserva] [int] NOT NULL,
	[funcionario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [gestaoHotel].[ServicoExterno]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[ServicoExterno](
	[idServico] [int] NOT NULL,
	[tipoServicoExt] [varchar](20) NOT NULL,
	[descricao] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Temporada]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[Temporada](
	[idTemporada] [int] NOT NULL,
	[dataComeco] [date] NOT NULL,
	[dataTermino] [date] NOT NULL,
	[razao] [varchar](30) NULL,
	[precoSimples] [money] NOT NULL,
	[precoDouble] [money] NOT NULL,
	[precoTwin] [money] NOT NULL,
	[precoMiniSuite] [money] NOT NULL,
	[precoSuite] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idTemporada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[TipoQuarto]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [gestaoHotel].[TipoQuarto](
	[tipo] [varchar](10) NOT NULL,
	[descricao] [varchar](50) NULL,
	[numCamasExtraDisp] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [gestaoHotel].[Video]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [gestaoHotel].[Video](
	[idServico] [int] NOT NULL,
	[idFilme] [int] NOT NULL,
	[hora] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[idServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[udf_Cama_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Cama_DataGrid;
CREATE FUNCTION [dbo].[udf_Cama_DataGrid](@tipo VARCHAR(10)=null)
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Cliente_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Cliente_DataGrid;
CREATE FUNCTION [dbo].[udf_Cliente_DataGrid](@id INT=null)
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Emp_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Emp_DataGrid;
CREATE FUNCTION [dbo].[udf_Emp_DataGrid](@id INT=null)
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Est_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Est_DataGrid;
CREATE FUNCTION [dbo].[udf_Est_DataGrid](@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, lugar VARCHAR(4))
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, lugar 
				FROM gestaoHotel.Servico JOIN gestaoHotel.Estacionamento ON Servico.idServico=Estacionamento.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, lugar  
				FROM gestaoHotel.Servico JOIN gestaoHotel.Estacionamento ON Servico.idServico=Estacionamento.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Func_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Func_DataGrid;
CREATE FUNCTION [dbo].[udf_Func_DataGrid](@id INT=null)
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

GO
/****** Object:  UserDefinedFunction [dbo].[udf_Ger_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Ger_DataGrid;
CREATE FUNCTION [dbo].[udf_Ger_DataGrid](@id INT=null)
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Hotel_Datagrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Hotel_DataGrid;
CREATE FUNCTION [dbo].[udf_Hotel_Datagrid](@idHotel INT=null)
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
/****** Object:  UserDefinedFunction [dbo].[udf_Hotel_func]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP FUNCTION udf_Hotel_func;
CREATE FUNCTION [dbo].[udf_Hotel_func](@id_func INT=NULL) 
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

GO
/****** Object:  UserDefinedFunction [dbo].[udf_Hotel_Stats_Clientes_Hotel]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP FUNCTION udf_Hotel_Stats_Clientes_Hotel;
CREATE FUNCTION [dbo].[udf_Hotel_Stats_Clientes_Hotel]()
RETURNS @table TABLE (idHotel INT, nome VARCHAR(30), localizacao VARCHAR(50), classificacao INT, nr_clientes INT)
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT idHotel, Hotel.nome, Hotel.localizacao, Hotel.classificacao, COUNT(idHotel) AS nr_clientes
			FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
				GROUP BY idHotel, Hotel.nome,Hotel.localizacao,Hotel.classificacao;
	END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Hotel_Stats_Gerentes_Hotel]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP FUNCTION udf_Hotel_Stats_Gerentes_Hotel;
CREATE FUNCTION [dbo].[udf_Hotel_Stats_Gerentes_Hotel]()
RETURNS @table TABLE (idHotel INT, nome VARCHAR(30), localizacao VARCHAR(50), nome_Gerente VARCHAR(50), id INT, Salario INT)
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT idHotel, Hotel.nome, Hotel.localizacao, Pnome+' '+Unome AS nome_Gerente, idPessoa AS id, Salario
			FROM gestaoHotel.Pessoa JOIN gestaoHotel.Hotel ON idPessoa=gerente JOIN gestaoHotel.Funcionario ON idPessoa=id
				ORDER BY idHotel, Hotel.nome, Hotel.localizacao;
	END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Hotel_Stats_hotel_mais_clientes]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP FUNCTION udf_Hotel_Stats_hotel_mais_clientes;
CREATE FUNCTION [dbo].[udf_Hotel_Stats_hotel_mais_clientes]()
RETURNS @table TABLE (hotel VARCHAR(100))
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT CONVERT(varchar(10), idHotel)+' - '+Hotel.nome+', '+Hotel.localizacao AS hotel FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
GROUP BY idHotel, Hotel.nome,Hotel.localizacao,Hotel.classificacao
HAVING COUNT(idHotel)=(SELECT MAX(nr_clientes) AS maxim FROM (SELECT idHotel, Hotel.nome, Hotel.localizacao, Hotel.classificacao, COUNT(idHotel) AS nr_clientes
FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
GROUP BY idHotel, Hotel.nome,Hotel.localizacao,Hotel.classificacao) AS T2);
	END;
	RETURN;
END;


GO
/****** Object:  UserDefinedFunction [dbo].[udf_Hotel_Stats_Nr_hoteis]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP FUNCTION udf_Hotel_Stats_Nr_hoteis;
CREATE FUNCTION [dbo].[udf_Hotel_Stats_Nr_hoteis]()
RETURNS @table TABLE (numero INT)
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT COUNT(DISTINCT idHotel) AS numero FROM gestaoHotel.Hotel;
	END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Pagamento_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Pagamento_DataGrid;
CREATE FUNCTION [dbo].[udf_Pagamento_DataGrid](@idPagamento INT=null)
RETURNS @table TABLE (idPagamento INT, metodo VARCHAR(20), dataPagamento DATE, 
	custoTotal MONEY,recepcionista INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idPagamento is NULL)
		BEGIN
			INSERT @table SELECT idPagamento, metodo, dataPagamento, 
	custoTotal, recepcionista FROM gestaoHotel.Pagamento
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idPagamento, metodo, dataPagamento, 
	custoTotal, recepcionista FROM gestaoHotel.Pagamento
		WHERE gestaoHotel.Pagamento.idPagamento = @idPagamento
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Pensao_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Pensao_DataGrid;
CREATE FUNCTION [dbo].[udf_Pensao_DataGrid](@tipo VARCHAR(3)=null)
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

GO
/****** Object:  UserDefinedFunction [dbo].[udf_Quarto_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Quarto_DataGrid;
CREATE FUNCTION [dbo].[udf_Quarto_DataGrid](@idQuarto INT=null)
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Rec_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Rec_DataGrid;
CREATE FUNCTION [dbo].[udf_Rec_DataGrid](@id INT=null)
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

GO
/****** Object:  UserDefinedFunction [dbo].[udf_Reserva_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Reserva_DataGrid;
CREATE FUNCTION [dbo].[udf_Reserva_DataGrid](@idReserva INT=null)
RETURNS @table TABLE (idReserva INT, numPessoas INT, tipoPensao VARCHAR(3), dataInicio DATE, 
	dataFim DATE, pagamento INT, quarto INT, recepcionista INT, cliente INT, tipo VARCHAR(10),quantidade INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idReserva is NULL)
		BEGIN
			INSERT @table SELECT Reserva.idReserva, numPessoas, tipoPensao, dataInicio, 
	dataFim, pagamento, quarto, recepcionista, cliente, tipo, quantidade  
	FROM gestaoHotel.Requere RIGHT OUTER JOIN gestaoHotel.Reserva ON Requere.idReserva=Reserva.idReserva;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Reserva.idReserva, numPessoas, tipoPensao, dataInicio, 
	dataFim, pagamento, quarto, recepcionista, cliente, tipo, quantidade  
	FROM gestaoHotel.Requere RIGHT OUTER JOIN gestaoHotel.Reserva ON Requere.idReserva=Reserva.idReserva
		WHERE gestaoHotel.Reserva.idReserva = @idReserva
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_RestBar_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_RestBar_DataGrid;
CREATE FUNCTION [dbo].[udf_RestBar_DataGrid](@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, tipo VARCHAR(20),
	descricao VARCHAR(50))
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipo, descricao 
				FROM gestaoHotel.Servico JOIN gestaoHotel.RestauranteBar ON Servico.idServico=RestauranteBar.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipo, descricao 
				FROM gestaoHotel.Servico JOIN gestaoHotel.RestauranteBar ON Servico.idServico=RestauranteBar.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;


GO
/****** Object:  UserDefinedFunction [dbo].[udf_RoomServ_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_RoomServ_DataGrid;
CREATE FUNCTION [dbo].[udf_RoomServ_DataGrid](@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, idProduto INT,
	hora TIME)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idProduto, hora 
				FROM gestaoHotel.Servico JOIN gestaoHotel.RoomService ON Servico.idServico=RoomService.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idProduto, hora  
				FROM gestaoHotel.Servico JOIN gestaoHotel.RoomService ON Servico.idServico=RoomService.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Serv_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Serv_DataGrid;
CREATE FUNCTION [dbo].[udf_Serv_DataGrid](@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT idServico, custo, data, reserva, funcionario FROM gestaoHotel.Servico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idServico, custo, data, reserva, funcionario FROM gestaoHotel.Servico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_ServExt_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_ServExt_DataGrid;
CREATE FUNCTION [dbo].[udf_ServExt_DataGrid](@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, tipoServicoExt VARCHAR(20),
	 descricao VARCHAR(50))
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipoServicoExt, descricao 
				FROM gestaoHotel.Servico JOIN gestaoHotel.ServicoExterno ON Servico.idServico=ServicoExterno.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipoServicoExt, descricao   
				FROM gestaoHotel.Servico JOIN gestaoHotel.ServicoExterno ON Servico.idServico=ServicoExterno.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Temp_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Temp_DataGrid;
CREATE FUNCTION [dbo].[udf_Temp_DataGrid](@idTemporada INT=null)
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

GO
/****** Object:  UserDefinedFunction [dbo].[udf_TipoQuarto_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_TipoQuarto_DataGrid;
CREATE FUNCTION [dbo].[udf_TipoQuarto_DataGrid](@tipo VARCHAR(10)=null)
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Video_DataGrid]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION udf_Video_DataGrid;
CREATE FUNCTION [dbo].[udf_Video_DataGrid](@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, idFilme INT, hora TIME)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idFilme, hora 
				FROM gestaoHotel.Servico JOIN gestaoHotel.Video ON Servico.idServico=Video.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idFilme, hora  
				FROM gestaoHotel.Servico JOIN gestaoHotel.Video ON Servico.idServico=Video.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[VencimentoSuperior]    Script Date: 10/06/2016 18:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[VencimentoSuperior](@dno INT) RETURNS TABLE
AS
RETURN SELECT Ssn,Fname,Minit,Lname,Salary FROM dbo.employee WHERE dbo.employee.Salary >=(SELECT AVG(Salary) FROM dbo.employee WHERE Dno=@dno) GROUP BY Ssn,Fname,Minit,Lname ,Salary

GO
INSERT [gestaoHotel].[Cama] ([tipo], [preco]) VALUES (N'double', 25.0000)
INSERT [gestaoHotel].[Cama] ([tipo], [preco]) VALUES (N'king', 100.0000)
INSERT [gestaoHotel].[Cama] ([tipo], [preco]) VALUES (N'queen', 70.0000)
INSERT [gestaoHotel].[Cama] ([tipo], [preco]) VALUES (N'single', 20.0000)
INSERT [gestaoHotel].[Cama] ([tipo], [preco]) VALUES (N'twin', 50.0000)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (2)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (3)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (5)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (7)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (9)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (20)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (25)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (30)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (31)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (32)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (33)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (34)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (35)
INSERT [gestaoHotel].[Cliente] ([id]) VALUES (36)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1000, 25)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1001, 6)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1001, 7)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1001, 22)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1002, 21)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1002, 37)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1003, 23)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1004, 16)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1004, 21)
INSERT [gestaoHotel].[Depende] ([idTemporada], [idReserva]) VALUES (1004, 27)
INSERT [gestaoHotel].[Empregado] ([nrFuncionario], [supervisor]) VALUES (26, NULL)
INSERT [gestaoHotel].[Empregado] ([nrFuncionario], [supervisor]) VALUES (30, 26)
INSERT [gestaoHotel].[Estacionamento] ([idServico], [lugar]) VALUES (5, N'r-16')
INSERT [gestaoHotel].[Estacionamento] ([idServico], [lugar]) VALUES (7, N'a-21')
INSERT [gestaoHotel].[Estacionamento] ([idServico], [lugar]) VALUES (9, N'b-13')
INSERT [gestaoHotel].[Estacionamento] ([idServico], [lugar]) VALUES (10, N'l-1')
INSERT [gestaoHotel].[Estacionamento] ([idServico], [lugar]) VALUES (26, N'b-12')
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (4, 900, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (10, 1200, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (11, 1200, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (12, 1000, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (13, 900, 1)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (14, 1000, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (16, 1200, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (17, 650, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (18, 1000, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (19, 1100, 3)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (21, 1200, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (22, 10000, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (23, 10000, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (24, 10000, 2)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (26, 6000, 3)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (30, 4000, 1)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (66, 2000, 5)
INSERT [gestaoHotel].[Funcionario] ([id], [salario], [hotel]) VALUES (67, 2000, 5)
INSERT [gestaoHotel].[Gerente] ([nrFuncionario]) VALUES (21)
INSERT [gestaoHotel].[Gerente] ([nrFuncionario]) VALUES (22)
INSERT [gestaoHotel].[Gerente] ([nrFuncionario]) VALUES (23)
INSERT [gestaoHotel].[Gerente] ([nrFuncionario]) VALUES (24)
INSERT [gestaoHotel].[Gerente] ([nrFuncionario]) VALUES (66)
INSERT [gestaoHotel].[Gerente] ([nrFuncionario]) VALUES (67)
INSERT [gestaoHotel].[Hotel] ([idHotel], [nome], [classificacao], [localizacao], [codigoPostal], [gerente]) VALUES (1, N'Meliá', 4, N'7 Transport Pass', N'2453826800', 21)
INSERT [gestaoHotel].[Hotel] ([idHotel], [nome], [classificacao], [localizacao], [codigoPostal], [gerente]) VALUES (2, N'Resort Spa', 4, N'18 Grayhawk Court', N'5832508764', 22)
INSERT [gestaoHotel].[Hotel] ([idHotel], [nome], [classificacao], [localizacao], [codigoPostal], [gerente]) VALUES (3, N'Ibis', 2, N'1 Hoard Avenue', N'1627258225', 23)
INSERT [gestaoHotel].[Hotel] ([idHotel], [nome], [classificacao], [localizacao], [codigoPostal], [gerente]) VALUES (4, N'Lutécia Smart Design', 4, N'0801 Eagle Crest Pass', N'3740-221', 24)
INSERT [gestaoHotel].[Hotel] ([idHotel], [nome], [classificacao], [localizacao], [codigoPostal], [gerente]) VALUES (5, N'Hotel Ramiro', 2, N'Sever do Vouga', N'12312', 66)
INSERT [gestaoHotel].[Hotel] ([idHotel], [nome], [classificacao], [localizacao], [codigoPostal], [gerente]) VALUES (6, N'Hotel UA', 1, N'Rua da Pêga', N'3740-222', 67)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (1, N'mastercard', CAST(0xE7390B00 AS Date), 287.6000, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (2, N'jcb', CAST(0xBB3A0B00 AS Date), 817.6100, 11)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (3, N'jcb', CAST(0xAA3A0B00 AS Date), 104.0800, 13)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (4, N'jcb', CAST(0x213B0B00 AS Date), 137.0300, 10)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (5, N'visa-electron', CAST(0xF8390B00 AS Date), 267.6100, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (6, N'jcb', CAST(0xD73A0B00 AS Date), 613.4900, 14)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (7, N'diners-club-us-ca', CAST(0xE0390B00 AS Date), 346.0600, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (8, N'china-unionpay', CAST(0xA13A0B00 AS Date), 616.2400, 13)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (9, N'americanexpress', CAST(0x9D3A0B00 AS Date), 462.6700, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (10, N'mastercard', CAST(0xCB3A0B00 AS Date), 327.4800, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (11, N'switch', CAST(0xCD3A0B00 AS Date), 796.5100, 11)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (12, N'multibanco', CAST(0x863A0B00 AS Date), 917.9900, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (13, N'jcb', CAST(0x283A0B00 AS Date), 858.1300, 10)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (14, N'bankcard', CAST(0x0F3A0B00 AS Date), 256.9600, 12)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (15, N'visa', CAST(0xFD390B00 AS Date), 715.6800, 11)
INSERT [gestaoHotel].[Pagamento] ([idPagamento], [metodo], [dataPagamento], [custoTotal], [recepcionista]) VALUES (16, N'Multibanco', CAST(0x19260B00 AS Date), 35.0000, 17)
INSERT [gestaoHotel].[Pensao] ([tipo], [descricao]) VALUES (N'APA', N'Alojamento e pequeno-almoço')
INSERT [gestaoHotel].[Pensao] ([tipo], [descricao]) VALUES (N'PC', N'Tudo incluido (PC)')
INSERT [gestaoHotel].[Pensao] ([tipo], [descricao]) VALUES (N'SA', N'Apenas Alojamento ')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (2, N'slong1@wikipedia.org', N'Stephen', N'Long', CAST(0x2C2D0B00 AS Date), N'41173 Northview Park', N'M', N'147849065', N'8747489')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (3, N'ksimpson2@multiply.com', N'Kevin', N'Simpson', CAST(0x1A2D0B00 AS Date), N'256 Steensland Crossing', N'M', N'433420895', N'9469764')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (4, N'rwillis3@cloudflare.com', N'Russell', N'Willis', CAST(0xFE370B00 AS Date), N'8637 Lindbergh Pass', N'M', N'243810063', N'5478245')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (5, N'vcole4@comcast.net', N'Victor', N'Cole', CAST(0x313B0B00 AS Date), N'1956 Dennis Park', N'M', N'204452314', N'2815917')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (6, N'wwells5@mashable.com', N'Wanda', N'Wells', CAST(0xF4350B00 AS Date), N'712 Roxbury Park', N'F', N'178724722', N'5674831')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (7, N'rgray6@pen.io', N'Russell', N'Gray', CAST(0xE3320B00 AS Date), N'5 Graceland Center', N'M', N'899116553', N'3040464')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (8, N'jwest7@so-net.ne.jp', N'Jack', N'West', CAST(0x981E0B00 AS Date), N'3574 Dawn Street', N'M', N'378648914', N'3510887')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (9, N'bmcdonald8@spotify.com', N'Beverly', N'Mcdonald', CAST(0xD12F0B00 AS Date), N'8353 Oak Circle', N'F', N'311186278', N'5254647')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (10, N'pyoung9@scientificamerican.com', N'Peter', N'Young', CAST(0x002D0B00 AS Date), N'398 Judy Court', N'M', N'613894051', N'7030710')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (11, N'dortiza@cocolog-nifty.com', N'Dennis', N'Ortiz', CAST(0x7E270B00 AS Date), N'47 Ruskin Avenue', N'M', N'528700016', N'9262445')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (12, N'tsimpsonb@oaic.gov.au', N'Thomas', N'Simpson', CAST(0x2C3A0B00 AS Date), N'0858 Dottie Court', N'M', N'856580528', N'8138615')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (13, N'abellc@vinaora.com', N'Amanda', N'Bell', CAST(0xDC380B00 AS Date), N'52 Sauthoff Way', N'F', N'833406374', N'2436151')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (14, N'kpetersond@rambler.ru', N'Kelly', N'Peterson', CAST(0x212C0B00 AS Date), N'60650 John Wall Center', N'F', N'451249176', N'8909109')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (16, N'vgrantf@paginegialle.it', N'Victor', N'Grant', CAST(0x37290B00 AS Date), N'8 Pankratz Junction', N'M', N'978499632', N'3064730')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (17, N'mdunng@flickr.com', N'Matthew', N'Dunn', CAST(0x76210B00 AS Date), N'3644 Mitchell Way', N'M', N'557103316', N'6140222')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (18, N'pclarkh@usa.gov', N'Pamela', N'Clark', CAST(0x1A260B00 AS Date), N'7 Summit Avenue', N'F', N'779217664', N'5323709')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (19, N'dmurphyi@paypal.com', N'Donna', N'Murphy', CAST(0xD92A0B00 AS Date), N'8 Pleasure Hill', N'F', N'171862442', N'4203892')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (20, N'ngilbertj@mysql.com', N'Norma', N'Gilbert', CAST(0x982B0B00 AS Date), N'92 Washington Avenue', N'F', N'884872180', N'8760786')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (21, N'jmarshallk@mysql.com', N'Jason', N'Marshall', CAST(0x9F380B00 AS Date), N'3 Cottonwood Lane', N'M', N'982712224', N'2687541')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (22, N'lmitchelll@weibo.com', N'Louis', N'Mitchell', CAST(0xD22D0B00 AS Date), N'3599 Eliot Lane', N'M', N'790785686', N'3072629')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (23, N'pcastillom@cnet.com', N'Patrick', N'Castillo', CAST(0xE32F0B00 AS Date), N'1 Aberg Way', N'M', N'151950315', N'1358575')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (24, N'ddayn@independent.co.uk', N'Diane', N'Day', CAST(0xB2230B00 AS Date), N'1240 Summerview Park', N'F', N'533466906', N'3781097')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (25, N'rreyeso@eventbrite.com', N'Roy', N'Reyes', CAST(0x04260B00 AS Date), N'250 Onsgard Alley', N'M', N'200881357', N'7505696')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (26, N'kcarterp@utexas.edu', N'Kelly', N'Carter', CAST(0xB7310B00 AS Date), N'1 Boyd Trail', N'F', N'858541491', N'4381955')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (27, N'jrobertsq@abc.net.au', N'Jean', N'Roberts', CAST(0x6C300B00 AS Date), N'1299 Crowley Road', N'F', N'809829702', N'4654236')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (28, N'amarshallr@howstuffworks.com', N'Andrea', N'Marshall', CAST(0x36270B00 AS Date), N'3 Donald Center', N'F', N'684138993', N'3296363')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (29, N'rowenss@tmall.com', N'Ronald', N'Owens', CAST(0xF0220B00 AS Date), N'80 Daystar Point', N'M', N'331790940', N'9357902')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (30, N'lbarnest@virginia.edu', N'Lillian', N'Barnes', CAST(0x18300B00 AS Date), N'62616 Fuller Way', N'F', N'552647064', N'9974269')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (31, N'gallenu@storify.com', N'George', N'Allen', CAST(0x6C300B00 AS Date), N'87017 High Crossing Park', N'M', N'385450182', N'7826268')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (32, N'rcampbellv@tumblr.com', N'Ruth', N'Campbell', CAST(0x9B320B00 AS Date), N'91720 Steensland Center', N'F', N'932603439', N'5859390')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (33, N'cromerow@sphinn.com', N'Carlos', N'Romero', CAST(0x98390B00 AS Date), N'59 West Place, 98', N'M', N'967067493', N'3702187')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (34, N'rlynchx@sohu.com', N'Raymond', N'Lynch', CAST(0x2D330B00 AS Date), N'016 Superior Drive', N'M', N'578739742', N'7040347')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (35, N'jgonzalesy@parallels.com', N'Jerry', N'Gonzales', CAST(0xCB2A0B00 AS Date), N'7142 Katie Center', N'M', N'351662412', N'6362678')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (36, N'jfisherz@cmu.edu', N'Joyce', N'Fisher', CAST(0x33F60A00 AS Date), N'89 Oak Valley Alley', N'F', N'757830749', N'3276293')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (37, N'dvasquez10@webnode.com', N'Donald', N'Vasquez', CAST(0x901D0B00 AS Date), N'4537 Porter Alley', N'M', N'628099467', N'4397901')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (38, N'mvasquez11@cdc.gov', N'Marilyn', N'Vasquez', CAST(0x342B0B00 AS Date), N'47 Clemons Alley', N'F', N'572473809', N'1621082')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (50, N'rothixz@gmail.com', N'Antonio', N'mota', CAST(0x4B1E0B00 AS Date), N'rua da pega, nº 91, Aveiro', N'M', N'915464875', N'3256-536')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (51, N'qq', N'aaa', N'sss', CAST(0xF9360B00 AS Date), N'eee', N'F', N'44       ', N'fff')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (52, N'ww', N'ww', N'ww', CAST(0x3C340B00 AS Date), N'rr', N'M', N'111111   ', N'131')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (53, N'dd', N'q', N'e', CAST(0xDA250B00 AS Date), N'eee', N'M', N'555      ', N'13')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (54, N'rwwr', N'ffa', N'fafa', CAST(0x6C350B00 AS Date), N'sfafa', N'M', N'555      ', N'444')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (56, N'ad@hotmail.com', N'tttt', N'jjjj', CAST(0xAD280B00 AS Date), N'rua v', N'F', N'7777     ', N'131')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (58, N'adada', N'rr', N'ttt', CAST(0xA2360B00 AS Date), N'ggg', N'M', N'677      ', N'144')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (61, N'yyy', N'iiiiy', N'ttyyyy', CAST(0x4BEE0A00 AS Date), N'rer', N'M', N'777      ', N'244')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (62, N'tqtwe', N'franco', N'bartos', CAST(0x75030B00 AS Date), N'rewte', N'M', N'777      ', N'3452')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (64, N'gagaga', N'tttttgggg', N'tattaata', CAST(0x582A0B00 AS Date), N'fasfsaa', N'F', N'66666    ', N'555')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (65, N't', N't', N'y', CAST(0x332D0B00 AS Date), N'gh6', N'F', N'8888     ', N'6')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (66, N'ruiborges@hotmail.com', N'Rui', N'Borges', CAST(0x61E40A00 AS Date), N'Porto', N'M', N'961456331', N'3740-344')
INSERT [gestaoHotel].[Pessoa] ([idPessoa], [email], [Pnome], [Unome], [dataNasc], [endereco], [sexo], [nrTelefone], [codigoPostal]) VALUES (67, N'ruih@ua.pt', N'Rui', N'Henriques', CAST(0xA5E50A00 AS Date), N'Aveiro', N'M', N'911444333', N'3740-111')
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (101, 0x00, 0x01, 16101, N'single', 4)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (102, 0x01, 0x00, 16102, N'double', 4)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (103, 0x00, 0x01, 16103, N'twin', 1)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (104, 0x00, 0x00, 16104, N'mini-suite', 3)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (105, 0x00, 0x00, 16104, N'mini-suite', 3)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (106, 0x01, 0x01, 16106, N'twin', 4)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (107, 0x01, 0x01, 16107, N'double', 3)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (108, 0x00, 0x01, 16108, N'single', 2)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (109, 0x00, 0x00, 16109, N'single', 1)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (110, 0x01, 0x00, 16110, N'suite', 2)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (111, 0x00, 0x01, 16111, N'single', 2)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (112, 0x01, 0x01, 16112, N'single', 4)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (113, 0x01, 0x01, 16113, N'suite', 1)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (114, 0x01, 0x00, 16114, N'twin', 2)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (115, 0x00, 0x00, 16115, N'double', 2)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (116, 0x01, 0x00, 16116, N'mini-suite', 1)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (117, 0x01, 0x01, 16117, N'double', 2)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (118, 0x01, 0x01, 16118, N'double', 4)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (119, 0x01, 0x00, 16119, N'double', 3)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (120, 0x01, 0x01, 16120, N'double', 3)
INSERT [gestaoHotel].[Quarto] ([idQuarto], [fumador], [estado], [telefone], [tipoQuarto], [hotel]) VALUES (121, 0x00, 0x00, 16121, N'twin', 4)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (10, NULL)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (11, 10)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (12, 10)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (13, 12)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (14, 11)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (16, NULL)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (17, NULL)
INSERT [gestaoHotel].[Recepcionista] ([nrFuncionario], [supervisor]) VALUES (18, NULL)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'double', 2, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'double', 12, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'double', 13, 2)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'double', 14, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'king', 35, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'king', 39, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'queen', 28, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'queen', 29, 2)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'queen', 30, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 1, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 2, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 5, 2)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 6, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 7, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 11, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'single', 38, 2)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'twin', 23, 1)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'twin', 24, 2)
INSERT [gestaoHotel].[Requere] ([tipo], [idReserva], [quantidade]) VALUES (N'twin', 25, 1)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (1, 4, N'SA', CAST(0x743A0B00 AS Date), CAST(0x943A0B00 AS Date), 7, 118, 14, 35)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (2, 1, N'APA', CAST(0x953A0B00 AS Date), CAST(0x0D3C0B00 AS Date), 8, 104, 13, 33)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (3, 3, N'APA', CAST(0x093B0B00 AS Date), CAST(0xB43B0B00 AS Date), 5, 101, 13, 36)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (4, 3, N'APA', CAST(0x4E3A0B00 AS Date), CAST(0xF53A0B00 AS Date), 10, 108, 13, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (5, 2, N'APA', CAST(0xEF3A0B00 AS Date), CAST(0xA53B0B00 AS Date), 15, 107, 10, 33)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (6, 3, N'APA', CAST(0xBC3A0B00 AS Date), CAST(0x1B3B0B00 AS Date), 1, 113, 10, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (7, 5, N'APA', CAST(0xCA3A0B00 AS Date), CAST(0xD43A0B00 AS Date), 5, 101, 12, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (8, 1, N'APA', CAST(0xF33A0B00 AS Date), CAST(0x053B0B00 AS Date), 4, 110, 13, 31)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (9, 5, N'APA', CAST(0x293A0B00 AS Date), CAST(0x3B3B0B00 AS Date), 13, 119, 13, 33)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (10, 5, N'SA', CAST(0xB73A0B00 AS Date), CAST(0xBD3A0B00 AS Date), 15, 105, 14, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (11, 2, N'SA', CAST(0x2D3A0B00 AS Date), CAST(0x6B3A0B00 AS Date), 6, 101, 12, 33)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (12, 5, N'SA', CAST(0x8D3A0B00 AS Date), CAST(0xA33A0B00 AS Date), 9, 118, 10, 35)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (13, 2, N'SA', CAST(0xCE3A0B00 AS Date), CAST(0x663B0B00 AS Date), 2, 120, 11, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (14, 3, N'SA', CAST(0xE6390B00 AS Date), CAST(0x463A0B00 AS Date), 13, 116, 10, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (15, 4, N'SA', CAST(0x003A0B00 AS Date), CAST(0x633A0B00 AS Date), 13, 115, 10, 35)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (16, 4, N'SA', CAST(0x0E3B0B00 AS Date), CAST(0x363C0B00 AS Date), 12, 112, 10, 36)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (17, 5, N'SA', CAST(0xED3A0B00 AS Date), CAST(0x9A3B0B00 AS Date), 5, 116, 11, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (18, 1, N'SA', CAST(0x563A0B00 AS Date), CAST(0x183B0B00 AS Date), 14, 110, 14, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (19, 5, N'SA', CAST(0x7B390B00 AS Date), CAST(0x513A0B00 AS Date), 1, 101, 13, 36)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (20, 1, N'SA', CAST(0x803A0B00 AS Date), CAST(0x853A0B00 AS Date), 11, 107, 12, 33)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (21, 4, N'SA', CAST(0x183B0B00 AS Date), CAST(0x273B0B00 AS Date), 9, 119, 14, 35)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (22, 4, N'SA', CAST(0xE0390B00 AS Date), CAST(0xC93A0B00 AS Date), 6, 120, 14, 36)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (23, 5, N'SA', CAST(0xED390B00 AS Date), CAST(0x303A0B00 AS Date), 11, 115, 13, 32)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (24, 3, N'SA', CAST(0xCE3A0B00 AS Date), CAST(0x223B0B00 AS Date), 12, 105, 13, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (25, 4, N'SA', CAST(0x853A0B00 AS Date), CAST(0xB23A0B00 AS Date), 15, 109, 11, 36)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (26, 1, N'SA', CAST(0x8B3A0B00 AS Date), CAST(0x943A0B00 AS Date), 11, 112, 14, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (27, 3, N'SA', CAST(0x223B0B00 AS Date), CAST(0xFB3B0B00 AS Date), 12, 112, 10, 33)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (28, 5, N'SA', CAST(0xC43A0B00 AS Date), CAST(0xD63A0B00 AS Date), 4, 118, 13, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (29, 2, N'PC', CAST(0x313A0B00 AS Date), CAST(0x613A0B00 AS Date), 6, 107, 10, 35)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (30, 5, N'PC', CAST(0x073A0B00 AS Date), CAST(0x383A0B00 AS Date), 3, 112, 14, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (31, 5, N'PC', CAST(0xDA390B00 AS Date), CAST(0x3E3A0B00 AS Date), 2, 107, 10, 31)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (32, 5, N'PC', CAST(0x323B0B00 AS Date), CAST(0xC53B0B00 AS Date), 1, 115, 13, 30)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (33, 4, N'PC', CAST(0x833A0B00 AS Date), CAST(0xBE3A0B00 AS Date), 2, 111, 13, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (34, 4, N'PC', CAST(0xBF3A0B00 AS Date), CAST(0xCB3A0B00 AS Date), 11, 108, 14, 32)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (35, 3, N'PC', CAST(0x083B0B00 AS Date), CAST(0x493B0B00 AS Date), 16, 116, 13, 34)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (36, 5, N'PC', CAST(0xCA3A0B00 AS Date), CAST(0xE83A0B00 AS Date), NULL, 114, 13, 35)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (37, 1, N'PC', CAST(0xD73A0B00 AS Date), CAST(0x113B0B00 AS Date), NULL, 110, 13, 31)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (38, 5, N'PC', CAST(0x463A0B00 AS Date), CAST(0xF23A0B00 AS Date), NULL, 118, 12, 31)
INSERT [gestaoHotel].[Reserva] ([idReserva], [numPessoas], [tipoPensao], [dataInicio], [dataFim], [pagamento], [quarto], [recepcionista], [cliente]) VALUES (39, 1, N'PC', CAST(0xFF390B00 AS Date), CAST(0xDD3A0B00 AS Date), NULL, 117, 10, 33)
INSERT [gestaoHotel].[RestauranteBar] ([idServico], [tipo], [descricao]) VALUES (5, N'bar', N'coca cola')
INSERT [gestaoHotel].[RestauranteBar] ([idServico], [tipo], [descricao]) VALUES (9, N'restaurante', N'refeição de 4')
INSERT [gestaoHotel].[RestauranteBar] ([idServico], [tipo], [descricao]) VALUES (14, N'restaurante', N'refeiçao de 3')
INSERT [gestaoHotel].[RestauranteBar] ([idServico], [tipo], [descricao]) VALUES (18, N'bar', N'copo de wiskey')
INSERT [gestaoHotel].[RestauranteBar] ([idServico], [tipo], [descricao]) VALUES (30, N'restaurante', N'menu do dia')
INSERT [gestaoHotel].[RestauranteBar] ([idServico], [tipo], [descricao]) VALUES (31, N'bar', N'Tosta Mista e coca-cola')
INSERT [gestaoHotel].[RoomService] ([idServico], [idProduto], [hora]) VALUES (1, 2, CAST(0x0700EC8CCD6D0000 AS Time))
INSERT [gestaoHotel].[RoomService] ([idServico], [idProduto], [hora]) VALUES (2, 4, CAST(0x0700F47911620000 AS Time))
INSERT [gestaoHotel].[RoomService] ([idServico], [idProduto], [hora]) VALUES (3, 5, CAST(0x070094B94E180000 AS Time))
INSERT [gestaoHotel].[RoomService] ([idServico], [idProduto], [hora]) VALUES (4, 8, CAST(0x07008CB5AF590000 AS Time))
INSERT [gestaoHotel].[RoomService] ([idServico], [idProduto], [hora]) VALUES (22, 1, CAST(0x070082D85B1C0000 AS Time))
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (1, 86.0000, CAST(0x123A0B00 AS Date), 4, 21)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (2, 55.6000, CAST(0x923A0B00 AS Date), 3, 21)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (3, 55.0000, CAST(0x183B0B00 AS Date), 18, 21)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (4, 84.0000, CAST(0xF83A0B00 AS Date), 22, 19)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (5, 44.1400, CAST(0x1D3B0B00 AS Date), 28, 19)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (6, 33.0000, CAST(0xF53A0B00 AS Date), 28, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (7, 50.0000, CAST(0xB43A0B00 AS Date), 17, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (8, 51.0000, CAST(0x973A0B00 AS Date), 21, 18)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (9, 43.0000, CAST(0x9B3A0B00 AS Date), 15, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (10, 63.0000, CAST(0x7C3A0B00 AS Date), 24, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (11, 12.0000, CAST(0x343A0B00 AS Date), 38, 19)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (12, 89.0000, CAST(0x153B0B00 AS Date), 10, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (13, 19.0000, CAST(0xCD3A0B00 AS Date), 33, 21)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (14, 22.0000, CAST(0x043B0B00 AS Date), 8, 19)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (15, 84.0000, CAST(0x4D3A0B00 AS Date), 24, 19)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (16, 57.0000, CAST(0xEC3A0B00 AS Date), 31, 10)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (17, 68.0000, CAST(0xCE3A0B00 AS Date), 3, 23)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (18, 4.0000, CAST(0xBD3A0B00 AS Date), 21, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (20, 70.0000, CAST(0x8A3A0B00 AS Date), 35, 17)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (21, 3.0000, CAST(0x47380B00 AS Date), 3, 11)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (22, 2.0000, CAST(0x84380B00 AS Date), 3, 17)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (26, 30000.0000, CAST(0x7C360B00 AS Date), 11, 19)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (27, 11.0000, CAST(0x7B360B00 AS Date), 8, 10)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (28, 11.1400, CAST(0xC8370B00 AS Date), 5, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (29, 65.0000, CAST(0x5D360B00 AS Date), 7, 16)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (30, 14.0000, CAST(0x3E340B00 AS Date), 5, 13)
INSERT [gestaoHotel].[Servico] ([idServico], [custo], [data], [reserva], [funcionario]) VALUES (31, 4.5000, CAST(0x0A3A0B00 AS Date), 8, 10)
INSERT [gestaoHotel].[ServicoExterno] ([idServico], [tipoServicoExt], [descricao]) VALUES (15, N'aluguer', N'aluguer de carro')
INSERT [gestaoHotel].[ServicoExterno] ([idServico], [tipoServicoExt], [descricao]) VALUES (16, N'excursao', N'excursao a monte velho')
INSERT [gestaoHotel].[ServicoExterno] ([idServico], [tipoServicoExt], [descricao]) VALUES (17, N'babySitting', N'babySitting a 2 crianças')
INSERT [gestaoHotel].[ServicoExterno] ([idServico], [tipoServicoExt], [descricao]) VALUES (28, N'espetaculo', N'Adele Live')
INSERT [gestaoHotel].[ServicoExterno] ([idServico], [tipoServicoExt], [descricao]) VALUES (29, N'espetaculo', N'Bruce Springsteen Rock in Rio')
INSERT [gestaoHotel].[Temporada] ([idTemporada], [dataComeco], [dataTermino], [razao], [precoSimples], [precoDouble], [precoTwin], [precoMiniSuite], [precoSuite]) VALUES (2, CAST(0xB4390B00 AS Date), CAST(0xB7390B00 AS Date), N'feriado', 11.0000, 12.0000, 13.0000, 14.0000, 15.0000)
INSERT [gestaoHotel].[Temporada] ([idTemporada], [dataComeco], [dataTermino], [razao], [precoSimples], [precoDouble], [precoTwin], [precoMiniSuite], [precoSuite]) VALUES (1000, CAST(0x403C0B00 AS Date), CAST(0x433C0B00 AS Date), N'Natal', 120.0000, 130.0000, 140.0000, 150.0000, 160.0000)
INSERT [gestaoHotel].[Temporada] ([idTemporada], [dataComeco], [dataTermino], [razao], [precoSimples], [precoDouble], [precoTwin], [precoMiniSuite], [precoSuite]) VALUES (1001, CAST(0x483C0B00 AS Date), CAST(0x4B3C0B00 AS Date), N'Passagem de ano', 150.0000, 160.0000, 170.0000, 180.0000, 220.0000)
INSERT [gestaoHotel].[Temporada] ([idTemporada], [dataComeco], [dataTermino], [razao], [precoSimples], [precoDouble], [precoTwin], [precoMiniSuite], [precoSuite]) VALUES (1002, CAST(0x363B0B00 AS Date), CAST(0x393B0B00 AS Date), N'Conferencia Medicos', 120.0000, 120.0000, 120.0000, 130.0000, 130.0000)
INSERT [gestaoHotel].[Temporada] ([idTemporada], [dataComeco], [dataTermino], [razao], [precoSimples], [precoDouble], [precoTwin], [precoMiniSuite], [precoSuite]) VALUES (1003, CAST(0x593B0B00 AS Date), CAST(0x633B0B00 AS Date), N'Fim de semana', 140.0000, 150.0000, 160.0000, 160.0000, 200.0000)
INSERT [gestaoHotel].[Temporada] ([idTemporada], [dataComeco], [dataTermino], [razao], [precoSimples], [precoDouble], [precoTwin], [precoMiniSuite], [precoSuite]) VALUES (1004, CAST(0xFA3A0B00 AS Date), CAST(0x1B3B0B00 AS Date), N'promoção', 100.0000, 105.0000, 115.0000, 120.0000, 140.0000)
INSERT [gestaoHotel].[TipoQuarto] ([tipo], [descricao], [numCamasExtraDisp]) VALUES (N'double', N'quarto duplo', 2)
INSERT [gestaoHotel].[TipoQuarto] ([tipo], [descricao], [numCamasExtraDisp]) VALUES (N'mini-suite', N'Suite menor', 2)
INSERT [gestaoHotel].[TipoQuarto] ([tipo], [descricao], [numCamasExtraDisp]) VALUES (N'single', N'quarto single', 3)
INSERT [gestaoHotel].[TipoQuarto] ([tipo], [descricao], [numCamasExtraDisp]) VALUES (N'suite', N'suite', 3)
INSERT [gestaoHotel].[TipoQuarto] ([tipo], [descricao], [numCamasExtraDisp]) VALUES (N'twin', N'quarto twin', 2)
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (1, 3, CAST(0x07003A3D35620000 AS Time))
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (3, 4, CAST(0x07003A3D35620000 AS Time))
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (6, 1, CAST(0x07002A91630E0000 AS Time))
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (8, 10, CAST(0x0700E4FCA7670000 AS Time))
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (12, 10, CAST(0x0700F4A879BB0000 AS Time))
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (13, 10, CAST(0x070004C812030000 AS Time))
INSERT [gestaoHotel].[Video] ([idServico], [idFilme], [hora]) VALUES (27, 2, CAST(0x0700CA8B8F650000 AS Time))
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Pessoa__AB6E6164DA6B8845]    Script Date: 10/06/2016 18:09:52 ******/
ALTER TABLE [gestaoHotel].[Pessoa] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [gestaoHotel].[Reserva] ADD  DEFAULT ('SA') FOR [tipoPensao]
GO
ALTER TABLE [gestaoHotel].[Cliente]  WITH CHECK ADD FOREIGN KEY([id])
REFERENCES [gestaoHotel].[Pessoa] ([idPessoa])
GO
ALTER TABLE [gestaoHotel].[Depende]  WITH CHECK ADD FOREIGN KEY([idReserva])
REFERENCES [gestaoHotel].[Reserva] ([idReserva])
GO
ALTER TABLE [gestaoHotel].[Depende]  WITH CHECK ADD FOREIGN KEY([idTemporada])
REFERENCES [gestaoHotel].[Temporada] ([idTemporada])
GO
ALTER TABLE [gestaoHotel].[Empregado]  WITH CHECK ADD FOREIGN KEY([nrFuncionario])
REFERENCES [gestaoHotel].[Funcionario] ([id])
GO
ALTER TABLE [gestaoHotel].[Empregado]  WITH CHECK ADD FOREIGN KEY([supervisor])
REFERENCES [gestaoHotel].[Empregado] ([nrFuncionario])
GO
ALTER TABLE [gestaoHotel].[Estacionamento]  WITH CHECK ADD FOREIGN KEY([idServico])
REFERENCES [gestaoHotel].[Servico] ([idServico])
GO
ALTER TABLE [gestaoHotel].[Funcionario]  WITH CHECK ADD FOREIGN KEY([id])
REFERENCES [gestaoHotel].[Pessoa] ([idPessoa])
GO
ALTER TABLE [gestaoHotel].[Funcionario]  WITH CHECK ADD  CONSTRAINT [HOFKIH] FOREIGN KEY([hotel])
REFERENCES [gestaoHotel].[Hotel] ([idHotel])
ON UPDATE CASCADE
GO
ALTER TABLE [gestaoHotel].[Funcionario] CHECK CONSTRAINT [HOFKIH]
GO
ALTER TABLE [gestaoHotel].[Gerente]  WITH CHECK ADD FOREIGN KEY([nrFuncionario])
REFERENCES [gestaoHotel].[Funcionario] ([id])
GO
ALTER TABLE [gestaoHotel].[Hotel]  WITH CHECK ADD FOREIGN KEY([gerente])
REFERENCES [gestaoHotel].[Gerente] ([nrFuncionario])
GO
ALTER TABLE [gestaoHotel].[Pagamento]  WITH CHECK ADD FOREIGN KEY([recepcionista])
REFERENCES [gestaoHotel].[Recepcionista] ([nrFuncionario])
GO
ALTER TABLE [gestaoHotel].[Quarto]  WITH CHECK ADD FOREIGN KEY([hotel])
REFERENCES [gestaoHotel].[Hotel] ([idHotel])
GO
ALTER TABLE [gestaoHotel].[Quarto]  WITH CHECK ADD FOREIGN KEY([tipoQuarto])
REFERENCES [gestaoHotel].[TipoQuarto] ([tipo])
GO
ALTER TABLE [gestaoHotel].[Recepcionista]  WITH CHECK ADD FOREIGN KEY([nrFuncionario])
REFERENCES [gestaoHotel].[Funcionario] ([id])
GO
ALTER TABLE [gestaoHotel].[Recepcionista]  WITH CHECK ADD FOREIGN KEY([supervisor])
REFERENCES [gestaoHotel].[Recepcionista] ([nrFuncionario])
GO
ALTER TABLE [gestaoHotel].[Requere]  WITH CHECK ADD FOREIGN KEY([idReserva])
REFERENCES [gestaoHotel].[Reserva] ([idReserva])
GO
ALTER TABLE [gestaoHotel].[Requere]  WITH CHECK ADD FOREIGN KEY([tipo])
REFERENCES [gestaoHotel].[Cama] ([tipo])
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD FOREIGN KEY([cliente])
REFERENCES [gestaoHotel].[Cliente] ([id])
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD FOREIGN KEY([pagamento])
REFERENCES [gestaoHotel].[Pagamento] ([idPagamento])
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD FOREIGN KEY([quarto])
REFERENCES [gestaoHotel].[Quarto] ([idQuarto])
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD FOREIGN KEY([recepcionista])
REFERENCES [gestaoHotel].[Recepcionista] ([nrFuncionario])
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD FOREIGN KEY([tipoPensao])
REFERENCES [gestaoHotel].[Pensao] ([tipo])
GO
ALTER TABLE [gestaoHotel].[RestauranteBar]  WITH CHECK ADD FOREIGN KEY([idServico])
REFERENCES [gestaoHotel].[Servico] ([idServico])
GO
ALTER TABLE [gestaoHotel].[RoomService]  WITH CHECK ADD FOREIGN KEY([idServico])
REFERENCES [gestaoHotel].[Servico] ([idServico])
GO
ALTER TABLE [gestaoHotel].[Servico]  WITH CHECK ADD FOREIGN KEY([funcionario])
REFERENCES [gestaoHotel].[Funcionario] ([id])
GO
ALTER TABLE [gestaoHotel].[Servico]  WITH CHECK ADD FOREIGN KEY([reserva])
REFERENCES [gestaoHotel].[Reserva] ([idReserva])
GO
ALTER TABLE [gestaoHotel].[ServicoExterno]  WITH CHECK ADD FOREIGN KEY([idServico])
REFERENCES [gestaoHotel].[Servico] ([idServico])
GO
ALTER TABLE [gestaoHotel].[Video]  WITH CHECK ADD FOREIGN KEY([idServico])
REFERENCES [gestaoHotel].[Servico] ([idServico])
GO
ALTER TABLE [gestaoHotel].[Cama]  WITH CHECK ADD CHECK  (([tipo]='king' OR [tipo]='queen' OR [tipo]='twin' OR [tipo]='double' OR [tipo]='single'))
GO
ALTER TABLE [gestaoHotel].[Pensao]  WITH CHECK ADD CHECK  (([tipo]='PC' OR [tipo]='APA' OR [tipo]='SA'))
GO
ALTER TABLE [gestaoHotel].[Quarto]  WITH CHECK ADD CHECK  (([estado]=(1) OR [estado]=(0)))
GO
ALTER TABLE [gestaoHotel].[Quarto]  WITH CHECK ADD CHECK  (([fumador]=(1) OR [fumador]=(0)))
GO
ALTER TABLE [gestaoHotel].[Quarto]  WITH CHECK ADD CHECK  (([tipoQuarto]='suite' OR [tipoQuarto]='mini-suite' OR [tipoQuarto]='twin' OR [tipoQuarto]='double' OR [tipoQuarto]='single'))
GO
ALTER TABLE [gestaoHotel].[Requere]  WITH CHECK ADD CHECK  (([quantidade]=(2) OR [quantidade]=(1) OR [quantidade]=(0)))
GO
ALTER TABLE [gestaoHotel].[Requere]  WITH CHECK ADD CHECK  (([tipo]='king' OR [tipo]='queen' OR [tipo]='twin' OR [tipo]='double' OR [tipo]='single'))
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD CHECK  (([DataFim]>[DataInicio]))
GO
ALTER TABLE [gestaoHotel].[Reserva]  WITH CHECK ADD CHECK  (([tipoPensao]='PC' OR [tipoPensao]='APA' OR [tipoPensao]='SA'))
GO
ALTER TABLE [gestaoHotel].[RestauranteBar]  WITH CHECK ADD CHECK  (([tipo]='restaurante' OR [tipo]='bar'))
GO
ALTER TABLE [gestaoHotel].[ServicoExterno]  WITH CHECK ADD CHECK  (([tipoServicoExt]='espetaculo' OR [tipoServicoExt]='babySitting' OR [tipoServicoExt]='excursao' OR [tipoServicoExt]='aluguer'))
GO
ALTER TABLE [gestaoHotel].[Temporada]  WITH CHECK ADD CHECK  (([dataTermino]>[dataComeco]))
GO
ALTER TABLE [gestaoHotel].[TipoQuarto]  WITH CHECK ADD CHECK  (([tipo]='suite' OR [tipo]='mini-suite' OR [tipo]='twin' OR [tipo]='double' OR [tipo]='single'))
GO
/****** Object:  Trigger [gestaoHotel].[trigger_gerente_hotel]    Script Date: 10/06/2016 18:09:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [gestaoHotel].[trigger_gerente_hotel] ON [gestaoHotel].[Hotel]
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON;
	DECLARE @COUNT AS INT
	SELECT @COUNT = COUNT(*) FROM gestaoHotel.Hotel JOIN inserted ON gestaoHotel.Hotel.gerente=inserted.gerente;
		IF @COUNT > 1
			BEGIN
				RAISERROR ('O Gerente já é gestor de um Hotel!', 16, 1)
				ROLLBACK TRAN;
			END
GO
