use p3g4;
GO
--DROP FUNCTION gestaoHotel.HotelComMaisClientes;
CREATE FUNCTION gestaoHotel.HotelComMaisClientes() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' -> '+CONVERT(varchar(10),COUNT(Cliente.id))+' Clientes' FROM (gestaoHotel.Quarto JOIN (gestaoHotel.Reserva JOIN gestaoHotel.Cliente ON id=cliente) ON quarto=idQuarto) JOIN gestaoHotel.Hotel ON hotel=idHotel GROUP BY idHotel,nome,localizacao ORDER BY COUNT(Cliente.id) DESC)
END
GO


--DROP FUNCTION gestaoHotel.HotelComMaisClientes
select gestaoHotel.HotelComMaisClientes()