
use p3g4;

--a) Construa um stored procedure que aceite o ssn de um funcionário, que o remova da tabela de funcionários, 
-- que remova as suas entradas da tabela works_on e que remova ainda os seus dependentes. 
-- Que preocupações adicionais devem ter no storage procedure para além das referidas anteriormente?
--DROP PROC aula11_exa;
GO
CREATE PROC aula11_exa @Ssn INT
AS
BEGIN
	IF @Ssn is NULL
	BEGIN
		PRINT 'Ssn must be not null!'
		RETURN
	END
	------------------------------------------------------------------------------------
	-- check if the employee is a department manager
	DECLARE @COUNT INT
	SELECT @COUNT=COUNT(*) FROM aula6_empresa.department WHERE Mgr_Ssn=@Ssn;
	IF @COUNT != 0
		BEGIN
			UPDATE aula6_empresa.department SET Mgr_Ssn = Null WHERE Mgr_Ssn=@Ssn;
		END;
	------------------------------------------------------------------------------------
	BEGIN TRY
		DELETE FROM aula6_empresa.works_on WHERE Essn=@Ssn;
		DELETE FROM aula6_empresa.dependent WHERE Essn = @Ssn; 
		DELETE FROM aula6_empresa.employee WHERE Ssn=@Ssn;

	END TRY
	BEGIN CATCH
		RAISERROR('Erro durante o procedimento aula11_exa!',14,1)
	END CATCH
END;


-- a) Construa um stored procedure que aceite o ssn de um funcionário, que o remova da tabela de funcionários, 
-- que remova as suas entradas da tabela works_on e que remova ainda os seus dependentes. 
-- Que preocupações adicionais devem ter no storage procedure para além das referidas anteriormente? 
CREATE PROC aula11_ex1a (@Ssn INT)
AS
BEGIN
	IF @Ssn is NULL
	BEGIN
		PRINT 'Ssn must be not null!'
		RETURN;
	END
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(Mgr_Ssn) FROM aula6_empresa.department WHERE Mgr_Ssn = @Ssn;
	IF COUNT != 0
		BEGIN
			UPDATE aula6_empresa.department SET Mgr_Ssn = null WHERE Mgr_Ssn = @Ssn
		END;
	ELSE
		BEGIN TRY
			DELETE FROM aula6_empresa.works_on WHERE Essn = @Ssn;
			DELETE FROM aula6_empresa.dependent WHERE Essn = @Ssn; 
			DELETE FROM aula6_empresa.employee WHERE Ssn=@Ssn;
		END TRY;
		BEGIN CATCH
			RAISERROR('Error during exa',14,1)
		END CATCH;
END;


-- b) Crie um stored procedure que retorne um record-set com os funcionários gestores de departamentos, 
-- assim como o ssn e número de anos (como gestor) do funcionário mais antigo dessa lista.
-- DROP PROC aula11_exb;
GO
CREATE PROC aula11_exb 
AS
BEGIN
	DECLARE @tmpTable TABLE(SSsn INT, Years INT);
	INSERT INTO @tmpTable SELECT Mgr_Ssn, DATEDIFF(YEAR, Mgr_start_date, GETDATE()) AS Years FROM aula6_empresa.department
		WHERE Mgr_Ssn is not null;
	------------------------------------------------------------------------------------------------------------------------------
	SELECT Fname, Lname, Ssn, Dname, Dno, Mgr_start_date FROM aula6_empresa.department JOIN aula6_empresa.employee ON Mgr_Ssn=Ssn;
	SELECT TOP 1 SSSn, Years FROM @tmpTable ORDER BY Years DESC;
END;

-- EXEC aula11_exb;

-- b) Crie um stored procedure que retorne um record-set com os funcionários gestores de departamentos, 
-- assim como o ssn e número de anos (como gestor) do funcionário mais antigo dessa lista.
-- DROP PROC aula11_exb;
GO
CREATE PROC aula11_exb
AS
BEGIN
	DECLARE @tmpTable TABLE(Ssn INT, Years INT)
	INSERT INTO @tmpTable SELECT Ssn, DATEDIFF(YEAR, Mgr_start_date, GETDATE()) AS Years FROM aula6_empresa.department;
	---------------------------------------------------------------------------------------------------------------------
	SELECT Fname, Lname, Ssn, Dname, Dnumber FROM aula6_empresa.employee JOIN aula6_empresa.department ON Ssn=Mgr_ssn;
	SELECT TOP 1 Ssn,Years FROM @tmpTable ORDER BY Years DESC;
END;


