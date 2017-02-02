

-- Crie um trigger que não permita que determinado funcionário tenha um vencimento superior ao vencimento 
-- do gestor do seu hotel. Neste caso, o trigger ajusta o salário do funcionário para um 
-- valor igual ao salário do gestor menos uma unidade.
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
		PRINT 'Funcionário não pode ter um salário igual ou superior ao salário do gerente do seu Hotel! ';
		PRINT 'O seu salário será ajustado para uma unidade a menos que o salário do gerente! ';
		UPDATE gestaoHotel.Funcionario SET salario = @MAXSAL-1 WHERE gestaoHotel.Funcionario.id = @ID;
	END;

-- Não foi implementado porque dava erro no próprio gerente pois este também é um funcionário.
