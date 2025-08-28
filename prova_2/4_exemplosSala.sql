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

