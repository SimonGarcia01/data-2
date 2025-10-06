INSERT INTO categorias (nombre)
VALUES ('Prueba-Aislamiento');

INSERT INTO productos (
	nombre
	,precio
	,categoria_id
	,stock
	)
VALUES (
	'Microondas Prueba'
	,500000
	,(
		SELECT id
		FROM categorias
		WHERE nombre = 'Prueba-Aislamiento'
		)
	,5
	);

COMMIT;

SELECT * FROM productos WHERE nombre='Microondas Prueba';

-- Dirty Read
UPDATE productos SET stock = stock - 2 WHERE nombre='Microondas Prueba';

-- Non-Repeatable Read
UPDATE productos SET stock = stock - 1 WHERE nombre='Microondas Prueba';
COMMIT;

--Serializable
UPDATE productos SET stock = stock - 1 WHERE nombre='Microondas Prueba';
COMMIT;