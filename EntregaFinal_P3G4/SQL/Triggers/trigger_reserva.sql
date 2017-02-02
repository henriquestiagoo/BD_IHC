
use p3g4;

--c)

--Trigger que não permite que determinada reserva seja removida se 
--o pagamento da mesma ainda não efetuado
--DROP TRIGGER trigger_reserva_pag;
GO
CREATE TRIGGER trigger_reserva_pag ON gestaoHotel.Reserva
AFTER DELETE
AS
	SET NOCOUNT ON;
	DECLARE @COUNT AS INT
	SELECT @COUNT = COUNT(*) FROM (gestaoHotel.Pagamento JOIN gestaoHotel.Reserva 
			ON Pagamento.idPagamento=Reserva.pagamento) JOIN inserted ON Reserva.pagamento=inserted.pagamento;
		IF @COUNT = 0
			BEGIN
				RAISERROR ('Tem de efetuar o pagamento da reserva para a poder eliminar!', 16, 1)
				ROLLBACK TRAN;
			END

-- Não foi implementado pq assumimos que só eliminavamos reservas que ainda pudessem ser canceladas
-- ou seja, reservas que tenham uma data de inicio superior ao dia atual!!
