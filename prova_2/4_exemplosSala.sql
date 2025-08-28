/*
    Os primeiros exemplos estão no arquivo apresentacaoComandos.sql e são apenas para introduzir comandos SQL.

    Os exemplos que estão nesse arquivo são para praticar o que foi visto em aula.

    Para os exemplos a seguir, leve como base nas tabelas a seguir:
    > Empregado (Matricula PK, Nome, Salario, Supervisor FK -> Empregado(Matricula), CodDepartamento FK -> Departamento(CodDepartamento))
    > Departamento (CodDepartamento PK, Nome, Gerente FK -> Empregado(Matricula))
    > Projeto (CodProjeto PK PK -> Projeto(CodProjeto), Nome, CodDepartamento )
    > Dependente (Empregado PK FK -> Empregado(Matricula), NomeDepartamento PK, Parentesco)
    > TrabalhaProjeto (Empregado PK FK -> Empregado(Matricula), CodProjeto PK FK -> Projeto(CodProjeto), NumHoras)
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

/* ===== Equijunção ===== */
    -- operador: INNER JOIN
    -- a condição fica no FROM
    -- sintaxe: [Tabela1] INNER JOIN [Tabela2] ON [Tabela1.Coluna = Tabela2.Coluna]
    -- sintaxe2: [Tabela1] INNER JOIN [Tabela2] ON [Tabela1.Coluna = Tabela2.Coluna] AS [novos_nomes_das_Tabela2]

-- Exemplo 24: Recupere o Nome dos empregados que trabalham no departamento financeiro.
SELECT E.Nome
FROM Empregado E INNER JOIN Departamento D
    ON E.CodDepartamento = D.CodDepartamento
WHERE D.Nome = 'Financeiro'
ORDER BY E.Nome ASC;

/* ===== Junção Natural ===== */
    -- operador: NATURAL INNER JOIN
    -- a condição de junção é feita automaticamente com base nas colunas que possuem o mesmo nome em ambas as tabelas
    -- sintaxe: [Tabela1] NATURAL INNER JOIN [Tabela2]

-- Exemplo 25: Recupere o Nome dos empregados que trabalham no departamento financeiro.
SELECT E.Nome
FROM Empregado E NATURAL INNER JOIN Departamento D AS D(CodDepartamento, Nome, Departamento, Gerente)
WHERE D.NomeDepartamento = 'Financeiro'
ORDER BY E.Nome ASC;

-- Exemplo 26: Recupere o Nome dos empregados que trabalham no departamento MaxLucro.
SELECT E.Nome
FROM TrabalhoProjeto TP NATURAL INNER JOIN Projeto P
    INNER JOIN Empregado E ON TP.Empregado = E.Matricula
WHERE P.NomeDepartamento = 'MaxLucro'

-- Exemplo 27: Relacione cada empregado com os seus respectivos dependentes.
SELECT *
FROM Empregado E INNER JOIN Dependente D
    ON E.Matricula = D.Empregado

SELECT *
FROM Empregado E LEFT OUTER JOIN Dependente D
    ON E.Matricula = D.Empregado

-- Exemplo 28: Recupere o Nome dos empregados que não possuem dependentes.
SELECT E.Nome
FROM Empregado
WHERE Matricula NOT IN (
    SELECT DISTINCT Empregado
    FROM Dependente
);

-- Exemplo 29: Recupere o Nome dos empregados do departamento 1 que ganhe mais que algum empregado do departamento 2.
SELECT E.Nome
FROM Empregado E
WHERE E.CodDepartamento = 1 AND E.Salario > SOME (
    SELECT DISTINCT Salario
    FROM Empregado
    WHERE CodDepartamento = 2
);

-- Exemplo 30: Recupere o Nome dos empregados que possuem dependentes.
SELECT E.Nome
FROM Empregado E
WHERE EXISTS (
    SELECT *
    FROM Dependente D
    WHERE D.Empregado = E.Matricula
);

-- Exemplo 31: Recupere os gerentes que não possuem dependentes.
SELECT E.Nome
FROM Empregado E
WHERE EXISTS (
    SELECT *
    FROM Departamento D
    WHERE D.Gerente = E.Matricula
) AND NOT EXISTS (
    SELECT *
    FROM Dependente Dep
    WHERE Dep.Empregado = E.Matricula
);

/* ===== Funções Agregadas ===== */
    -- funções: COUNT, SUM, AVG, MAX, MIN
        -- COUNT:
            -- COUNT(*), COUNT(coluna) --> quantidade de tuplas resultantes que não sejam iguais a NULL
            -- COUNT(DISTINCT coluna) --> quantidade de valores distintos na coluna que não sejam NULL
        -- SUM: soma dos valores da coluna
        -- AVG: média dos valores da coluna
        -- MAX: maior valor da coluna
        -- MIN: menor valor da coluna

-- Exemplo 32: Calcule quantos empregados trabalham no departamento 2.
SELECT COUNT(*) AS NumEmpregados
FROM Empregado E
WHERE E.CodDepartamento = 2;

