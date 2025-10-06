-- Script Parcial 2
-- Daniel Guzman (A00401303) y Simón García (A00371828)
--------------------------------------------------------------------------------------------------
-- User T2
SELECT * FROM P09779_3_7.CLIENTS;
SELECT * FROM P09779_3_7.CREDIT_LINES;
SELECT * FROM P09779_3_7.MOVEMENTS;
-----------------------------------------------------------------------------------------------------------------
-- ESTRATEGIA A -------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- User T1
-- 1. Verificar que exista el usuario Jane Smith
SELECT * FROM CLIENTS WHERE NAME = 'Jane Smith';
-- User T2
-- 2. Verificar que exista el usuario Jane Smith
SELECT NAME FROM P09779_3_7.CLIENTS WHERE NAME = 'Jane Smith';
-- User T2
-- 3. Verificar que la línea de crédito 102 exista y tenga cupo
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- User T1
-- 4. T1 registra la nueva línea de crédito 103 por valor de $10.000 al cliente Jane Smith.
INSERT INTO CREDIT_LINES (ID_CREDIT, ID_CLIENT, AVAILABLE_CREDIT, USED_CREDIT)
VALUES (103, 2, 10000, 0);
SELECT * FROM CREDIT_LINES WHERE ID_CLIENT = 2;


--User T1
-- 5. T1 modifica AVAILABLE_CREDIT de la línea de crédito 102, por valor de $5.000.
UPDATE CREDIT_LINES SET AVAILABLE_CREDIT = 5000 WHERE ID_CREDIT = 102;
SELECT * FROM CREDIT_LINES WHERE ID_CLIENT = 2;


-- User T2
-- 6. T2 inserta una fila en la tabla MOVEMENTS de $5.000 asociado al crédito 102.
-- Se hace la consulta para verificar que tiene el cupo para el movimiento
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Se inserta el movimiento de pago de 5000 en el crédito 102
INSERT INTO P09779_3_7.MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (102, 'PURCHASE', 5000, SYSDATE - 3);
-- Se verifica que el movimiento se haya insertado correctamente
SELECT * FROM P09779_3_7.MOVEMENTS WHERE ID_CREDIT = 102;


-- 7. T1 inserta una fila en la tabla MOVEMENTS de $10.000 asociado al crédito 103.
-- se revisa que el creditotenga el cupo necesario para la compra y luego se inserta el movimiento:
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM CREDIT_LINES WHERE ID_CREDIT = 103;
INSERT INTO MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (103, 'PURCHASE', 10000, SYSDATE - 3);
-- verificar
SELECT * FROM MOVEMENTS WHERE ID_CREDIT = 103;
-- 8. T1 modifica USED_CREDIT de la línea de crédito 103, por valor de $10.000.
UPDATE CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 10000 WHERE ID_CREDIT = 103;
-- consultamos que este actualizado
SELECT * FROM CREDIT_LINES WHERE ID_CREDIT = 103;
-- 9. T1 revisa estado y confirma cambios.  Nota: revisar estado implica validar que el resultado es esperado y los datos son consistentes.
SELECT * FROM CREDIT_LINES WHERE ID_CLIENT = 2;
SELECT * FROM MOVEMENTS WHERE ID_CREDIT = 102;
SELECT * FROM MOVEMENTS WHERE ID_CREDIT = 103;
COMMIT;


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


-----------------------------------------------------------------------------------------------------------------
-- ESTRATEGIA B -------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- 1. T1 verifica que el cliente existe.
SELECT * FROM CLIENTS WHERE NAME = 'Jane Smith';
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




-- 5. T1 registra la nueva línea de crédito 103 por valor de $10.000 al cliente Jane Smith.
INSERT INTO CREDIT_LINES (ID_CREDIT, ID_CLIENT, AVAILABLE_CREDIT, USED_CREDIT)
VALUES (103, 2, 10000, 0);
SELECT * FROM CREDIT_LINES WHERE ID_CLIENT = 2;
-- 6. T1 modifica AVAILABLE_CREDIT de la línea de crédito 102, a un valor de $5.000.
UPDATE CREDIT_LINES SET AVAILABLE_CREDIT = 5000 WHERE ID_CREDIT = 102;
SELECT * FROM CREDIT_LINES WHERE ID_CLIENT = 2;


-- User T2
-- 7. T2 actualiza CREDIT_LINES (aumentar USED_CREDIT) el crédito 102 en $5.000.
-- Se hace la consulta para verificar que tiene el cupo para ver que no se excede
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Aunque se sabe que no hay saldo suficiente, de todas formas se va a intentar actualizar
-- pero T1 no ha hecho commit aun, esto se me va a bloquear
UPDATE P09779_3_7.CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 5000 WHERE ID_CREDIT = 102;
-- 9. T1 inserta una fila en la tabla MOVEMENTS de $10.000 asociado al crédito 103.
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM CREDIT_LINES WHERE ID_CREDIT = 103;
INSERT INTO MOVEMENTS (ID_CREDIT, MOVEMENT_TYPE, AMOUNT, MOVEMENT_DATE)
VALUES (103, 'PURCHASE', 10000, SYSDATE - 3);
-- verificar
SELECT * FROM MOVEMENTS WHERE ID_CREDIT = 103;
-- 10. T1 modifica USED_CREDIT de la línea de crédito 103, por valor de $10.000.
UPDATE CREDIT_LINES SET USED_CREDIT = USED_CREDIT + 10000 WHERE ID_CREDIT = 103;
SELECT * FROM CREDIT_LINES WHERE ID_CREDIT= 103;
-- 11. T1 revisa estado y hace COMMIT.
commit;


-- User T2
-- 12. -> 8. T2 revisa estado y hace COMMIT.
SELECT AVAILABLE_CREDIT - USED_CREDIT FROM P09779_3_7.CREDIT_LINES WHERE ID_CREDIT = 102;
-- Aunque el estado queda inconsistente (negativos) se hace commit para guardar los cambios
COMMIT;