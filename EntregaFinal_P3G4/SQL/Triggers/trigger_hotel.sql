
use p3g4;

--Trigger que não permite que determinado gerente seja definido
--como gerente de mais do que um hotel.
--DROP TRIGGER trigger_gerente;
GO
CREATE TRIGGER trigger_gerente_hotel ON gestaoHotel.Hotel
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON;
	DECLARE @COUNT AS INT
	SELECT @COUNT = COUNT(*) FROM gestaoHotel.Hotel JOIN inserted 
		ON gestaoHotel.Hotel.gerente=inserted.gerente;
	IF @COUNT > 1
		BEGIN
			RAISERROR ('O Gerente já é gestor de um Hotel!', 16, 1)
			ROLLBACK TRAN;
		END

--GO
--UPDATE gestaoHotel.Hotel SET gerente = 22 WHERE idHotel = 1;