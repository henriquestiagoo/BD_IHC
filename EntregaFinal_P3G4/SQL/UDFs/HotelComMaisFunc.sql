use p3g4;
GO
CREATE FUNCTION gestaoHotel.HotelComMaisFunc() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' -> '+CONVERT(varchar(10),COUNT(id))+' Funcionarios' FROM gestaoHotel.Funcionario JOIN gestaoHotel.Hotel ON hotel=idHotel GROUP BY idHotel,nome,localizacao ORDER BY COUNT(id) DESC)
END
GO

--DROP FUNCTION gestaoHotel.HotelComMaisFunc

