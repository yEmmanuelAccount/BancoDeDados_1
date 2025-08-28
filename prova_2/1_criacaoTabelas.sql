CREATE TABLE Empregado(
    Matricula VARCHAR(10),
    Nome VARCHAR(30) NOT NULL,
    Salario REAL,
    Supervisor VARCHAR(10),
    PRIMARY KEY (Matricula),
    FOREIGN KEY (Supervisor) REFERENCES Empregado(Matricula),
    CHECK (Salario>0)         
)
;

CREATE TABLE Departamento(
    CodDepartamento INT,
    Nome VARCHAR(20) NOT NULL UNIQUE,
    Gerente VARCHAR(10),
    PRIMARY KEY (CodDepartamento),
    FOREIGN KEY (Gerente) REFERENCES Empregado(Matricula) 
)
;
ALTER TABLE Empregado ADD CodDepartamento INT
;
ALTER TABLE Empregado ADD CONSTRAINT Ref FOREIGN KEY (CodDepartamento) REFERENCES Departamento(CodDepartamento)  
;
CREATE TABLE Projeto(
    CodProjeto INT,
    Nome VARCHAR(30) NOT NULL UNIQUE,
    CodDepartamento INT NOT NULL,
    PRIMARY KEY (CodProjeto),
    FOREIGN KEY (CodProjeto) REFERENCES Projeto(CodProjeto)     
)
;
CREATE TABLE Dependente(
    Empregado VARCHAR(10),
    NomeDep VARCHAR(30),
    Parentesco VARCHAR(10) NOT NULL,
    PRIMARY KEY(Empregado,NomeDep),
    FOREIGN KEY (Empregado) REFERENCES Empregado(Matricula) 
)
;
CREATE TABLE TrabalhaProjeto(
    Empregado VARCHAR(10),
    CodProjeto INT,
    NumHoras SMALLINT,
    PRIMARY KEY(Empregado, CodProjeto),
    FOREIGN KEY (Empregado) REFERENCES Empregado(Matricula),
    FOREIGN KEY (CodProjeto) REFERENCES Projeto(CodProjeto)   
 
)
;