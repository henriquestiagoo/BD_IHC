
use p3g4;

-- STATS

GO
-- DROP FUNCTION udf_Hotel_Stats_Nr_hoteis;
CREATE FUNCTION udf_Hotel_Stats_Nr_hoteis()
RETURNS @table TABLE (numero INT)
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT COUNT(DISTINCT idHotel) AS numero FROM gestaoHotel.Hotel;
	END;
	RETURN;
END;

GO
-- DROP FUNCTION udf_Hotel_Stats_hotel_mais_clientes;
CREATE FUNCTION udf_Hotel_Stats_hotel_mais_clientes()
RETURNS @table TABLE (hotel VARCHAR(100))
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT CONVERT(varchar(10), idHotel)+' - '+Hotel.nome+', '+Hotel.localizacao AS hotel FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
GROUP BY idHotel, Hotel.nome,Hotel.localizacao,Hotel.classificacao
HAVING COUNT(idHotel)=(SELECT MAX(nr_clientes) AS maxim FROM (SELECT idHotel, Hotel.nome, Hotel.localizacao, Hotel.classificacao, COUNT(idHotel) AS nr_clientes
FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
GROUP BY idHotel, Hotel.nome,Hotel.localizacao,Hotel.classificacao) AS T2);
	END;
	RETURN;
END;



GO
-- DROP FUNCTION udf_Hotel_Stats_Clientes_Hotel;
CREATE FUNCTION udf_Hotel_Stats_Clientes_Hotel()
RETURNS @table TABLE (idHotel INT, nome VARCHAR(30), localizacao VARCHAR(50), classificacao INT, nr_clientes INT)
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT idHotel, Hotel.nome, Hotel.localizacao, Hotel.classificacao, COUNT(idHotel) AS nr_clientes
			FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
				GROUP BY idHotel, Hotel.nome,Hotel.localizacao,Hotel.classificacao;
	END;
	RETURN;
END;

GO
-- DROP FUNCTION udf_Hotel_Stats_Gerentes_Hotel;
CREATE FUNCTION udf_Hotel_Stats_Gerentes_Hotel()
RETURNS @table TABLE (idHotel INT, nome VARCHAR(30), localizacao VARCHAR(50), nome_Gerente VARCHAR(50), id INT, Salario INT)
WITH SCHEMABINDING
AS
BEGIN
	BEGIN
		INSERT @table SELECT idHotel, Hotel.nome, Hotel.localizacao, Pnome+' '+Unome AS nome_Gerente, idPessoa AS id, Salario
			FROM gestaoHotel.Pessoa JOIN gestaoHotel.Hotel ON idPessoa=gerente JOIN gestaoHotel.Funcionario ON idPessoa=id
				ORDER BY idHotel, Hotel.nome, Hotel.localizacao;
	END;
	RETURN;
END;



