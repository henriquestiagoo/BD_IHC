
use p3g4;

-- 5.1-a)
--Obtenha uma lista contendo os projetos e funcionários (ssn e nome completo) que lá trabalham
SELECT Pname,Pnumber,Fname,Lname,Ssn FROM ((aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno) JOIN aula6_empresa.employee ON Essn=Ssn)

-- 5.1 b)
--Obtenha o nome de todos os funcionários supervisionados por ‘Carlos D Gomes’
SELECT Fname,Minit,Lname FROM aula6_empresa.employee WHERE Super_ssn=	 (SELECT Ssn FROM aula6_empresa.employee WHERE Fname='Carlos' and Minit='D' and Lname='Gomes')

-- 5.1 c)
--Para cada projeto, listar o seu nome e o número de horas (por semana) gastos nesse projeto por todos os funcionários
SELECT Pname,sum(Hours) AS Nr_Hours FROM aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno GROUP BY Pname

-- 5.1 d)
--Obter o nome de todos os funcionários do departamento 3 que trabalham mais de 20 horas por semana no projeto ‘Aveiro Digital’
SELECT Fname,Minit,Lname FROM (aula6_empresa.employee JOIN ( aula6_empresa.project JOIN aula6_empresa.works_on ON Pnumber=Pno ) ON Ssn=Essn) WHERE Dno=3 and Hours>20 and Pname='Aveiro Digital'

-- 5.1 e)
--Nome dos funcionários que não trabalham para projetos
SELECT Fname,Minit,Lname, Pno FROM aula6_empresa.employee FULL OUTER JOIN aula6_empresa.works_on ON Ssn=Essn GROUP BY employee.Fname,employee.Minit,employee.Lname,works_on.Pno HAVING Pno IS NULL

-- 5.1 f)
--Para cada departamento, listar o seu nome e o salário médio dos seus funcionários do sexo feminino
SELECT Dno,Dname,AVG(Salary) AS avg_Salary_Feminine FROM (aula6_empresa.employee JOIN aula6_empresa.department ON Dno=Dnumber) GROUP BY Dno,Dname,Sex HAVING Sex='F' or Sex='f' 

-- 5.1 g)
--Obter uma lista de todos os funcionários com mais do que dois dependentes
SELECT Ssn,Fname,Minit,Lname,count(Essn) AS Dependentes FROM aula6_empresa.employee JOIN aula6_empresa.dependent ON Ssn=Essn GROUP BY Ssn,Fname,Minit,Lname,Essn HAVING count(Essn)>2 

-- 5.1 h)
--Obtenha uma lista de todos os funcionários gestores de departamento que não têm dependentes
SELECT Ssn,Fname,Minit,Lname,Mgr_ssn,count(Essn) AS Dependents FROM aula6_empresa.employee JOIN (aula6_empresa.department FULL OUTER JOIN aula6_empresa.dependent ON Mgr_ssn=Essn) ON Ssn=Mgr_ssn GROUP BY Ssn,Fname,Minit,Lname,Essn,Mgr_ssn HAVING Mgr_ssn IS NOT NULL AND count(Essn) =0 

-- 5.1 i)
--Obter os nomes e endereços de todos os funcionários que trabalham em, pelo menos, um projeto localizado em Aveiro mas o seu departamento não tem nenhuma localização em Aveiro
SELECT Fname,Minit,Lname,Address FROM aula6_empresa.employee JOIN (aula6_empresa.works_on JOIN (aula6_empresa.project JOIN aula6_empresa.dept_locations ON Dnum=Dnumber) ON Pno=Pnumber) ON Ssn=Essn GROUP BY Fname,Minit,Lname,Address,Plocation,Dlocation HAVING Plocation='Aveiro' AND Dlocation!='Aveiro' 

