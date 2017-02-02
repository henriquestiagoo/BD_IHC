
use p3g4;

--a)

--DROP PROCEDURE sp_Aula11_a;
GO
CREATE PROCEDURE sp_Aula11_a
	@Ssn	INT
	AS
	IF @Ssn is NULL
	BEGIN
		PRINT 'Ssn must be not null!'
		RETURN
	END
	---------------------------------------------------------
	--check if the employee is a department manager
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(Mgr_ssn) FROM aula6_empresa.department WHERE Mgr_ssn = @Ssn
	IF @COUNT != 0
		BEGIN 
			UPDATE aula6_empresa.department SET Mgr_ssn = NULL WHERE Mgr_ssn = @Ssn;
		END 
	---------------------------------------------------------	
	BEGIN TRY	
		DELETE FROM aula6_empresa.works_on WHERE Essn = @Ssn;
		DELETE FROM aula6_empresa.dependent WHERE Essn = @Ssn;
		DELETE FROM aula6_empresa.employee WHERE Ssn = @Ssn;
	END TRY
	BEGIN CATCH
		RAISERROR ('Erro durante a alinea a).', 14, 1)
	END CATCH


--b)

--Crie um stored procedure que retorne um record-set com os funcionários gestores
--de departamentos, assim como o ssn e número de anos (como gestor) do
--funcionário mais antigo dessa lista.

--DROP PROCEDURE sp_Aula11_b;
GO
CREATE PROCEDURE sp_Aula11_b 
AS
	DECLARE @tmpTable TABLE("Essn" int, "Years" int)
	INSERT @tmpTable SELECT Mgr_ssn, DATEDIFF(YEAR, Mgr_start_date, GETDATE())
				FROM aula6_empresa.department WHERE Mgr_ssn is not null;
	-------------------------------------------------------------------------------
	SELECT Fname, Lname, Dname, Mgr_ssn, Mgr_start_date FROM aula6_empresa.employee
		JOIN aula6_empresa.department ON Ssn=Mgr_Ssn;
	-------------------------------------------------------------------------------
	DECLARE @MAX INT
	SELECT @MAX = MAX(Years) FROM @tmpTable
	SELECT TOP 1 Essn, Years FROM @tmpTable WHERE Years = @MAX

--EXEC sp_Aula11_b;

--c)

--Construa um trigger que não permita que determinado funcionário seja definido
--como gestor de mais do que um departamento.
--DROP TRIGGER trigger_exc;
GO
CREATE TRIGGER trigger_exc ON aula6_empresa.department
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON;
	DECLARE @COUNT AS INT
	SELECT @COUNT = COUNT(*) FROM aula6_empresa.employee JOIN aula6_empresa.department ON Ssn=Mgr_ssn
		JOIN inserted ON aula6_empresa.department.Mgr_ssn=inserted.Mgr_ssn;
		IF @COUNT > 1
			BEGIN
				RAISERROR ('O Funcionário já é gestor de um departamento!', 14, 1)
				ROLLBACK TRAN;
			END

--GO
--UPDATE aula6_empresa.department SET Mgr_ssn = 21312332 WHERE Dnumber = 5;

--d)

-- Crie um trigger que não permita que determinado funcionário tenha um vencimento superior ao vencimento 
-- do gestor do seu departamento. Nestes casos, o trigger deve ajustar o salário do funcionário para um 
-- valor igual ao salário do gestor menos uma unidade.
GO
CREATE TRIGGER trigger_exd ON aula6_empresa.employee
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON;
	DECLARE @MAXSAL INT;
	SELECT @MAXSAL = aula6_empresa.employee.Salary FROM aula6_empresa.employee JOIN (aula6_empresa.department 
		JOIN inserted ON aula6_empresa.department.Dnumber=inserted.Dno) 
			ON aula6_empresa.employee.Ssn=aula6_empresa.department.Mgr_ssn;
	DECLARE @SAL INT;
	DECLARE @Ssn INT
	SELECT @Ssn = inserted.Ssn, @SAL = inserted.Salary FROM inserted;
	IF @SAL >= @MAXSAL
	BEGIN
		 UPDATE aula6_empresa.employee SET Salary = @MAXSAL-1 WHERE aula6_empresa.employee.Ssn = @Ssn;
	END;

--GO
--UPDATE aula6_empresa.employee SET Salary = 1400 WHERE Ssn = 12652121;

--e)
	
