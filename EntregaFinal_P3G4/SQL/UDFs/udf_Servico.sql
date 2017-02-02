
use p3g4;

GO
--DROP FUNCTION udf_RestBar_DataGrid;
CREATE FUNCTION udf_RestBar_DataGrid(@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, tipo VARCHAR(20),
	descricao VARCHAR(50))
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipo, descricao 
				FROM gestaoHotel.Servico JOIN gestaoHotel.RestauranteBar ON Servico.idServico=RestauranteBar.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipo, descricao 
				FROM gestaoHotel.Servico JOIN gestaoHotel.RestauranteBar ON Servico.idServico=RestauranteBar.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;


GO
--DROP FUNCTION udf_RoomServ_DataGrid;
CREATE FUNCTION udf_RoomServ_DataGrid(@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, idProduto INT,
	hora TIME)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idProduto, hora 
				FROM gestaoHotel.Servico JOIN gestaoHotel.RoomService ON Servico.idServico=RoomService.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idProduto, hora  
				FROM gestaoHotel.Servico JOIN gestaoHotel.RoomService ON Servico.idServico=RoomService.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;

GO
--DROP FUNCTION udf_Est_DataGrid;
CREATE FUNCTION udf_Est_DataGrid(@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, lugar VARCHAR(4))
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, lugar 
				FROM gestaoHotel.Servico JOIN gestaoHotel.Estacionamento ON Servico.idServico=Estacionamento.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, lugar  
				FROM gestaoHotel.Servico JOIN gestaoHotel.Estacionamento ON Servico.idServico=Estacionamento.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;

GO
--DROP FUNCTION udf_Video_DataGrid;
CREATE FUNCTION udf_Video_DataGrid(@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, idFilme INT, hora TIME)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idFilme, hora 
				FROM gestaoHotel.Servico JOIN gestaoHotel.Video ON Servico.idServico=Video.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, idFilme, hora  
				FROM gestaoHotel.Servico JOIN gestaoHotel.Video ON Servico.idServico=Video.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;



GO
--DROP FUNCTION udf_ServExt_DataGrid;
CREATE FUNCTION udf_ServExt_DataGrid(@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT, tipoServicoExt VARCHAR(20),
	 descricao VARCHAR(50))
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipoServicoExt, descricao 
				FROM gestaoHotel.Servico JOIN gestaoHotel.ServicoExterno ON Servico.idServico=ServicoExterno.idServico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT Servico.idServico, custo, data, reserva, funcionario, tipoServicoExt, descricao   
				FROM gestaoHotel.Servico JOIN gestaoHotel.ServicoExterno ON Servico.idServico=ServicoExterno.idServico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;


GO
--DROP FUNCTION udf_Serv_DataGrid;
CREATE FUNCTION udf_Serv_DataGrid(@idServico INT=null)
RETURNS @table TABLE (idServico INT, custo MONEY, data DATE, reserva INT, funcionario INT)
WITH SCHEMABINDING
AS
BEGIN
	IF (@idServico is NULL)
		BEGIN
			INSERT @table SELECT idServico, custo, data, reserva, funcionario FROM gestaoHotel.Servico;
		END;

	ELSE
		BEGIN
			INSERT @table SELECT idServico, custo, data, reserva, funcionario FROM gestaoHotel.Servico
					WHERE gestaoHotel.Servico.idServico = @idServico
		END;
	RETURN;
END;