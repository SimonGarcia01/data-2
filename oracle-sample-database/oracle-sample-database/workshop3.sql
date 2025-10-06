CREATE TABLE students (
student_id NUMBER PRIMARY KEY,
dni CHAR(8),
first_name VARCHAR2(100),
last_name VARCHAR2(100),
age NUMBER(3,0)
);

INSERT INTO students VALUES (1, '12345678', 'John', 'Smith', 20);
INSERT INTO students VALUES (2, '23456789', 'Emily', 'Johnson', 21);
INSERT INTO students VALUES (3, '34567890', 'Michael', 'Williams', 22);
INSERT INTO students VALUES (4, '45678901', 'Emma', 'Brown', 21);
INSERT INTO students VALUES (5, '56789012', 'Sophia', 'Miller', 23);
INSERT INTO students VALUES (6, '67890123', 'Liam', 'Davis', 20);
INSERT INTO students VALUES (7, '78901234', 'Olivia', 'Johnson', 22);
INSERT INTO students VALUES (8, '89012345', 'Noah', 'Martinez', 21);
INSERT INTO students VALUES (9, '90123456', 'Ava', 'Anderson', 24);
INSERT INTO students VALUES (10, '12345098', 'Ethan', 'Garcia', 20);

-- Find a student by last name:
EXPLAIN PLAN FOR
SELECT * FROM students WHERE last_name = 'Nbkaw';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--find a student by DNI
EXPLAIN PLAN FOR
SELECT * FROM students WHERE dni = '10002808';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT dni
FROM students
ORDER BY dni ASC
FETCH FIRST 30 ROWS ONLY;


--find student by PK
EXPLAIN PLAN FOR
SELECT * FROM students WHERE student_id = 100;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--find students by range of PK
EXPLAIN PLAN FOR
SELECT * FROM students WHERE student_id > 10;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- See all row ids
select rowid, student_id,dni,first_name,last_name from students;

-- find user from rowid
EXPLAIN PLAN FOR
select rowid, student_id,dni,first_name,last_name from students where rowid = 'AAAS1nAAMAAAACGAAA';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--Create default index
CREATE INDEX idx_dni ON students(dni);
-- Find the user with the index now
EXPLAIN PLAN FOR
SELECT * FROM students WHERE dni = '78901234';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- End of part A
DROP INDEX idx_dni;
DROP TABLE students;

-------------------------------------------
-------------------------------------------
-- Start of part B
CREATE TABLE students (
student_id NUMBER PRIMARY KEY,
dni CHAR(8),
first_name VARCHAR2(100),
last_name VARCHAR2(100),
age NUMBER(3,0)
);

--Insert 500,000 random values:
BEGIN
  FOR i IN 1..500000 LOOP
    INSERT INTO students (
      student_id,
      dni,
      first_name,
      last_name,
      age
    ) VALUES (
      i,
      LPAD(TRUNC(DBMS_RANDOM.VALUE(10000000, 99999999)), 8, '0'),
      INITCAP(DBMS_RANDOM.STRING('U', TRUNC(DBMS_RANDOM.VALUE(5, 10)))),
      INITCAP(DBMS_RANDOM.STRING('U', TRUNC(DBMS_RANDOM.VALUE(5, 12)))),
      TRUNC(DBMS_RANDOM.VALUE(18, 60))
    );
    
    -- Commit cada 10,000 para evitar rollback segment overflow
    IF MOD(i, 10000) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;
  COMMIT;
END;
/