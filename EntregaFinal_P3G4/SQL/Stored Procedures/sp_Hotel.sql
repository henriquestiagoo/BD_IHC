
use p3g4;

--DROP PROCEDURE sp_AddHotel;
GO
--Criação de um Hotel
CREATE PROCEDURE sp_AddHotel
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
		---------------------------------------------------------------------

-- DROP PROCEDURE sp_UpdateHotel;
GO
--Atualização de um Hotel
CREATE PROCEDURE sp_UpdateHotel
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


-- DROP PROCEDURE sp_DeleteHotel
GO
CREATE PROCEDURE sp_DeleteHotel
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