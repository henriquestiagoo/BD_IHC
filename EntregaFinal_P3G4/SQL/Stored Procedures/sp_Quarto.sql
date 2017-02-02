
use p3g4;

--DROP PROCEDURE sp_AddQuarto;
GO
--Cria��o de um Quarto
CREATE PROCEDURE sp_AddQuarto
	@idQuarto			INT,
	@fumador			INT,
	@estado				INT,
	@telefone			INT,
	@tipoQuarto			VARCHAR(10),
	@hotel				INT
	AS
		IF @idQuarto is NULL
		BEGIN
			PRINT 'O id do Quarto n�o pode estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the room already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Quarto WHERE idQuarto = @idQuarto;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O Quarto que pretende adicionar j� existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		-- check if a room already exists with the same phone number so the addition could not be completed
		DECLARE @COUNT2 INT
		SELECT @COUNT2 = COUNT(*) FROM gestaoHotel.Quarto WHERE telefone = @telefone;
		IF @COUNT2=1
			BEGIN
				RAISERROR ('J� existe um Quarto com este n�mero de telefone!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.Quarto([idQuarto],[fumador],[estado],[telefone],[tipoQuarto],[hotel]) 
				VALUES (@idQuarto, @fumador, @estado, @telefone, @tipoQuarto, @hotel)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a cria��o do quarto!', 14, 1)
		END CATCH;


-- DROP PROCEDURE sp_UpdateQuarto;
GO
--Atualiza��o de um Quarto
CREATE PROCEDURE sp_UpdateQuarto
	@idQuarto			INT,
	@fumador			INT,
	@estado				INT,
	@telefone			INT,
	@tipoQuarto			VARCHAR(10),
	@hotel				INT
	AS 
		IF @idQuarto is NULL
		BEGIN
			PRINT 'O id do Quarto n�o pode estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the room exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.Quarto WHERE idQuarto = @idQuarto;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Quarto em quest�o n�o existe!!', 14, 1)
			RETURN
		END
		BEGIN TRY
			UPDATE  gestaoHotel.Quarto SET fumador = @fumador,
			 estado = @estado, telefone = @telefone, tipoQuarto = @tipoQuarto, hotel = @hotel
				 WHERE idQuarto = @idQuarto;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualiza��o do quarto!', 14, 1)
		END CATCH;

-- DROP PROCEDURE sp_DeleteQuarto
GO
CREATE PROCEDURE sp_DeleteQuarto
	@idQuarto				INT
	AS 
	IF @idQuarto is NULL 
	BEGIN
		PRINT 'O quarto n�o pode ser estar vazio!'
		RETURN
	END
	---------------------------------------------------------------------
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM gestaoHotel.Reserva WHERE quarto=@idQuarto;
	IF @COUNT != 0
	BEGIN
		RAISERROR ('O quarto est� associado a reservas logo n�o pode ser eliminado!', 14, 1)
		RETURN;
	END;
	---------------------------------------------------------------------
	BEGIN TRY
		DELETE FROM gestaoHotel.Quarto WHERE idQuarto = @idQuarto;
	END TRY
	BEGIN CATCH
		RAISERROR ('Ocorreu um erro durante a remo��o do Quarto!', 14, 1)
	END CATCH;
