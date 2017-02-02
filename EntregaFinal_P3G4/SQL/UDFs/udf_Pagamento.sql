
use p3g4;

GO
--DROP FUNCTION udf_Pagamento_DataGrid;
CREATE FUNCTION udf_Pagamento_DataGrid(@idPagamento INT=null)
RETURNS @table TABLE (idPagamento INT, metodo VARCHAR(20), dataPagamento DATE, 
	custoTotal MONEY,recepcionista INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idPagamento is NULL)
		BEGIN
			INSERT @table SELECT idPagamento, metodo, dataPagamento, 
	custoTotal, recepcionista FROM gestaoHotel.Pagamento
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idPagamento, metodo, dataPagamento, 
	custoTotal, recepcionista FROM gestaoHotel.Pagamento
		WHERE gestaoHotel.Pagamento.idPagamento = @idPagamento
		END;
	RETURN;
END;