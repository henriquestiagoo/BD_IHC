
use p3g4;

-- 5.1-a)
--Obtenha uma lista contendo os projetos e funcion�rios (ssn e nome completo) que l� trabalham
SELECT Pname,Pnumber,Fname,Lname,Ssn FROM ((aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno) JOIN aula6_empresa.employee ON Essn=Ssn)

-- 5.1 b)
--Obtenha o nome de todos os funcion�rios supervisionados por �Carlos D Gomes�
SELECT Fname,Minit,Lname FROM aula6_empresa.employee WHERE Super_ssn=	 (SELECT Ssn FROM aula6_empresa.employee WHERE Fname='Carlos' and Minit='D' and Lname='Gomes')

-- 5.1 c)
--Para cada projeto, listar o seu nome e o n�mero de horas (por semana) gastos nesse projeto por todos os funcion�rios
SELECT Pname,sum(Hours) AS Nr_Hours FROM aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno GROUP BY Pname

-- 5.1 d)
--Obter o nome de todos os funcion�rios do departamento 3 que trabalham mais de 20 horas por semana no projeto �Aveiro Digital�
SELECT Fname,Minit,Lname FROM (aula6_empresa.employee JOIN ( aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno ) ON Ssn=Essn) WHERE Dno=3 and Hours>20 and Pname='Aveiro Digital'

-- 5.1 e)
--Nome dos funcion�rios que n�o trabalham para projetos
SELECT Fname,Minit,Lname, Pno FROM aula6_empresa.employee FULL OUTER JOIN aula6_empresa.works_on ON Ssn=Essn GROUP BY employee.Fname,employee.Minit,employee.Lname,works_on.Pno HAVING Pno IS NULL

-- 5.1 f)
--Para cada departamento, listar o seu nome e o sal�rio m�dio dos seus funcion�rios do sexo feminino
SELECT Dno,Dname,AVG(Salary) AS avg_Salary_Feminine FROM (aula6_empresa.employee JOIN aula6_empresa.department ON Dno=Dnumber) GROUP BY Dno,Dname,Sex HAVING Sex='F' or Sex='f' 

-- 5.1 g)
--Obter uma lista de todos os funcion�rios com mais do que dois dependentes
SELECT Ssn,Fname,Minit,Lname,count(Essn) AS Dependentes FROM aula6_empresa.employee JOIN aula6_empresa.dependent ON Ssn=Essn GROUP BY Ssn,Fname,Minit,Lname,Essn HAVING count(Essn)>2 

-- 5.1 h)
--Obtenha uma lista de todos os funcion�rios gestores de departamento que n�o t�m dependentes
SELECT Ssn,Fname,Minit,Lname,Mgr_ssn,count(Essn) AS Dependents FROM aula6_empresa.employee JOIN (aula6_empresa.department FULL OUTER JOIN aula6_empresa.dependent ON Mgr_ssn=Essn) ON Ssn=Mgr_ssn GROUP BY Ssn,Fname,Minit,Lname,Essn,Mgr_ssn HAVING Mgr_ssn IS NOT NULL AND count(Essn) =0 

-- 5.1 i)
--Obter os nomes e endere�os de todos os funcion�rios que trabalham em, pelo menos, um projeto localizado em Aveiro mas o seu departamento n�o tem nenhuma localiza��o em Aveiro
SELECT Fname,Minit,Lname,Address FROM aula6_empresa.employee JOIN (aula6_empresa.works_on JOIN (aula6_empresa.project JOIN aula6_empresa.dept_locations ON Dnum=Dnumber) ON Pno=Pnumber) ON Ssn=Essn GROUP BY Fname,Minit,Lname,Address,Plocation,Dlocation HAVING Plocation='Aveiro' AND Dlocation!='Aveiro' 

