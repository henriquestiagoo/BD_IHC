
use p3g4;


-- ##############################################################################################
-- #											RESTBAR												#
-- ##############################################################################################

--DROP PROCEDURE sp_AddRestBar;
GO
--Criação de um Servico
CREATE PROCEDURE sp_AddRestBar
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

-- DROP PROCEDURE sp_UpdateRestBar;
GO
--Atualização de um Servico RestBar
CREATE PROCEDURE sp_UpdateRestBar
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


-- DROP PROCEDURE sp_DeleteRestBar
GO
CREATE PROCEDURE sp_DeleteRestBar
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

-- ##############################################################################################
-- #										ROOMSERV												#
-- ##############################################################################################

--DROP PROCEDURE sp_AddRoomServ;
GO
--Criação de um Servico
CREATE PROCEDURE sp_AddRoomServ
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


-- DROP PROCEDURE sp_UpdateRoomServ;
GO
--Atualização de um Servico RoomServ
CREATE PROCEDURE sp_UpdateRoomServ
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

-- DROP PROCEDURE sp_DeleteRoomServ
GO
CREATE PROCEDURE sp_DeleteRoomServ
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


-- ##############################################################################################
-- #										ESTACIONAMENTO											#
-- ##############################################################################################

--DROP PROCEDURE sp_AddEst;
GO
--Criação de um Servico
CREATE PROCEDURE sp_AddEst
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
--DROP PROCEDURE sp_UpdateEst;
--Atualização de um Servico RestBar
CREATE PROCEDURE sp_UpdateEst
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

-- DROP PROCEDURE sp_DeleteEst
GO
CREATE PROCEDURE sp_DeleteEst
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


-- ##############################################################################################
-- #											   VIDEO											#
-- ##############################################################################################

--DROP PROCEDURE sp_AddVideo;
GO
--Criação de um Servico
CREATE PROCEDURE sp_AddVideo
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
--DROP PROCEDURE sp_UpdateVideo;
--Atualização de um Servico RestBar
CREATE PROCEDURE sp_UpdateVideo
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

-- DROP PROCEDURE sp_DeleteVideo
GO
CREATE PROCEDURE sp_DeleteVideo
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


-- ##############################################################################################
-- #											   SERVEXT											#
-- ##############################################################################################

--DROP PROCEDURE sp_AddServExt;
GO
--Criação de um Servico
CREATE PROCEDURE sp_AddServExt
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
--DROP PROCEDURE sp_UpdateServExt;
--Atualização de um Servico ServExt
CREATE PROCEDURE sp_UpdateServExt
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


-- DROP PROCEDURE sp_DeleteServExt
GO
CREATE PROCEDURE sp_DeleteServExt
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