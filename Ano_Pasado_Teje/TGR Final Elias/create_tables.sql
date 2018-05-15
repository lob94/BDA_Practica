/************** SCRIPT DE CREACIÓN DE TABLAS PARA LA APLICACIÓN ***************/
/************** Autor: Elías García Mariño                      ***************/
/************** Bases de Datos Avanzadas - TGR                  ***************/
/************** UDC - 2016                                      ***************/
/******************************************************************************/

/****************************** DROP ALL TABLES *******************************/

DROP TABLE linea;
DROP TABLE ejercicio;
DROP TABLE plan;
DROP TABLE monitor;
DROP TABLE cliente;

/***************************** DROP ALL SEQUENCES *****************************/

DROP SEQUENCE cuota_seq;
DROP SEQUENCE plan_seq;
DROP SEQUENCE linea_seq;
DROP SEQUENCE ejercicio_seq;

/******************************* CREATE TABLES ********************************/

CREATE TABLE cliente (
    dni VARCHAR(9) NOT NULL,
    nombre VARCHAR2(15) NOT NULL,
    apellidos VARCHAR2(40) NOT NULL,
    peso NUMBER(5,2) NOT NULL,
    altura NUMBER(3,2) NOT NULL,
    CONSTRAINT cliente_pk PRIMARY KEY (dni),
    CONSTRAINT client_check CHECK (REGEXP_LIKE(dni, '\d{8}[A-Z]{1}'))
);

CREATE TABLE monitor (
    dni VARCHAR(9) NOT NULL,
    nombre VARCHAR2(15) NOT NULL,
    apellidos VARCHAR2(40) NOT NULL,
    salario NUMBER(8,2) NOT NULL,
    CONSTRAINT monitor_pk PRIMARY KEY (dni),
    CONSTRAINT monitor_check CHECK (REGEXP_LIKE(dni, '\d{8}[A-Z]{1}'))
);

CREATE TABLE plan (
    id NUMBER(10) NOT NULL,
    descripcion VARCHAR2(40) NOT NULL,
    precio NUMBER(7,2) NOT NULL,
    cliente_dni VARCHAR(9) NOT NULL,
    monitor_dni VARCHAR(9) NOT NULL,
    CONSTRAINT plan_pk PRIMARY KEY (id),
    CONSTRAINT plan_cliente_fk FOREIGN KEY (cliente_dni)
        REFERENCES cliente (dni) ON DELETE CASCADE,
    CONSTRAINT plan_monitor_fk FOREIGN KEY (monitor_dni)
        REFERENCES monitor (dni) ON DELETE CASCADE
);

CREATE TABLE ejercicio (
    id NUMBER(10) NOT NULL,
    nombre VARCHAR2(30) NOT NULL,
    CONSTRAINT ejercicio_pk PRIMARY KEY (id)
);

CREATE TABLE linea (
    numero_linea NUMBER(10) NOT NULL,
    repeticiones NUMBER(4) NOT NULL,
    plan_id NUMBER(10) NOT NULL,
    ejercicio_id NUMBER(10) NOT NULL,
    CONSTRAINT linea_pk PRIMARY KEY (numero_linea),
    CONSTRAINT linea_plan_fk FOREIGN KEY (plan_id)
        REFERENCES plan (id) ON DELETE CASCADE,
    CONSTRAINT linea_ejercicio_fk FOREIGN KEY (ejercicio_id)
        REFERENCES ejercicio (id) ON DELETE CASCADE,
    CONSTRAINT linea_ejercicio_uq UNIQUE (plan_id, ejercicio_id)
);

/****************** CREATE SEQUENCES TO ALLOW AUTO-INCREMENT ******************/

CREATE SEQUENCE cuota_seq;
CREATE SEQUENCE plan_seq;
CREATE SEQUENCE linea_seq;
CREATE SEQUENCE ejercicio_seq;

/****************** CREATE TRIGGERS TO ALLOW AUTO-INCREMENT *******************/

CREATE OR REPLACE TRIGGER plan_ai
BEFORE INSERT ON plan
FOR EACH ROW
BEGIN
  SELECT plan_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;

/

CREATE OR REPLACE TRIGGER ejercicio_trig
BEFORE INSERT ON ejercicio
FOR EACH ROW
BEGIN
  SELECT ejercicio_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;

/

CREATE OR REPLACE TRIGGER linea_ai
BEFORE INSERT ON linea
FOR EACH ROW
BEGIN
  SELECT linea_seq.NEXTVAL
  INTO   :new.numero_linea
  FROM   dual;
END;

/

/********************* FILL THE TABLES WITH DATA EXAMPLES *********************/

INSERT INTO cliente
VALUES ('43266653L', 'PABLO', 'MANZANARES GARCIA', 80, 1.79);
INSERT INTO cliente
VALUES ('60590504V', 'JORGE', 'CODINA RODA', 74, 1.82);
INSERT INTO cliente
VALUES ('61061730L', 'DANIEL', 'PRESA MENDIZABAL', 93, 1.90);

INSERT INTO monitor
VALUES ('50444584H', 'EMILIO', 'DIEGUEZ FARINA', 1500);
INSERT INTO monitor
VALUES ('39317485C', 'ALVARO', 'PAZOS CARRACEDO', 1300);

INSERT INTO plan (descripcion, precio, cliente_dni, monitor_dni)
VALUES ('Plan de calentamiento', 150, '43266653L', '50444584H');
INSERT INTO plan (descripcion, precio, cliente_dni, monitor_dni)
VALUES ('Plan de fuerza', 230, '43266653L', '39317485C');
INSERT INTO plan (descripcion, precio, cliente_dni, monitor_dni)
VALUES ('Plan de fuerza', 230, '61061730L', '39317485C');

INSERT INTO ejercicio (nombre)
VALUES ('Cuello-negacion');
INSERT INTO ejercicio (nombre)
VALUES ('Rotacion de cadera');
INSERT INTO ejercicio (nombre)
VALUES ('Estiramiento lateral de hombro');
INSERT INTO ejercicio (nombre)
VALUES ('Elevacion de brazos alterno');
INSERT INTO ejercicio (nombre)
VALUES ('Press de pecho');
INSERT INTO ejercicio (nombre)
VALUES ('Curl de biceps');
INSERT INTO ejercicio (nombre)
VALUES ('Press de pierna');

INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (20, 1, 1);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (20, 1, 2);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (20, 1, 3);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (20, 1, 4);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (10, 2, 5);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (10, 2, 6);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (10, 2, 7);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (10, 3, 5);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (10, 3, 6);
INSERT INTO linea (repeticiones, plan_id, ejercicio_id)
VALUES (10, 3, 7);
/************************************ EOF *************************************/
