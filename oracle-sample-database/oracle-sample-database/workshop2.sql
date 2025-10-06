-- Example parts:
-- In vs Exists
EXPLAIN PLAN
FOR

SELECT e.employee_id
	,e.first_name
	,e.last_name
FROM employees e
WHERE e.job_title = 'Sales Representative'
	AND e.employee_id IN (
		SELECT o.salesman_id
		FROM orders o
		);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN
FOR

SELECT e.employee_id
	,e.first_name
	,e.last_name
FROM employees e
WHERE e.job_title = 'Sales Representative'
	AND EXISTS (
		SELECT 1
		FROM orders o
		WHERE e.employee_id = o.salesman_id
		);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Make an index to repeat the same process
CREATE INDEX idx_emp_order on orders(salesman_id);

-- Join vs Cartesian Product
EXPLAIN PLAN
FOR

SELECT o.order_id
	,o.STATUS
	,e.employee_id
	,e.first_name
FROM orders o
JOIN employees e ON o.salesman_id = e.employee_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN
FOR

SELECT o.order_id
	,o.STATUS
	,e.employee_id
	,e.first_name
FROM orders o
	,employees e
WHERE o.salesman_id = e.employee_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Clusters
CREATE CLUSTER mi_cluster (departamento NUMBER(6));
CREATE INDEX i_mi_cluster ON CLUSTER mi_cluster;

CREATE TABLE dpto (
	codigo NUMBER(6) PRIMARY KEY
	,descripcion VARCHAR2(10) NOT NULL
) CLUSTER mi_cluster (codigo);

CREATE TABLE emp (
  cedula NUMBER(8) PRIMARY KEY,
  nombre VARCHAR2(20) NOT NULL,
  dep NUMBER(6) NOT NULL REFERENCES dpto(codigo)
) CLUSTER mi_cluster(dep);


EXPLAIN PLAN
FOR

SELECT *
FROM dpto
	,emp
WHERE codigo = dep;

SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);