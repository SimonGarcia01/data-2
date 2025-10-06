SELECT * FROM productos WHERE nombre='Microondas Prueba';

--Dirty Read
SELECT stock FROM productos WHERE nombre='Microondas Prueba';

-- Non repeatable read
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT stock FROM productos WHERE nombre='Microondas Prueba';

-- Serializable
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
--Before commit of the other transaction
SELECT stock FROM productos WHERE nombre='Microondas Prueba';
--After commit of the other transaction
SELECT stock FROM productos WHERE nombre='Microondas Prueba';