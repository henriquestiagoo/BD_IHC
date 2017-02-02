use p3g4;
GO
--DROP FUNCTION gestaoHotel.HotelComMaisReservas;
CREATE FUNCTION gestaoHotel.HotelComMaisReservas() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' - > '+CONVERT(varchar(10),COUNT(idReserva))+' Reservas' FROM (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON quarto=idQuarto) JOIN gestaoHotel.Hotel ON hotel=idHotel GROUP BY idHotel,nome,localizacao ORDER BY COUNT(idReserva) DESC)
END
GO





--DROP FUNCTION gestaoHotel.HotelComMaisReservas