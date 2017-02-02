
use p3g4;

GO
CREATE NONCLUSTERED INDEX idxDataReserva ON gestaoHotel.Reserva(dataInicio)
WITH (FILLFACTOR=75,pad_index=ON);