CREATE TABLE categorias ( 
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    nombre VARCHAR2(50) UNIQUE NOT NULL );

CREATE TABLE productos ( 
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    nombre VARCHAR2(100) NOT NULL, 
    precio NUMBER CHECK (precio > 0), 
    categoria_id NUMBER REFERENCES categorias(id), 
    stock NUMBER DEFAULT 0 CHECK (stock >= 0)
    );

CREATE TABLE ventas ( 
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    producto_id NUMBER REFERENCES productos(id), 
    cantidad NUMBER NOT NULL CHECK (cantidad > 0), 
    fecha TIMESTAMP DEFAULT SYSTIMESTAMP );

INSERT INTO categorias (nombre) VALUES ('Lácteos');
INSERT INTO categorias (nombre) VALUES ('Bebidas'); 
INSERT INTO categorias (nombre) VALUES ('Snacks');

SELECT * FROM categorias;

-- Block 1
BEGIN 
    INSERT INTO productos (precio, categoria_id) VALUES (3000, 1); 
    COMMIT; 
END; 
/

-- Block 2
BEGIN
    INSERT INTO productos (nombre, precio, categoria_id) VALUES ('Yogur', -2500, 1);
    COMMIT;
END;
/

-- Block 3
BEGIN
    INSERT INTO productos (nombre, precio, categoria_id) VALUES ('Jugo', 2500, 99);
    COMMIT;
END;
/

--Block 4
BEGIN
	INSERT INTO productos (
		nombre
		,precio
		,categoria_id
		)
	VALUES (
		'Jugo de naranja'
		,2500
		,2
		);

	SELECT * FROM productos;

	INSERT INTO productos (
		nombre
		,precio
		,categoria_id
		,stock
		)
	VALUES (
		'Queso'
		,-5000
		,1
		,50
		);

	ROLLBACK;
END;
/

--Block 5
BEGIN
    INSERT INTO productos (nombre, precio, categoria_id) VALUES ('Jugo de naranja', 2500, 2);
    INSERT INTO productos (nombre, precio, categoria_id, stock) VALUES ('Queso', -5000, 1, 50);
ROLLBACK;
END;
/

SELECT * FROM productos;

--Block 6
INSERT INTO venta (producto_id, cantidad) VALUES (1, 5);

--Block 7
BEGIN
    INSERT INTO venta (producto_id, cantidad) VALUES (1, -3);
    COMMIT;
END;
/

--Check what data we have
SELECT * FROM categorias; 
SELECT * FROM productos; 
SELECT * FROM ventas;

--Insert and add a savepoint
INSERT INTO categorias (nombre) VALUES ('Electrodomésticos'); 
SAVEPOINT sp_categoria;

--check result
SELECT * FROM categorias;

--Insert a new product and a savepoint
INSERT INTO productos (
	nombre
	,precio
	,categoria_id
	,stock
	)
VALUES (
	'Licuadora TurboMix'
	,350000
	,(
		SELECT id
		FROM categorias
		WHERE nombre = 'Electrodomésticos'
		)
	,10
	);

SAVEPOINT sp_producto;

--Check result
SELECT * FROM productos;

--Add some sales and a savepoint
INSERT INTO ventas (
	producto_id
	,cantidad
	)
VALUES (
	(
		SELECT id
		FROM productos
		WHERE nombre = 'Licuadora TurboMix'
		)
	,2
	);

INSERT INTO ventas (
	producto_id
	,cantidad
	)
VALUES (
	(
		SELECT id
		FROM productos
		WHERE nombre = 'Licuadora TurboMix'
		)
	,1
	);

SAVEPOINT sp_ventas;

--Check result
SELECT * FROM ventas;

--To undo the sales we go to the salepoint before it
ROLLBACK TO sp_producto;

-- Check the effect of the rollback
SELECT * FROM categorias; 
SELECT * FROM productos; 
SELECT * FROM ventas;

--To undo the product we go to the savepoint before it
ROLLBACK TO sp_categoria;

-- Check the effect of the rollback
SELECT * FROM categorias; 
SELECT * FROM productos; 
SELECT * FROM ventas;