
use p3g4;

--6.1-

-- a) Todos os tuplos da tabela autores (authors); 
SELECT * FROM dbo.authors;

-- b) O primeiro nome, o último nome e o telefone dos autores;
SELECT au_fname, au_lname, phone FROM dbo.authors;

-- c) Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 
SELECT au_fname, au_lname, phone FROM dbo.authors ORDER BY au_fname, au_lname;

-- d) Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 
SELECT au_fname AS first_name, au_lname AS last_name, phone AS telephone FROM dbo.authors ORDER BY au_fname, au_lname;


-- e) Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 
SELECT au_fname AS first_name, au_lname AS last_name, phone AS telephone 
FROM dbo.authors 
WHERE state='CA' AND au_lname!='Ringer'
ORDER BY au_fname, au_lname;

-- f) Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 
SELECT * FROM dbo.publishers WHERE pub_name LIKE '%Bo%';


-- g) Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’;
SELECT DISTINCT pub_name FROM dbo.publishers JOIN dbo.titles ON publishers.pub_id=titles.pub_id WHERE type='business'; 

-- h) Número total de vendas de cada editora;
SELECT publishers.pub_id, pub_name, SUM(ytd_sales) AS vendas
FROM dbo.publishers JOIN dbo.titles ON publishers.pub_id=titles.pub_id
GROUP BY publishers.pub_id, pub_name;

-- i) Número total de vendas de cada editora agrupado por título; 
SELECT publishers.pub_id, titles.title_id, title, SUM(ytd_sales) AS num_vendas 
FROM dbo.publishers JOIN dbo.titles ON publishers.pub_id=titles.pub_id
GROUP BY publishers.pub_id, titles.title_id, title
ORDER BY publishers.pub_id;

--j) Nome dos títulos vendidos pela loja ‘Bookbeat’;
SELECT title AS titulos_vendidos_Bookbeat FROM (dbo.sales JOIN dbo.stores ON sales.stor_id=stores.stor_id) JOIN dbo.titles ON sales.title_id=titles.title_id WHERE stor_name='Bookbeat';

--k) Nome de autores que tenham publicações de tipos diferentes;
SELECT authors.au_id, au_fname, au_lname  
FROM (dbo.titleauthor JOIN dbo.authors 
ON authors.au_id=titleauthor.au_id) JOIN dbo.titles 
ON titleauthor.title_id=titles.title_id 
GROUP BY authors.au_id, au_fname, au_lname 
HAVING COUNT (DISTINCT type)>1 ;

-- l) Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id); 
SELECT type, titles.pub_id, AVG(price) AS preco_medio, COUNT(ord_num) AS nr_total_vendas 
FROM dbo.titles JOIN dbo.sales 
ON titles.title_id=sales.title_id 
GROUP BY type, titles.pub_id;

-- m) Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo); 
SELECT type, AVG(advance) AS Media_Grupo, MAX(advance) AS Max_Advance 
FROM dbo.titles 
GROUP BY type
HAVING MAX(advance) > 1.5*AVG(advance);

-- n) Obter, para cada título, nome dos autores e valor arrecadado por estes com a venda de cada livro;
SELECT title, au_fname, au_lname, SUM(qty*price) AS valor_arrecadado
FROM ((dbo.titles JOIN dbo.sales ON titles.title_id = sales.title_id) JOIN (dbo.titleauthor 
	JOIN dbo.authors ON titleauthor.au_id = authors.au_id) ON titles.title_id=titleauthor.title_id) 
GROUP BY title, au_fname, au_lname;

--o)Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;
SELECT ytd_sales,title, ytd_sales*price AS faturacao, (royalty/100.00*price*ytd_sales) 
	AS faturacaoAutores, ytd_sales*price-(royalty/100.00*price*ytd_sales) 
		AS faturacaoEditora 
FROM titles WHERE ytd_sales is NOT NULL ORDER BY ytd_sales DESC;


-- p) Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;
SELECT ytd_sales,title,au_lname+' '+ au_fname AS authors, ytd_sales*price 
	AS faturacao,(royalty/100.00*price*ytd_sales)*(royaltyper/100.00) 
		AS faturacaoAutor,ytd_sales*price-(royalty/100.00*price*ytd_sales) 
			AS faturacaoEditora FROM ((titles JOIN titleauthor ON titles.title_id=titleauthor.title_id) 
				JOIN authors ON authors.au_id=titleauthor.au_id)
					ORDER BY ytd_sales DESC;

--q) Lista de lojas que venderam pelo menos um exemplar de todos os livros;
SELECT stor_id, COUNT(title_id) AS nr_livros_difs_vendidos FROM dbo.sales
GROUP BY stor_id
HAVING COUNT(title_id) = (SELECT COUNT(title_id) AS total_livros_difs FROM dbo.titles);

-- r) Lista de lojas que venderam mais livros do que a média de todas as lojas. 
SELECT stor_id, COUNT(title_id) AS nr_livros_difs_vendidos FROM dbo.sales
GROUP BY stor_id
HAVING COUNT(title_id) > (SELECT AVG(nr_livros_difs_vendidos) FROM (
		SELECT stor_id, COUNT(title_id) AS nr_livros_difs_vendidos
		FROM dbo.sales
		GROUP BY stor_id) AS T);



-- s) Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;
SELECT title FROM (dbo.titles LEFT OUTER JOIN (SELECT title_id, sales.stor_id FROM (dbo.stores JOIN 
	dbo.sales ON stores.stor_id=sales.stor_id) WHERE stores.stor_name = 'Bookbeat') AS T 
	ON titles.title_id=T.title_id)
WHERE T.title_id is NULL
ORDER BY title; 

/*
-- t) Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora;
SELECT titles.pub_id, T.stor_id FROM (dbo.titles LEFT OUTER JOIN (
	SELECT sales.stor_id, sales.title_id FROM (dbo.sales JOIN dbo.stores ON sales.title_id=stores.stor_id)) AS T
	ON titles.title_id=T.title_id)
WHERE T.pub_id is NULL
GROUP BY titles.pub_id, stor_id;
*/