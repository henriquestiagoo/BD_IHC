
use p3g4;

--DROP PROCEDURE sp_AddTemporada;
GO
--Criação de uma temporada
CREATE PROCEDURE sp_AddTemporada
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


--DROP PROCEDURE sp_UpdateTemporada;
GO
--Atualizacao de uma temporada
CREATE PROCEDURE sp_UpdateTemporada
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


-- DROP PROCEDURE sp_DeleteTemporada
GO
CREATE PROCEDURE sp_DeleteTemporada
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