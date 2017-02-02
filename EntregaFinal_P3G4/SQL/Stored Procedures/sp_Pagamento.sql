
use p3g4;

--DROP PROCEDURE sp_AddPag;
GO
--Criação de um pagamento
CREATE PROCEDURE sp_AddPag
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
		---------------------------------------------------------------------



--DROP PROCEDURE sp_UpdatePag;
GO
--Atualizacao de um pagamento
CREATE PROCEDURE sp_UpdatePag
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
