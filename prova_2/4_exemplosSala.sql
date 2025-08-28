/*
    Os primeiros exemplos estão no arquivo apresentacaoComandos.sql e são apenas para introduzir comandos SQL.

    Os exemplos que estão nesse arquivo são para praticar o que foi visto em aula.
*/

/* ===== Manipulação de Dados ===== */

-- Exemplo 03: Recupere todos os Nomes e Matriculas de todos os empregados que trabalham no departamento 2.
SELECT Nome, Matricula
FROM Empregado
WHERE CodDepartamento = 2;

-- Exemplo 04: Recupere a Matricula e o Nome dos empregados que trabalham no departamento 2 e ganham mais de 2000.
SELECT Matricula, Nome
FROM Empregado
WHERE CodDepartamento = 2 AND Salario > 2000;

-- Exemplo 05: Recupere a Matricula e Nome de todos os empregados.
SELECT Matricula, Nome
FROM Empregado;

-- Exemplo 06: Recupere todas as informações dos empregados que trabalham no departamento 2.
SELECT *
FROM Empregado
WHERE CodDepartamento = 2;

-- Exemplo 07: Calcule como ficaria o Salario dos empregados se eles recebessem um aumento de 15%.
SELECT Matricula, Nome, Salario, Salario * 1.15 AS NovoSalario Diferenca NovoSalario - Salario
FROM Empregado;

-- Exemplo 08: Recupere os Nomes dos empregados que trabalham no departamento de Vendas.
SELECT E.Nome
FROM Empregado E, Departamento D
WHERE E.CodDepartamento = D.Codigo AND D.Nome = 'Vendas';

/* ===== Comparações com Valores Nulos ===== */

-- Exemplo 09: Recupere o Nome dos empregados que não possuem supervisor.
SELECT Nome
FROM Empregado
WHERE Supervisor IS NULL;

/* ===== Usando tabelas como conjuntos ===== */
    -- > por padrão, tabelas são tratadas como multiconjuntos
    -- > usando DISTINCT, tratamos a tabela como um conjunto, descartando duplicatas
    -- > se usarmos DISTINCT em duas colunas, a combinação dessas colunas deve ser única, e a combinação das colunas que sejam duplicadas serão descartadas

-- Exemplo 10: Recupere a Matricula dos empregados que trabalham em algum projeto da empresa.

SELECT DISTINCT Empregado
FROM TrabalhaProjeto;

/* ===== Operações de Conjunto ===== */
    -- UNION, INTERSECT, EXCEPT
    -- por padrão, tratam os resultados como multiconjuntos
    -- usar UNION ALL, INTERSECT ALL, EXCEPT ALL para tratar como multiconjuntos
    -- se o nome das colunas forem diferentes, o SGBD atribui nomes da coluna da primeira tabela
    -- se colocarmos UNION ALL aparecerão todos os resultados, mesmo que sejam duplicados

-- Exemplo 11: Recupere a Matricula dos empregados que trabalham no departamento 1 e que trabalham em algum projeto da empresa.
SELECT Matricula
FROM Empregado
WHERE CodDepartamento = 1
    UNION
SELECT Empregado
FROM TrabalhaProjeto;

-- Exemplo 12: Recupere a Matricula de todos os empregados que trabalham no departamento 2 e que tem dependentes.
SELECT Matricula
FROM Empregado
WHERE CodDepartamento = 2
    INTERSECT
SELECT Empregado
FROM Dependente;

-- Exemplo 13: Recupere a Matricula de todos os empregados que não tem dependentes.
SELECT Matricula
FROM Empregado
    EXCEPT
SELECT Empregado
FROM Dependente;

/* ===== Busca por Sub-strings ===== */
    -- usar LIKE para buscar por sub-strings | usar ILIKE para não diferenciar maiúsculas de minúsculas
    -- % representa qualquer sequência de caracteres (inclusive vazia)
    -- _ representa um único caractere

    --> Exemplos genéricos:
    -- WHERE Nome LIKE 'Maria%' -> nomes que começam com 'Maria' e podem quaisquer caracteres depois
    -- WHERE Nome LIKE '%Maria' -> nomes que terminam com 'Maria' e podem quaisquer caracteres antes
    -- WHERE Nome LIKE '%Maria%' -> nomes que contém 'Maria' em qualquer posição
    -- WHERE Nome LIKE '_a___' -> nomes que contém 5 caracteres e o segundo caractere é 'a'
    -- WHERE Nome LIKE '_a%' -> nomes que tem pelo menos 2 caracteres e o segundo caractere é 'a'

