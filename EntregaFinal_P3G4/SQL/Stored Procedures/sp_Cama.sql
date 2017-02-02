
use p3g4;

--DROP PROCEDURE sp_AddCama;
GO
--Criação de uma Cama
CREATE PROCEDURE sp_AddCama
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


-- DROP PROCEDURE sp_UpdateCama;
GO
--Atualização de uma Cama
CREATE PROCEDURE sp_UpdateCama
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


-- DROP PROCEDURE sp_DeleteCama
GO
CREATE PROCEDURE sp_DeleteCama
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
