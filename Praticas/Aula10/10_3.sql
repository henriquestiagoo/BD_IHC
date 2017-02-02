

--10_3

--a)
--i. - O funcion�rio com determinado n�mero ssn;
CREATE INDEX IxEmpSsn ON Employee(Ssn);

--ii. - O(s) funcion�rio(s) com determinado primeiro e �ltimo nome;
CREATE INDEX IxName ON Employee(Fname,Lname);

--iii. Os funcion�rios que trabalham para determinado departamento;
CREATE INDEX IxEmpDep ON Employee(Dno);

--iv. Os funcion�rios que trabalham para determinado projeto;
CREATE INDEX IxWOProj ON Works_On(Pno);

--v. Os dependentes de determinado funcion�rio;
CREATE INDEX IxDeEmp ON Dependent(Essn);

--vi. Os projetos associados a determinado departamento;
CREATE INDEX IxProDep ON Project(Dnum);

