
use p3g4;

GO
--DROP FUNCTION udf_Reserva_DataGrid;
CREATE FUNCTION udf_Reserva_DataGrid(@idReserva INT=null)
RETURNS @table TABLE (idReserva INT, numPessoas INT, tipoPensao VARCHAR(3), dataInicio DATE, 
	dataFim DATE, pagamento INT, quarto INT, recepcionista INT, cliente INT, tipo VARCHAR(10),quantidade INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idReserva is NULL)
		BEGIN
			INSERT @table SELECT Reserva.idReserva, numPessoas, tipoPensao, dataInicio, 
	dataFim, pagamento, quarto, recepcionista, cliente, tipo, quantidade  
	FROM gestaoHotel.Requere RIGHT OUTER JOIN gestaoHotel.Reserva ON Requere.idReserva=Reserva.idReserva;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Reserva.idReserva, numPessoas, tipoPensao, dataInicio, 
	dataFim, pagamento, quarto, recepcionista, cliente, tipo, quantidade  
	FROM gestaoHotel.Requere RIGHT OUTER JOIN gestaoHotel.Reserva ON Requere.idReserva=Reserva.idReserva
		WHERE gestaoHotel.Reserva.idReserva = @idReserva
		END;
	RETURN;
END;