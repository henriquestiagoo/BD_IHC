

use p3g4;

--DROP PROCEDURE sp_AddTipoQuarto;
GO
--Cria��o de um TipoQuarto
CREATE PROCEDURE sp_AddTipoQuarto
	@tipo				VARCHAR(10),
	@descricao			VARCHAR(50),
	@numCamasExtraDisp	INT
	AS
		IF @tipo is NULL OR @numCamasExtraDisp is NULL 
		BEGIN
			PRINT 'O tipo e o n�mero de camas extra dispon�veis 
				para o tipo de quarto em quest�o n�o podem estar por preencher!!'
			RETURN
		END
		---------------------------------------------------------------------
		-- check if the room type already exists so the addition could not be completed
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.TipoQuarto WHERE tipo = @tipo;
		IF @COUNT=1
			BEGIN
				RAISERROR ('O Tipo de Quarto que pretende adicionar j� existe!', 14, 1)
				RETURN
			END
		---------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO GestaoHotel.TipoQuarto([tipo],[descricao],[numCamasExtraDisp]) 
				VALUES (@tipo,@descricao,@numCamasExtraDisp)
		END TRY
		---------------------------------------------------------------------
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a cria��o do tipo de quarto!', 14, 1)
		END CATCH;


-- DROP PROCEDURE sp_UpdateTipoQuarto;
GO
--Atualiza��o de um TipoQuarto
CREATE PROCEDURE sp_UpdateTipoQuarto
	@tipo				VARCHAR(10),
	@descricao			VARCHAR(50),
	@numCamasExtraDisp	INT
	AS 
		IF @tipo is NULL OR @numCamasExtraDisp is NULL 
		BEGIN
			PRINT 'O tipo e o n�mero de camas extra dispon�veis 
				para o tipo de quarto em quest�o n�o podem estar por preencher!!'
			RETURN
		END
		DECLARE @COUNT INT
		-- check if the room type exists
		SELECT @COUNT = COUNT(*) FROM gestaoHotel.TipoQuarto WHERE tipo = @tipo;
		IF @COUNT = 0
		BEGIN
			RAISERROR ('O Tipo de Quarto em quest�o n�o existe!', 14, 1)
			RETURN
		END
		BEGIN TRY
			UPDATE  gestaoHotel.TipoQuarto SET tipo = @tipo,
				descricao = @descricao, numCamasExtraDisp = @numCamasExtraDisp
				 WHERE tipo = @tipo;
		END TRY
		BEGIN CATCH
			RAISERROR ('Ocorreu um erro durante a atualiza��o do tipo de quarto!', 14, 1)
		END CATCH;


-- DROP PROCEDURE sp_DeleteTipoQuarto
GO
CREATE PROCEDURE sp_DeleteTipoQuarto
	@tipo				VARCHAR(10)
	AS 
	IF @tipo is NULL 
	BEGIN
		PRINT 'O tipo de quarto n�o pode ser estar vazio!'
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
			RAISERROR ('Ocorreu um erro durante a remo��o do Hotel!', 14, 1)
		END CATCH
	ELSE
		BEGIN
			RAISERROR ('O Tipo de Quarto em quest�o tem Quartos deste tipo logo n�o pode ser eliminado!', 14, 1)
			RETURN
		END;