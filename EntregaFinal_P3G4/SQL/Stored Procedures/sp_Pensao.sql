
use p3g4;

--DROP PROCEDURE sp_AddPensao;
GO
--Criação de uma Pensao
CREATE PROCEDURE sp_AddPensao
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


-- DROP PROCEDURE sp_UpdatePensao;
GO
--Atualização de uma Pensao
CREATE PROCEDURE sp_UpdatePensao
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


-- DROP PROCEDURE sp_DeletePensao
GO
CREATE PROCEDURE sp_DeletePensao
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