
-- use p3g4;

-- i. Nome dos títulos e nome dos respetivos autores;
CREATE VIEW Ex1 AS (
SELECT title, authors.au_fname, authors.au_lname
From (dbo.authors JOIN (dbo.titles JOIN dbo.titleauthor ON titles.title_id=titleauthor.title_id)
	ON authors.au_id=titleauthor.au_id));


-- ii. Nome dos editores e nome dos respetivos funcionários;
CREATE VIEW Ex2 AS (
SELECT publishers.pub_id, pub_name, emp_id, fname, lname
FROM dbo.publishers JOIN dbo.employee ON publishers.pub_id=employee.pub_id
GROUP BY publishers.pub_id, pub_name, emp_id, fname, lname);


-- iii. Nome das lojas e o nome dos títulos vendidos nessa loja;
CREATE VIEW Ex3 AS (
SELECT stor_name, title
FROM (dbo.titles JOIN(dbo.sales JOIN dbo.stores ON sales.stor_id=stores.stor_id) ON titles.title_id=sales.title_id)
GROUP BY stor_name, title);

-- iv. Livros do tipo ‘Business’
-- DROP VIEW Ex4;
CREATE VIEW Ex4 AS (
SELECT titles.title_id, title, type, pub_id, price, notes
FROM dbo.titles 
WHERE type ='Business'
GROUP BY titles.title_id, title, type, pub_id, price, notes);

-- b) Construa uma consulta tendo como base cada uma das views definidas na alínea a);
SELECT * FROM Ex1;
SELECT * FROM Ex2;
SELECT * FROM Ex3;
SELECT * FROM Ex4;

-- c) Altere as views i e iii da alínea a) para que se possa implementar uma consulta que
-- as utilize como fonte de dados para implementar a seguinte consulta: “Nome das
-- lojas e nome dos autores vendidos na loja”;
SELECT stor_name, au_fname+' ' + au_lname AS author 
FROM Ex1 JOIN Ex3 on Ex1.title = Ex3.title;

-- d) Relativamente à view iv da alínea a) execute o seguinte comando5:
/*
insert into Ex4 (title_id, title, type, pub_id, price, notes)
values('BDTst1', 'New BD Book','popular_comp', '1389', $30.00, 'A must-read for
DB course.')*/

-- ii. Altere a view (iv da alínea a) para corrigir o problema.
CREATE VIEW Ex4_ii (title_id, title, type, pub_id, price, notes) AS (
SELECT titles.title_id, title, type, pub_id, price, notes
FROM dbo.titles 
WHERE type ='Business');

SELECT * FROM Ex4_ii;



