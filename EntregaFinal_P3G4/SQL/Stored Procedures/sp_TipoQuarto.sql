

use p3g4;

--DROP PROCEDURE sp_AddTipoQuarto;
GO
--Criação de um TipoQuarto
CREATE PROCEDURE sp_AddTipoQuarto
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


-- DROP PROCEDURE sp_UpdateTipoQuarto;
GO
--Atualização de um TipoQuarto
CREATE PROCEDURE sp_UpdateTipoQuarto
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


-- DROP PROCEDURE sp_DeleteTipoQuarto
GO
CREATE PROCEDURE sp_DeleteTipoQuarto
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
		END;