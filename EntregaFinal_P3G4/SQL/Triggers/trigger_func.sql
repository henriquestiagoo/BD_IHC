

-- Crie um trigger que n�o permita que determinado funcion�rio tenha um vencimento superior ao vencimento 
-- do gestor do seu hotel. Neste caso, o trigger ajusta o sal�rio do funcion�rio para um 
-- valor igual ao sal�rio do gestor menos uma unidade.
GO
CREATE TRIGGER trigger_func_salary ON gestaoHotel.Funcionario
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON;
	DECLARE @MAXSAL INT;
	SELECT @MAXSAL = gestaoHotel.Funcionario.salario FROM gestaoHotel.Funcionario JOIN (gestaoHotel.Hotel 
		JOIN inserted ON gestaoHotel.Hotel.idHotel=inserted.hotel) 
			ON gestaoHotel.Funcionario.hotel=gestaoHotel.Hotel.idHotel;
	DECLARE @SAL INT;
	DECLARE @ID INT
	SELECT @ID = inserted.id, @SAL = inserted.salario FROM inserted;
	IF @SAL >= @MAXSAL
	BEGIN
		PRINT 'Funcion�rio n�o pode ter um sal�rio igual ou superior ao sal�rio do gerente do seu Hotel! ';
		PRINT 'O seu sal�rio ser� ajustado para uma unidade a menos que o sal�rio do gerente! ';
		UPDATE gestaoHotel.Funcionario SET salario = @MAXSAL-1 WHERE gestaoHotel.Funcionario.id = @ID;
	END;

-- N�o foi implementado porque dava erro no pr�prio gerente pois este tamb�m � um funcion�rio.
