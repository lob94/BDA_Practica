/************** SCRIPT DE CREACIÓN DE TABLAS PARA LA APLICACIÓN ***************/
/************** Autor: Diego Tejeda Valcárcel                   ***************/
/************** Autor: Roberto Insúa Brandariz                  ***************/
/************** Bases de Datos Avanzadas - TGR                  ***************/
/************** UDC - 2017                                      ***************/
/******************************************************************************/

/****************************** DROP ALL TABLES *******************************/

DROP TABLE liñacarriño;
DROP TABLE carriño;
DROP TABLE usuario;
DROP TABLE produto;

/***************************** DROP ALL SEQUENCES *****************************/

DROP SEQUENCE cuota_seq;
DROP SEQUENCE carriño_seq;
DROP SEQUENCE liña_seq;
DROP SEQUENCE produto_seq;

/******************************* CREATE TABLES ********************************/

CREATE TABLE usuario (
	dni VARCHAR(9) NOT NULL,
	nome VARCHAR(15) NOT NULL,
	apelidos VARCHAR(25) NOT NULL,
	nick VARCHAR(15) UNIQUE,
	email VARCHAR(25) NOT NULL UNIQUE,
	CONSTRAINT usuario_pk PRIMARY KEY (dni),
	CONSTRAINT usuario_check CHECK (REGEXP_LIKE(dni, '\d{8}[A-Z]{1}'))
);

CREATE TABLE carriño (
	idCarriño NUMBER(8) NOT NULL,
	usuario_dni VARCHAR(9) NOT NULL,
	CONSTRAINT carriño_pk PRIMARY KEY (idCarriño),
	CONSTRAINT carriño_usuario_fk FOREIGN KEY (usuario_dni)
	REFERENCES usuario (dni) ON DELETE CASCADE
);

CREATE TABLE produto (
	idProduto NUMBER(8) NOT NULL,
	nome VARCHAR(25) NOT NULL,
	descricion VARCHAR(60),
	prezo NUMBER(8,2) NOT NULL check(prezo>=0),
	stock NUMBER(8) check (stock>=0),
	CONSTRAINT produto_pk PRIMARY KEY (idProduto)
);

CREATE TABLE liñacarriño (
	idLiñaCarriño NUMBER(8) NOT NULL,
	cantidade NUMBER(3) NOT NULL,
	carriño_idCarriño NUMBER(8) NOT NULL,
	produto_idProduto NUMBER(8) NOT NULL,
	PRIMARY KEY (idLiñaCarriño, carriño_idCarriño),
	FOREIGN KEY (carriño_idCarriño) REFERENCES carriño (idCarriño)
	ON DELETE CASCADE,
	FOREIGN KEY (produto_idProduto) REFERENCES produto(idProduto)
	ON DELETE CASCADE,
	CONSTRAINT table_cantidade check (cantidade between 0 and 999)
);


/****************** CREATE SEQUENCES TO ALLOW AUTO-INCREMENT ******************/

CREATE SEQUENCE cuota_seq;
CREATE SEQUENCE carriño_seq;
CREATE SEQUENCE produto_seq;
CREATE SEQUENCE liña_seq;

/****************** CREATE TRIGGERS TO ALLOW AUTO-INCREMENT *******************/


CREATE OR REPLACE TRIGGER carriño_trig
BEFORE INSERT ON carriño
FOR EACH ROW
BEGIN
  SELECT carriño_seq.NEXTVAL
  INTO   :new.idCarriño
  FROM   dual;
END;

/

CREATE OR REPLACE TRIGGER produto_trig
BEFORE INSERT ON produto
FOR EACH ROW
BEGIN
  SELECT produto_seq.NEXTVAL
  INTO   :new.idProduto
  FROM   dual;
END;

/

CREATE OR REPLACE TRIGGER liña_trig
BEFORE INSERT ON liñacarriño
FOR EACH ROW
BEGIN
  SELECT liña_seq.NEXTVAL
  INTO   :new.idLiñaCarriño
  FROM   dual;
END;

/

/********************* FILL THE TABLES WITH DATA EXAMPLES *********************/

/*usuario table*/

INSERT INTO usuario 
VALUES ('33555017H', 'Diego', 'Tejeda Valcarcel', 'teje', 'diegoteje@gmailcom');
INSERT INTO usuario 
VALUES ('79342569K', 'Roberto', 'Insua Brandariz', 'xrob', 'xrob@gmailcom');
INSERT INTO usuario 
VALUES ('35875623F', 'Sofia', 'Lopez Rodriguez', 'softia', 'sofi1994@gmailcom');
INSERT INTO usuario 
VALUES ('33663094R', 'Maria', 'Veiga Pacin', 'mari2', 'mvp_95@gmailcom');


/*carriño table*/

INSERT INTO carriño (usuario_dni)
VALUES ('33555017H');
INSERT INTO carriño (usuario_dni)
VALUES ('79342569K');
INSERT INTO carriño (usuario_dni)
VALUES ('35875623F');
INSERT INTO carriño (usuario_dni)
VALUES ('33663094R');

/*Produto table*/

INSERT INTO produto (nome, descricion, prezo, stock)
VALUES ('TV 3d', 'Smart TV de ultima xeracion con 3D incorporado', 2774.99, 10);
INSERT INTO produto(nome, descricion, prezo, stock)
VALUES ('TV curva', 'Televisión 70" curva', 3000, 20);
INSERT INTO produto (nome, descricion, prezo, stock)
VALUES ('PlayStation4', 'Ultimo lanzamento de SONY na plataforma dos videoxogos', 450.00, 15);
INSERT INTO produto (nome, descricion, prezo, stock)
VALUES ('Sennheiser HD25II', 'Cascos HD de Sennheiser max calidad', 250.00, 5);
INSERT INTO produto (nome, descricion, prezo, stock)
VALUES ('Dualshock 4', 'Mando dualshock da consola Playstation', 68.75, 4);
INSERT INTO produto (nome, descricion, prezo, stock)
VALUES ('FIFA 17', 'O clasico videoxogo de futbol', 59.99, 4);

/*LiñaCarriño table*/

INSERT INTO liñacarriño (cantidade, carriño_idCarriño, produto_idProduto)
VALUES (2,1,4);
INSERT INTO liñacarriño (cantidade, carriño_idCarriño, produto_idProduto)
VALUES (1,1,5);
INSERT INTO liñacarriño (cantidade, carriño_idCarriño, produto_idProduto)
VALUES (1,3,1);
INSERT INTO liñacarriño (cantidade, carriño_idCarriño, produto_idProduto)
VALUES (1,1,3);
INSERT INTO liñacarriño (cantidade, carriño_idCarriño, produto_idProduto)
VALUES (1,1,1);


/************************************ EOF *************************************/
