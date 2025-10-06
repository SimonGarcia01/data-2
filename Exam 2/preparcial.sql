-- =========================================== 
-- 1. DROP TABLES (por si existe algo previo) 
-- =========================================== 

BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE MOVEMENTS CASCADE CONSTRAINTS'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END; 
/ 


BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE CREDIT_LINES CASCADE CONSTRAINTS'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END; 
/ 


BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTS CASCADE CONSTRAINTS'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END; 
/ 

-- =========================================== 
-- 2. TABLA: CLIENTS 
-- =========================================== 

CREATE TABLE CLIENTS ( 
    ID_CLIENT          NUMBER PRIMARY KEY, 
    NAME               VARCHAR2(100) NOT NULL, 
    TOTAL_CREDIT_LIMIT NUMBER(12,2)  NOT NULL 
); 

 

-- =========================================== 
-- 3. TABLA: CREDIT_LINES 
-- =========================================== 
CREATE TABLE CREDIT_LINES ( 
    ID_CREDIT       NUMBER PRIMARY KEY, 
    ID_CLIENT       NUMBER NOT NULL, 
    AVAILABLE_CREDIT NUMBER(12,2) NOT NULL, 
    USED_CREDIT      NUMBER(12,2) NOT NULL, 
    CONSTRAINT FK_CL_CLIENT 
        FOREIGN KEY (ID_CLIENT) 
        REFERENCES CLIENTS (ID_CLIENT) 
); 

-- Índice para la FK 
CREATE INDEX IDX_CL_ID_CLIENT ON CREDIT_LINES (ID_CLIENT); 


-- =========================================== 
-- 4. TABLA: TRANSACTIONS 
-- =========================================== 
CREATE TABLE MOVEMENTS (
    ID_MOVEMENT      NUMBER(10)      NOT NULL,
    ID_CREDIT        NUMBER(10)      NOT NULL,
    MOVEMENT_TYPE    VARCHAR2(20)    NOT NULL,   -- 'PURCHASE' or 'PAYMENT'
    AMOUNT           NUMBER(12,2)    NOT NULL,
    MOVEMENT_DATE    DATE            NOT NULL,
    CONSTRAINT PK_MOVEMENTS PRIMARY KEY (ID_MOVEMENT),
    CONSTRAINT FK_MOVEMENTS_CREDIT FOREIGN KEY (ID_CREDIT)
        REFERENCES CREDIT_LINES (ID_CREDIT)
);

CREATE INDEX IDX_MOVEMENTS_ID_CREDIT
ON MOVEMENTS (ID_CREDIT);

CREATE SEQUENCE SEQ_MOVEMENTS
START WITH 1001   -- puedes ajustar este inicio
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER TRG_MOVEMENTS_BEFORE_INSERT
BEFORE INSERT ON MOVEMENTS
FOR EACH ROW
BEGIN
    IF :NEW.ID_MOVEMENT IS NULL THEN
        SELECT SEQ_MOVEMENTS.NEXTVAL
        INTO :NEW.ID_MOVEMENT
        FROM DUAL;
    END IF;
END;
/


-- =========================================== 
-- 5. INSERCIÓN DE DATOS DE PRUEBA 
-- =========================================== 
INSERT INTO CLIENTS (ID_CLIENT, NAME, TOTAL_CREDIT_LIMIT) 
VALUES (1, 'John Doe', 10000); 
INSERT INTO CLIENTS (ID_CLIENT, NAME, TOTAL_CREDIT_LIMIT) 
VALUES (2, 'Jane Smith', 15000); 
COMMIT; 

INSERT INTO CREDIT_LINES (ID_CREDIT, ID_CLIENT, AVAILABLE_CREDIT, USED_CREDIT) 
VALUES (101, 1, 3000, 200); 
INSERT INTO CREDIT_LINES (ID_CREDIT, ID_CLIENT, AVAILABLE_CREDIT, USED_CREDIT) 
VALUES (102, 2, 12000, 1000); 
COMMIT; 