-- c) Construa um trigger que não permita que determinado funcionário 
-- seja definido como gestor de mais do que um departamento.
-- DROP TRIGGER trigger_exc2;
GO
CREATE TRIGGER trigger_exc2 ON aula6_empresa.department
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(department.Mgr_Ssn) FROM aula6_empresa.department JOIN inserted ON department.Mgr_Ssn=inserted.Mgr_Ssn;
	IF @COUNT > 0
		BEGIN
			RAISERROR('Um funcionário só pode ser gestor de um departamento',16,1);
			ROLLBACK TRAN;
		END;
END;

--GO
--UPDATE aula6_empresa.department SET Mgr_ssn = 21312332 WHERE Dnumber = 5;

-- c) Construa um trigger que não permita que determinado funcionário 
-- seja definido como gestor de mais do que um departamento.
-- DROP TRIGGER trigger_exc2;
CREATE TRIGGER trigger_exc ON aula6_empresa.department
AFTER UPDATE, INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(department.Mgr_ssn) FROM aula6_empresa.department JOIN inserted ON Mgr_ssn=inserted.Mgr_ssn;
	IF COUNT != 0
		BEGIN
			RAISERROR('Func only can be one department manager!',14,1)
			ROLLBACK TRAN;
		END;
END;




-- d) Crie um trigger que não permita que determinado funcionário tenha um vencimento superior ao vencimento 
-- do gestor do seu departamento. Nestes casos, o trigger deve ajustar o salário do funcionário para um valor 
-- igual ao salário do gestor menos uma unidade.  
CREATE TRIGGER trigger_exd2 ON aula6_empresa.employee
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MAXSAL INT
	SELECT @MAXSAL = Salary FROM aula6_empresa.employee JOIN (aula6_empresa.department JOIN inserted ON 
	department.Dnumber=inserted.Dno) ON Mgr_Ssn=Ssn;
	----------------------------------------------------------------------------------------------------
	DECLARE @SAL INT
	DECLARE @SSN INT
	SELECT @SSN = Ssn, @SAL = Salary FROM inserted;
	IF @SAL >= @MAXSAL
	BEGIN
		UPDATE aula6_empresa.employee SET Salary = @MAXSAL-1 WHERE Ssn=@Ssn;
	END;
END;

--GO
--UPDATE aula6_empresa.employee SET Salary = 1400 WHERE Ssn = 12652121;

-- d) Crie um trigger que não permita que determinado funcionário tenha um vencimento superior ao vencimento 
-- do gestor do seu departamento. Nestes casos, o trigger deve ajustar o salário do funcionário para um valor 
-- igual ao salário do gestor menos uma unidade.  
CREATE TRIGGER trigger_exd ON aula6_empresa.employee
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MAXSAL INT
	SELECT @MAXSAL = Salary FROM aula6_empresa.employee JOIN (aula6_empresa.department 
		JOIN inserted ON department.Dnumber=inserted.Dno) ON Ssn=Mgr_ssn;
	DECLARE @SSN INT
	DECLARE @SAL INT
	SELECT @SSN = Ssn, @SAL = Salary FROM inserted;
	IF @SAL > @MAXSAL
		BEGIN
			UPDATE aula6_employee SET Salary = @MAXSAL-1 WHERE Ssn=@SSN;
		END;
END;


-- e) Crie uma UDF que, para determinado funcionário (ssn), devolva o nome e 
-- localização dos projetos em que trabalha.
--DROP FUNCTION udf_exe;
GO
CREATE FUNCTION udf_exe (@Ssn INT=null)
RETURNS @table TABLE(Ssn INT, Pname VARCHAR(30), Plocation VARCHAR(30))
AS
BEGIN
	IF @Ssn is null
	BEGIN
		RETURN;
	END;
	ELSE
		BEGIN
			INSERT INTO @table SELECT Essn, Pname, Plocation FROM aula6_empresa.works_on JOIN aula6_empresa.project ON Pno=Pnumber
				WHERE Essn=@Ssn;
		END;
		RETURN;
END;

--GO
--SELECT * FROM udf_exe(41124234);

-- e) Crie uma UDF que, para determinado funcionário (ssn), devolva o nome e 
-- localização dos projetos em que trabalha.
--DROP FUNCTION udf_exe;
GO
CREATE FUNCTION udf_exe2 (@Ssn INT) 
RETURNS TABLE
AS
	RETURN (SELECT Pname, Plocation FROM aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno WHERE Essn=@Ssn);

-- SELECT * FROM udf_exe2(41124234);

