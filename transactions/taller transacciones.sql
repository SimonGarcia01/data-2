-- verify current info
SELECT * FROM productos;
SELECT * FROM ventas;

-- Grant other user privileges over my tables
GRANT SELECT, UPDATE ON productos TO P09779_3_3;
GRANT SELECT ON ventas TO P09779_3_3;

--Implicit Block
UPDATE productos 
SET stock = stock - 1 
WHERE nombre = 'Microondas Prueba'; 
-- generate block wait for commi
COMMIT;

-- select for update (explicit block with a specific row)
SELECT * 
FROM productos 
WHERE nombre = 'Microondas Prueba' 
FOR UPDATE;
-- generate block
COMMIT;

-- Explicit lock at table level
LOCK TABLE productos IN EXCLUSIVE MODE;
COMMIT;

--trying if implicit block is table or row level
INSERT INTO productos (nombre, precio, categoria_id, stock) VALUES ('Microondas 2', 500000, (SELECT id FROM categorias WHERE nombre='Prueba-Aislamiento'), 5); 
COMMIT;