/* ===== Ordenar resultados ===== */
    -- usar ORDER BY para ordenar resultados
    -- por padrão, ordena em ordem crescente (ASC)
    -- usar DESC para ordenar em ordem decrescente

-- Exemplo 14: Recupere os dados dos empregados que trabalham no departamento 2, ordenando decrescentemente pelo Salario e, em caso de empate, ordene crescentemente pelo Nome.
SELECT *
FROM Empregado
WHERE CodDepartamento = 2
ORDER BY Salario DESC, Nome ASC;

/* ===== Consultas Aninhadas ===== */
    -- consultas aninhadas são consultas dentro de outras consultas
    -- podem ser usadas em qualquer lugar onde uma expressão é permitida
    -- a consulta aninhada deve retornar apenas uma coluna, para isso usamos =, <>, <, >, <=, >=
    -- a consulta aninhada pode retornar mais de um valor se usada com operadores de conjunto (IN, ANY, ALL)

-- Exemplo 15: Recupere o Nome e a Matricula dos empregados que trabalham no departamento que Carlos gerencia.
SELECT Nome, Matricula
FROM Empregado
WHERE CodDepartamento = (
    SELECT CodDepartamento
    FROM Empregado
    WHERE Nome = 'Carlos'
);

-- Exemplo 16: Recupere o Nome dos empregados que estão trabalhando em algum projeto da empresa.
SELECT Nome
FROM Empregado
WHERE Matricula IN (
    SELECT Empregado
    FROM TrabalhaProjeto
)
ORDER BY Nome ASC
;

-- Exemplo 17: Recupere o Nome dos funcionários que ganham mais que Maria e Sérgio.
SELECT Nome
FROM Empregado
WHERE Salario > ALL (
    SELECT Salario
    FROM Empregado
    WHERE Nome IN ('Maria', 'Sérgio')
);

-- Exemplo 18: Recupere o Nome de todos os empregados do departamento 1 que ganham mais que algum empregado do departamento 2.
SELECT Nome
FROM Empregado
WHERE CodDepartamento = 1 AND Salario > SOME (
    SELECT DISTINCT Salario
    FROM Empregado
    WHERE CodDepartamento = 2
);

/* ===== Consultas Aninhadas Correlacionadas ===== */
    -- consultas correlacionadas são consultas aninhadas que fazem referência a colunas da consulta externa
    -- a consulta aninhada é executada para cada linha da consulta externa
    -- operadores: existem (EXISTS) e não existem (NOT EXISTS)

-- Exemplo 19: Recupere o Nome dos empregados que possuem algum dependente.
SELECT Nome
FROM Empregado E
WHERE EXISTS (
    SELECT *
    FROM Dependente D
    WHERE D.Empregado = E.Matricula
);

-- Exemplo 20: Recupere o Nome dos empregados que não estão alocados em nenhum projeto da empresa.
SELECT E.Nome
FROM Empregado E
WHERE NOT EXISTS (
    SELECT *
    FROM TrabalhaProjeto TP
    WHERE TP.Empregado = E.Matricula
);

-- Exemplo 21: Recupere de todos os gerentes que não estão alocados em nenhum projeto da empresa.
SELECT E.Nome
FROM Empregado E
WHERE EXISTS (
    SELECT *
    FROM Departamento D
    WHERE D.Gerente = E.Matricula
) AND NOT EXISTS (
    SELECT *
    FROM TrabalhaProjeto TP
    WHERE TP.Empregado = E.Matricula
);

-- Exemplo 22: Recupere o Nome dos empregados que não gerenciam nenhum departamento.
SELECT E.Nome
FROM Empregado E
WHERE NOT EXISTS (
    SELECT *
    FROM Departamento D
    WHERE D.Gerente = E.Matricula
)
AND E.CodDepartamento = 1; -- para que os empregados sejam do departamento 1

-- Exemplo 23: Recupere o Nome dos empregados que trabalham no departamento de Vendas.
SELECT E.Nome
FROM Empregado E
WHERE EXISTS (
    SELECT *
    FROM Departamento D
    WHERE E.CodDepartamento = D.CodDepartamento AND D.Nome = 'Vendas'
);

/* ===== JUNÇÕES ===== */
    -- operadores: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
    -- a condição de junção é especificada no FROM

/* ===== Equijunção (junção natural) ===== */
    -- operador: INNER JOIN
    -- a condição fica no FROM
    -- a condição de junção é uma igualdade entre colunas de duas tabelas com o mesmo nome

-- Exemplo 24: Recupere o Nome dos empregados que trabalham no departamento de Finanças.
SELECT E.Nome
FROM Empregado E INNER JOIN Departamento D
    ON E.CodDepartamento = D.CodDepartamento
WHERE D.Nome = 'Finanças';