INSERT INTO MOVEMENTS (ID_MOVEMENT, ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (SEQ_MOVEMENTS.NEXTVAL, 101, 'PURCHASE', 500, SYSDATE - 5);

INSERT INTO MOVEMENTS (ID_MOVEMENT, ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (SEQ_MOVEMENTS.NEXTVAL, 101, 'PAYMENT', 300, SYSDATE - 2);

INSERT INTO MOVEMENTS (ID_MOVEMENT, ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (SEQ_MOVEMENTS.NEXTVAL, 102, 'PURCHASE', 1000, SYSDATE - 3);

COMMIT; 


---------------------------------------------------------
-- Actividad
---------------------------------------------------------

-- Verificar que puedo leer
SELECT * FROM P09779_3_7.CLIENTS;
SELECT * FROM P09779_3_7.CREDIT_LINES;
SELECT * FROM P09779_3_7.MOVEMENTS;

-- Primer caso
SELECT NAME FROM P09779_3_7.CLIENTS WHERE NAME = 'John Doe';

SELECT ID_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 101;

SELECT AVAILABLE_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 101;

-- First purchase 1500

SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 101;

INSERT INTO P09779_3_7.MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (101, 'PURCHASE', 1500, SYSDATE - 3);

UPDATE P09779_3_7.CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 1500 WHERE ID_CREDIT = 101;

SAVEPOINT after_1500_purchase;

SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 101;

COMMIT;

-- Second purchase 1150

SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 101;

INSERT INTO P09779_3_7.MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (101, 'PURCHASE', 1150, SYSDATE - 3);

UPDATE P09779_3_7.CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 1150 WHERE ID_CREDIT = 101;

SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 101;

SAVEPOINT after_1150_purchase;

COMMIT;

--Third purchase 300

SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 101;

INSERT INTO P09779_3_7.MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (101, 'PURCHASE', 300, SYSDATE - 3);

UPDATE P09779_3_7.CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 300 WHERE ID_CREDIT = 101;

SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 101;

ROLLBACK TO after_1500_purchase;

SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 101;

-----------------------------------------------------------------------------------------------------------------
-- ESTRATEGIA A -------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
-- ESTRATEGIA B -------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- Verificar que puedo leer
SELECT * FROM P09779_3_7.CLIENTS;
SELECT * FROM P09779_3_7.CREDIT_LINES;
SELECT * FROM P09779_3_7.MOVEMENTS;

-- Verificar que exista el usuario Jane Smith
SELECT NAME FROM P09779_3_7.CLIENTS WHERE NAME = 'Jane Smith';

-- User T2
-- 3. Verificar que la línea de crédito 102 exista y tenga cupo
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;

-- User T2
-- 6. T2 inserta una fila en la tabla MOVEMENTS de $5.000 asociado al crédito 102.
-- Se hace la consulta para verificar que tiene el cupo para el movimiento
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Se inserta el movimiento de pago de 5000 en el crédito 102
INSERT INTO P09779_3_7.MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (102, 'PURCHASE', 5000, SYSDATE - 3);
-- Se verifica que el movimiento se haya insertado correctamente
SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 102;

-- User T2
-- 10. T2 actualiza CREDIT_LINES (aumentar USED_CREDIT) el crédito 102 en $5.000.
-- Se hace la consulta para verificar que tiene el cupo para ver que no se excede
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Aunque se sabe que no hay saldo suficiente, de todas formas se hace la actualización porque técnicamente aun no sabemos de que
-- al crédito 102 no le alcanza el cupo
UPDATE P09779_3_7.CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 5000 WHERE ID_CREDIT = 102;

-- User T2
-- 11. T2 revisa estado y confirmar cambios con COMMIT o hacer ROLLBACK según sea el caso.
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Como queda en un estado inconsistente (en negativos) se decide hacer rollback
ROLLBACK;

-- Verificando el estado de la base de datos después del rollback
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;

SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 102;

-- User T2
-- 2. T2 verifica que el cliente existe.
SELECT NAME FROM P09779_3_7.CLIENTS WHERE NAME = 'Jane Smith';

-- User T2
-- 3. T2 verificas que la línea de crédito exista y tenga cupo.
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;

-- User T2
-- 4. T2 inserta una fila en la tabla MOVEMENTS de $5.000 asociado al crédito 102.
-- Se hace la consulta para verificar que tiene el cupo para el movimiento
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Se inserta el movimiento de pago de 5000 en el crédito 102
INSERT INTO P09779_3_7.MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (102, 'PURCHASE', 5000, SYSDATE - 3);
-- Se verifica que el movimiento se haya insertado correctamente
SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 102;

-- User T2
-- 7. T2 actualiza CREDIT_LINES (aumentar USED_CREDIT) el crédito 102 en $5.000.
-- Se hace la consulta para verificar que tiene el cupo para ver que no se excede
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Aunque se sabe que no hay saldo suficiente, de todas formas se va a intentar actualizar
-- pero T1 no ha hecho commit aun, esto se me va a bloquear
UPDATE P09779_3_7.CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 5000 WHERE ID_CREDIT = 102;

-- User T2
-- 8. T2 revisa estado y hace COMMIT.
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Aunque el estado queda inconsistente (negativos) se hace commit para guardar los cambios
COMMIT;