-- f) Crie uma UDF que, para determinado departamento (dno), retorne os funcionários 
-- com um vencimento superior à média dos vencimentos desse departamento; 
-- DROP FUNCTION udf_exf;
GO
CREATE FUNCTION udf_exf(@Dno INT=null)
RETURNS @table TABLE(Ssn INT, Fname VARCHAR(30), Lname VARCHAR(30), Salary INT)
AS
BEGIN
	IF @Dno is null
		BEGIN
			RETURN;
		END;
	ELSE
		DECLARE @AVGSAL INT
		BEGIN
			SELECT @AVGSAL = AVG(Salary) FROM aula6_empresa.employee WHERE Dno=@Dno;
			INSERT INTO @table SELECT Ssn, Fname, Lname, Salary FROM aula6_empresa.employee 
				WHERE Dno=@Dno AND Salary>@AVGSAL ORDER BY Salary;
		END;
		RETURN;
END;

--GO
--SELECT * FROM udf_exf(2);


-- f) Crie uma UDF que, para determinado departamento (dno), retorne os funcionários 
-- com um vencimento superior à média dos vencimentos desse departamento; 
-- DROP FUNCTION udf_exf;
CREATE FUNCTION aula11_exf (@Dnumber INT=null)
RETURNS @table TABLE (Ssn INT, Fname VARCHAR(30), Lname VARCHAR(30), Salary INT)
AS
BEGIN
	IF @Dnumber is null
		BEGIN
			RETURN;
		END;
	DECLARE @AVGSAL INT
	SELECT @AVGSAL = AVG(Salary) FROM aula6_empresa.employee WHERE Dnumber=@Dnumber;
	INSERT INTO @table SELECT Ssn, Fname, Lname, Salary FROM aula6_empresa.employee
		WHERE Dno = @Dnumber AND Salary > @AVGSAL ORDER BY Salary;
	RETURN;
END;

-- g) Crie uma UDF que, para determinado departamento, retorne um record-set 
-- com os projetos desse departamento. Para cada projeto devemos ter um atributo com seu o 
-- orçamento mensal de mão de obra e outra coluna com o valor acumulado do orcamento. 
GO
CREATE FUNCTION udf_exg(@Dnumber INT=null)
RETURNS @table TABLE(Pname VARCHAR(30), Pnumber INT, Plocation VARCHAR(30), Dnum INT, Budget INT, TotalBudget INT)
AS
BEGIN
	IF @Dnumber is null
		BEGIN
			RETURN;
		END;
	ELSE
		BEGIN
			DECLARE @Pname VARCHAR(30), @Pnumber INT, @Plocation VARCHAR(30), @Dnum INT, @Budget INT, @Totalbudget INT=0;
			DECLARE C CURSOR FAST_FORWARD
			FOR SELECT Pname, Pnumber, Plocation, Dnum, SUM(Hours*employee.Salary/40) as Budget 
				FROM aula6_empresa.employee JOIN (aula6_empresa.works_on JOIN
					aula6_empresa.project ON Pno=Pnumber) ON Ssn=Essn WHERE Dnum=@Dnumber
						GROUP BY project.Pname, project.Pnumber, project.Plocation, project.Dnum;
			OPEN C;
			FETCH C INTO @Pname, @Pnumber, @Plocation, @Dnum, @Budget;
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @Totalbudget += @Budget;
					INSERT INTO @table(Pname, Pnumber, Plocation, Dnum, Budget, Totalbudget)
						VALUES (@Pname, @Pnumber, @Plocation, @Dnum, @Budget, @Totalbudget);
					FETCH C INTO @Pname, @Pnumber, @Plocation, @Dnum, @Budget;
				END;
			CLOSE C;
		END;
		RETURN;
END;

--GO
--SELECT * FROM udf_exg(3);

-- h) Crie um trigger que, quando se elimina um departamento, este passe para uma tabela 
-- department_deleted com a mesma estrutura da department. Caso esta tabela não exista 
-- então deve criar uma nova e só depois inserir o registo. Deve utilizar um trigger 
-- do tipo instead of. Porquê? Qual a desvantagem de utilizar um trigger after neste caso?
--DROP TRIGGER trigger_exh;
GO
CREATE TRIGGER trigger_exh2 ON aula6_empresa.department
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'aula6_empresa' AND TABLE_NAME = 'department_deleted'))
		BEGIN
			INSERT INTO aula6_empresa.department_deleted SELECT * FROM deleted;
			SELECT * FROM aula6_empresa.department_deleted;
		END;
	ELSE
		BEGIN
			CREATE TABLE aula6_empresa.department_deleted(
				Dname	VARCHAR(30) NOT NULL,
				Dnumber INT PRIMARY KEY,
				Mgr_Ssn INT,
				Mgr_start_date DATE,
				FOREIGN KEY(Mgr_Ssn) REFERENCES aula6_empresa.employee(Ssn))
				INSERT INTO aula6_empresa.department_deleted SELECT * FROM deleted;
				SELECT * FROM aula6_empresa.department_deleted;
		END;
END;

--GO
--DELETE FROM aula6_empresa.department WHERE Dnumber=3;