-- Crie uma UDF que, para determinado funcionário (ssn), devolva o nome e
-- localização dos projetos em que trabalha.
--DROP FUNCTION udf_Aula11_ex1e;
GO
CREATE FUNCTION udf_Aula11_ex1e(@Ssn INT=null) 
RETURNS @table TABLE(Essn INT, Pname VARCHAR(30), Plocation VARCHAR(30))
AS
BEGIN
	IF (@Ssn is null)
		BEGIN
			RETURN;
		END
	ELSE
		BEGIN
			INSERT @table SELECT Essn, Pname, Plocation FROM aula6_empresa.works_on JOIN aula6_empresa.project ON Pno=Pnumber
				WHERE Essn = @Ssn;
		END
	RETURN;
END;

--GO
--SELECT * FROM udf_Aula11_ex1e(41124234);

--f)
--Crie uma UDF que, para determinado departamento, retorne os funcionários com um vencimento 
-- superior à média dos vencimentos desse departamento, ordenados pelo vencimento;
--DROP FUNCTION udf_Aula11_ex1f;
GO
CREATE FUNCTION udf_Aula11_ex1f(@Dnumber INT=null) 
RETURNS @table TABLE(Fname VARCHAR(30), Lname VARCHAR(30), Ssn INT, Salary INT)
AS
BEGIN
	DECLARE @MEDIASAL INT
	SELECT @MEDIASAL = AVG(Salary) FROM aula6_empresa.department JOIN aula6_empresa.employee ON Dno=Dnumber
		WHERE Dnumber=@Dnumber;
	-------------------------------------------------------------------------------------------------
	BEGIN
		INSERT @table SELECT Fname, Lname, Ssn, Salary FROM aula6_empresa.employee
			WHERE Dno=@Dnumber AND Salary > @MEDIASAL ORDER BY Salary;
		RETURN;
	END;
END;

--GO
--SELECT * FROM udf_Aula11_ex1f(2);

--g)

-- Crie uma UDF que, para determinado departamento, retorne um record-set com os projetos desse departamento. 
-- Para cada projeto devemos ter um atributo com seu o orçamento mensal de mão de obra e outra coluna com o 
-- valor acumulado do orcamento. 
GO
CREATE FUNCTION udf_Aula11_ex1g(@Dnumber INT=null) 
RETURNS @table TABLE(Pname VARCHAR(30), Pnumber INT, Plocation VARCHAR(30), DNUM INT, Budget INT, Totalbudget INT)
AS
BEGIN
	DECLARE @Pname VARCHAR(30), @Pnumber INT, @Plocation VARCHAR(30), @Dnum INT, @Budget INT, @Totalbudget INT=0;
	DECLARE C CURSOR FAST_FORWARD
	FOR SELECT Pname, Pnumber, Plocation, Dnum, SUM(Hours*employee.Salary/40) as Budget
			FROM aula6_empresa.employee JOIN (aula6_empresa.works_on JOIN
					aula6_empresa.project ON works_on.Pno = project.Pnumber)
					ON employee.Ssn = works_on.Essn
			WHERE project.Dnum = @Dnumber
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
	RETURN
END;

--GO
--SELECT * FROM udf_Aula11_ex1g(3);

--h)

-- Crie um trigger que, quando se elimina um departamento, este passe para uma tabela 
-- department_deleted com a mesma estrutura da department. Caso esta tabela não exista 
-- então deve criar uma nova e só depois inserir o registo. Deve utilizar um trigger 
-- do tipo instead of. Porquê? Qual a desvantagem de utilizar um trigger after neste caso?
--DROP TRIGGER trigger_exh;
GO
CREATE TRIGGER trigger_exh ON aula6_empresa.department
INSTEAD OF DELETE
AS	
	SET NOCOUNT ON;
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'aula6_empresa' AND TABLE_NAME = 'department_deleted'))
		BEGIN
			DECLARE @COUNT INT
			DECLARE @DDnumber INT
			SELECT @DDnumber=Dnumber FROM deleted
			SELECT @COUNT = COUNT(Dnumber) FROM aula6_empresa.department_deleted WHERE Dnumber=@DDnumber
			IF @COUNT=0
				INSERT INTO aula6_empresa.department_deleted SELECT * FROM deleted;
			SELECT * FROM aula6_empresa.department_deleted;
		END;
	ELSE
		BEGIN
			CREATE TABLE aula6_empresa.department_deleted (
				Dname			VARCHAR(30) NOT NULL,
				Dnumber			INT	PRIMARY KEY,
				Mgr_ssn			INT,
				Mgr_start_date	DATE,
				FOREIGN KEY(Mgr_ssn) REFERENCES aula6_empresa.employee(Ssn))
			INSERT INTO aula6_empresa.department_deleted SELECT * FROM deleted;
			SELECT * FROM aula6_empresa.department_deleted;
		END;

--GO
--DELETE FROM aula6_empresa.department WHERE Dnumber=3;