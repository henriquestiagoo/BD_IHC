
use p3g4;

-- ##############################################################################################
-- #											RESERVAS											#
-- ##############################################################################################

--DROP PROCEDURE sp_AddReserva;
GO
--Criação de uma Reserva
CREATE PROCEDURE sp_AddReserva
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


--DROP PROCEDURE sp_UpdateReserva;
GO
--Criação de uma Reserva
CREATE PROCEDURE sp_UpdateReserva
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


go
--DROP PROC sp_DeleteReserva;
CREATE PROCEDURE sp_DeleteReserva 
@idReserva INT   
AS
IF (SELECT dataInicio FROM gestaoHotel.Reserva WHERE idReserva = @idReserva) >= Convert(date, getdate())
	BEGIN 
		DELETE FROM gestaoHotel.Requere WHERE idReserva=@idReserva;
		DELETE FROM gestaoHotel.Reserva WHERE idReserva=@idReserva;
	END;
ELSE 
	RAISERROR('Impossivel remover reserva por já ter passado data',14,1);
go
