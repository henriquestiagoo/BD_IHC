use p3g4;
GO
CREATE FUNCTION gestaoHotel.HotelComGerenteMaisBemPago() RETURNS VARCHAR (100)
AS
BEGIN
RETURN (SELECT TOP 1 CONVERT(varchar(10),idHotel)+' '+ nome+' '+localizacao+' -> '+CONVERT(varchar(10),salario)+'€' FROM (gestaoHotel.Gerente JOIN gestaoHotel.Funcionario ON nrFuncionario=id )JOIN gestaoHotel.Hotel ON gerente=nrFuncionario GROUP BY salario,idHotel,nome,localizacao ORDER BY salario DESC)
END
GO

--DROP FUNCTION gestaoHotel.HotelComGerenteMaisBemPago