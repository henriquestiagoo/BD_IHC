

--10_3

--a)
--i. - O funcionário com determinado número ssn;
CREATE INDEX IxEmpSsn ON Employee(Ssn);

--ii. - O(s) funcionário(s) com determinado primeiro e último nome;
CREATE INDEX IxName ON Employee(Fname,Lname);

--iii. Os funcionários que trabalham para determinado departamento;
CREATE INDEX IxEmpDep ON Employee(Dno);

--iv. Os funcionários que trabalham para determinado projeto;
CREATE INDEX IxWOProj ON Works_On(Pno);

--v. Os dependentes de determinado funcionário;
CREATE INDEX IxDeEmp ON Dependent(Essn);

--vi. Os projetos associados a determinado departamento;
CREATE INDEX IxProDep ON Project(Dnum);

