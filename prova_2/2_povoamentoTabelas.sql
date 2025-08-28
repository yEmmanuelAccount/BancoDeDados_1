
INSERT INTO DEPARTAMENTO VALUES(1,'Financeiro', NULL)
;
INSERT INTO DEPARTAMENTO VALUES(2,'Vendas', NULL)
;
INSERT INTO Empregado VALUES('1111-3','Carlos',4500,NULL,2)
;
INSERT INTO Empregado VALUES('1111-4','Joaquim',4500,NULL,1)
;
INSERT INTO Empregado VALUES('1111-1','João',2500,'1111-4',1)
;
INSERT INTO Empregado VALUES('1111-2','Maria',2500,'1111-3',2)
;
INSERT INTO Empregado VALUES('1111-5','Ana',3000,'1111-4',1)
;
INSERT INTO Empregado VALUES('1111-6','Patrícia',2500,'1111-3',2)
;
INSERT INTO Empregado VALUES('1111-7','Sérgio',1000,'1111-3',2)
;

UPDATE Departamento SET Gerente='1111-4' WHERE CodDepartamento=1
;
UPDATE Departamento SET Gerente='1111-3' WHERE CodDepartamento=2
;

INSERT INTO Projeto VALUES(1, 'Venda Fácil', 1)
;
INSERT INTO Projeto VALUES(2, 'Max Lucro', 2)
;
INSERT INTO Projeto VALUES(3, 'Cliente Feliz', 2)
;

INSERT INTO Dependente VALUES ('1111-2','Marcos','Filho')
;
INSERT INTO Dependente VALUES ('1111-2','Luís','Filho')
;
INSERT INTO Dependente VALUES ('1111-3','Ana','Cônjuge')
;
INSERT INTO Dependente VALUES ('1111-3','Felipe','Filho')
;

INSERT INTO TrabalhaProjeto VALUES ('1111-1',2, 12)
;
INSERT INTO TrabalhaProjeto VALUES ('1111-1',3, 12)
;
INSERT INTO TrabalhaProjeto VALUES ('1111-2',1, 12)
;
INSERT INTO TrabalhaProjeto VALUES ('1111-2',2, 12)
;
INSERT INTO TrabalhaProjeto VALUES ('1111-4',2, 12)
;
INSERT INTO TrabalhaProjeto VALUES ('1111-4',3, 12)
;