-- Exemplo 33: Calcule a quantidade de empregados que têm supervisor.
SELECT COUNT(*) AS Total 
FROM Empregado
WHERE Supervisor IS NOT NULL;

SELECT COUNT(Supervisor) AS Total
FROM Empregado;

-- Exemplo 34: Recupere o total da folha de pagamento, o menor salário, o maior salário e a média salarial.
SELECT SUM(Salario) AS TotalFolhaPagamento,
       MIN(Salario) AS MenorSalario,
       MAX(Salario) AS MaiorSalario,
       AVG(Salario) AS MediaSalarial
FROM Empregado;

-- Exemplo 35: Qual o empregado com o menor salário?
SELECT Nome, Salario
FROM Empregado
WHERE Salario = (
    SELECT MIN(Salario)
    FROM Empregado
);

/* ===== Agrupamento de Resultados: GROUP BY ===== */
    -- agrupa os resultados com base nos valores de uma ou mais colunas
    -- para que as colunas sejam usadas no SELECT, elas devem estar no GROUP BY ou serem usadas em funções agregadas
    -- usar HAVING para filtrar grupos com base em condições

-- Exemplo 36: Para cada departamento: seu código, a quantidade de funcionários e a média salarial.
SELECT CodDepartamento, COUNT(*) AS NumFuncionarios, AVG(Salario) AS MediaSalarial
FROM Empregado
GROUP BY CodDepartamento;

-- Exemplo 37: Para cada departamento: seu código, seu nome e a quantidade de funcionários.
SELECT D.CodDepartamento, D.NomeDepartamento, COUNT(*) AS NumFuncionarios
FROM Empregado E INNER JOIN Departamento D
    ON E.CodDepartamento = D.CodDepartamento
GROUP BY D.CodDepartamento, D.NomeDepartamento;

-- Exemplo 38: Para cada departamento: seu código, seu nome e a quantidade de funcionários, mas recupere apenas os grupos com ao menos 4 funcionários.
SELECT D.CodDepartamento, D.NomeDepartamento, COUNT(*) AS NumFuncionarios
FROM Empregado E INNER JOIN Departamento D
    ON E.CodDepartamento = D.CodDepartamento
GROUP BY D.CodDepartamento, D.NomeDepartamento
HAVING COUNT(*) >= 4;

-- Exemplo 39: recupere o código e o nome dos projetos da empresa que têm mais de 2 empregado.
SELECT P.CodProjeto, P.NomeProjeto, COUNT(*) AS NumEmpregados
FROM Projeto P INNER JOIN TrabalhaProjeto TP
    ON P.CodProjeto = TP.CodProjeto
GROUP BY P.CodProjeto, P.NomeProjeto
HAVING COUNT(*) > 2;

-- Exemplo 40: Para cada empregado, recupere sua Matricula, Nome, e quantidade de dependentes que ele possui.
SELECT E.Matricula, E.Nome, COUNT(D.NomeDependente) AS NumDependentes
FROM Empregado E INNER JOIN Dependente D
    ON E.Matricula = D.Empregado
GROUP BY E.Matricula, E.Nome;

SELECT E.Matricula, E.Nome, COUNT(D.NomeDependente) AS NumDependentes
FROM Empregado E LEFT OUTER JOIN Dependente D
    ON E.Matricula = D.Empregado
GROUP BY E.Matricula, E.Nome
ORDER BY NumDependentes DESC, E.Matricula ASC;

/* ===== Exclusão de Dados ===== */
    -- comando: DELETE
    -- sintaxe: DELETE FROM [nome_da_tabela] WHERE [condição]

-- Exemplo 41: Exclua as tuplas referentes aos projeto 3.
DELETE FROM TrabalhaProjeto
WHERE CodProjeto = 3;

-- Exemplo 42: Exclua todos os dependentes.
DELETE FROM Dependente;

/* ===== Atualização de Dados ===== */
    -- comando: UPDATE
    -- sintaxe: UPDATE [nome_da_tabela] SET [coluna = novo_valor, ...] WHERE [condição]

-- Exemplo 43: Atualize o gerente do departamento 2 para '1111-5'.
UPDATE Departamento
SET Gerente = '1111-5'
WHERE CodDepartamento = 2;

-- Exemplo 44: Atualize o salário dos empregados em mais 10%.
UPDATE Empregado
SET Salario = Salario * 1.10;

/* ===== VISÕES ===== */
    -- comando: CREATE VIEW
    -- sintaxe: CREATE VIEW [nome_da_view] AS [consulta_sql] --> (SELECT, FROM, WHERE)
    -- para remover uma view: DROP VIEW [nome_da_view] [RESTRICT|CASCADE]

/* ===== Índices ===== */
    -- comando: CREATE INDEX
    -- sintaxe: CREATE INDEX [nome_do_índice] ON [nome_da_tabela]([coluna1, coluna2, ...])
    -- para remover um índice: DROP INDEX [nome_do_índice] [RESTRICT|CASCADE]
    
    -- usado para melhorar a performance de consultas
    -- é definido sobre o valor de um atributo
