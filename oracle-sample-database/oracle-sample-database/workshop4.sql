-- ================================================
-- Caso de Estudio: Sistema de Ventas de Pasajes Aéreos
-- Script SQL con datos de ejemplo (SIN ÍNDICES)
-- ================================================

SET SERVEROUTPUT ON

-- =========================
-- 1. Esquema - Tablas
-- =========================

CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  first_name  VARCHAR2(100),
  last_name   VARCHAR2(100),
  email       VARCHAR2(255) UNIQUE,
  phone       VARCHAR2(50),
  created_at  TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE airplanes (
  airplane_id NUMBER PRIMARY KEY,
  model       VARCHAR2(100),
  total_seats NUMBER
);

CREATE TABLE flights (
  flight_id     NUMBER PRIMARY KEY,
  flight_number VARCHAR2(20) NOT NULL,
  origin        VARCHAR2(10) NOT NULL,
  destination   VARCHAR2(10) NOT NULL,
  duration_min  NUMBER,
  airplane_id   NUMBER REFERENCES airplanes(airplane_id),
  active_flag   CHAR(1) DEFAULT 'Y' CHECK (active_flag IN ('Y','N'))
);

CREATE TABLE flight_schedules (
  schedule_id    NUMBER PRIMARY KEY,
  flight_id      NUMBER NOT NULL REFERENCES flights(flight_id),
  depart_datetime TIMESTAMP NOT NULL,
  arrive_datetime TIMESTAMP,
  base_fare       NUMBER(10,2) NOT NULL
);

CREATE TABLE seats (
  seat_id       NUMBER PRIMARY KEY,
  schedule_id   NUMBER NOT NULL REFERENCES flight_schedules(schedule_id),
  seat_number   VARCHAR2(10) NOT NULL,
  seat_class    VARCHAR2(20) NOT NULL,
  is_available  CHAR(1) DEFAULT 'Y' CHECK (is_available IN ('Y','N'))
);

CREATE TABLE bookings (
  booking_id    NUMBER PRIMARY KEY,
  schedule_id   NUMBER NOT NULL REFERENCES flight_schedules(schedule_id),
  customer_id   NUMBER NOT NULL REFERENCES customers(customer_id),
  booking_date  TIMESTAMP DEFAULT SYSTIMESTAMP,
  total_amount  NUMBER(12,2),
  status        VARCHAR2(20) DEFAULT 'CONFIRMED'
);

CREATE TABLE booking_items (
  booking_item_id NUMBER PRIMARY KEY,
  booking_id      NUMBER NOT NULL REFERENCES bookings(booking_id),
  seat_id         NUMBER NOT NULL REFERENCES seats(seat_id),
  fare_amount     NUMBER(10,2)
);

CREATE TABLE availability_log (
  log_id      NUMBER PRIMARY KEY,
  schedule_id NUMBER,
  checked_at  TIMESTAMP DEFAULT SYSTIMESTAMP,
  client_ip   VARCHAR2(50)
);

-- =========================
-- 2. Secuencias y triggers
-- =========================

CREATE SEQUENCE seq_customers START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_customers
BEFORE INSERT ON customers FOR EACH ROW
WHEN (NEW.customer_id IS NULL)
BEGIN
  :NEW.customer_id := seq_customers.NEXTVAL;
END;
/

CREATE SEQUENCE seq_airplanes START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_airplanes
BEFORE INSERT ON airplanes FOR EACH ROW
WHEN (NEW.airplane_id IS NULL)
BEGIN
  :NEW.airplane_id := seq_airplanes.NEXTVAL;
END;
/

CREATE SEQUENCE seq_flights START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_flights
BEFORE INSERT ON flights FOR EACH ROW
WHEN (NEW.flight_id IS NULL)
BEGIN
  :NEW.flight_id := seq_flights.NEXTVAL;
END;
/

CREATE SEQUENCE seq_schedules START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_schedules
BEFORE INSERT ON flight_schedules FOR EACH ROW
WHEN (NEW.schedule_id IS NULL)
BEGIN
  :NEW.schedule_id := seq_schedules.NEXTVAL;
END;
/

CREATE SEQUENCE seq_seats START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_seats
BEFORE INSERT ON seats FOR EACH ROW
WHEN (NEW.seat_id IS NULL)
BEGIN
  :NEW.seat_id := seq_seats.NEXTVAL;
END;
/

CREATE SEQUENCE seq_bookings START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_bookings
BEFORE INSERT ON bookings FOR EACH ROW
WHEN (NEW.booking_id IS NULL)
BEGIN
  :NEW.booking_id := seq_bookings.NEXTVAL;
END;
/

CREATE SEQUENCE seq_booking_items START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_booking_items
BEFORE INSERT ON booking_items FOR EACH ROW
WHEN (NEW.booking_item_id IS NULL)
BEGIN
  :NEW.booking_item_id := seq_booking_items.NEXTVAL;
END;
/

CREATE SEQUENCE seq_availability_log START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_availability_log
BEFORE INSERT ON availability_log FOR EACH ROW
WHEN (NEW.log_id IS NULL)
BEGIN
  :NEW.log_id := seq_availability_log.NEXTVAL;
END;
/

-- =========================
-- 3. Población de datos
-- =========================

-- Aviones
INSERT INTO airplanes(model, total_seats) VALUES ('A320', 150);
INSERT INTO airplanes(model, total_seats) VALUES ('B737', 160);
INSERT INTO airplanes(model, total_seats) VALUES ('A330', 250);

-- Vuelos
INSERT INTO flights(flight_number, origin, destination, duration_min, airplane_id)
VALUES ('AV100','MDE','BOG',55,1);
INSERT INTO flights(flight_number, origin, destination, duration_min, airplane_id)
VALUES ('AV200','MDE','CTG',60,1);
INSERT INTO flights(flight_number, origin, destination, duration_min, airplane_id)
VALUES ('AV300','MDE','CLO',45,2);
INSERT INTO flights(flight_number, origin, destination, duration_min, airplane_id)
VALUES ('AV400','BOG','MAD',420,3);
COMMIT;

-- Horarios: 100 por vuelo
DECLARE
  v_date DATE := TRUNC(SYSDATE);
BEGIN
  FOR r IN (SELECT flight_id FROM flights) LOOP
    FOR d IN 1..100 LOOP
      INSERT INTO flight_schedules(flight_id, depart_datetime, arrive_datetime, base_fare)
      VALUES (
        r.flight_id,
        v_date + d + DBMS_RANDOM.VALUE,
        v_date + d + (DBMS_RANDOM.VALUE + 0.5),
        ROUND(100 + DBMS_RANDOM.VALUE*800,2)
      );
    END LOOP;
  END LOOP;
  COMMIT;
END;
/

-- Asientos: 50 por cada horario
DECLARE
  CURSOR c IS SELECT schedule_id FROM flight_schedules;
  v_class VARCHAR2(20);
BEGIN
  FOR s IN c LOOP
    FOR i IN 1..50 LOOP
      IF i <= 5 THEN v_class := 'FIRST';
      ELSIF i <= 15 THEN v_class := 'BUSINESS';
      ELSE v_class := 'ECONOMY';
      END IF;
      INSERT INTO seats(schedule_id, seat_number, seat_class)
      VALUES (s.schedule_id, 'S'||i, v_class);
    END LOOP;
  END LOOP;
  COMMIT;
END;
/

-- Clientes: 1000
BEGIN
  FOR i IN 1..1000 LOOP
    INSERT INTO customers(first_name, last_name, email, phone)
    VALUES ('Name'||i, 'Last'||i, 'cust'||i||'@mail.com', '300'||i);
  END LOOP;
  COMMIT;
END;
/

-- Reservas: 500
BEGIN
  FOR i IN 1..500 LOOP
    INSERT INTO bookings(schedule_id, customer_id, total_amount)
    VALUES (MOD(i,400)+1, MOD(i,1000)+1, ROUND(100+DBMS_RANDOM.VALUE*500,2));
    INSERT INTO booking_items(booking_id, seat_id, fare_amount)
    VALUES (seq_bookings.CURRVAL,
            (SELECT seat_id FROM seats WHERE schedule_id = MOD(i,400)+1 AND ROWNUM=1),
            ROUND(100+DBMS_RANDOM.VALUE*300,2));
    UPDATE seats SET is_available='N'
    WHERE seat_id=(SELECT seat_id FROM seats WHERE schedule_id = MOD(i,400)+1 AND ROWNUM=1);
  END LOOP;
  COMMIT;
END;
/

-- Logs de disponibilidad: 20000
BEGIN
  FOR i IN 1..20000 LOOP
    INSERT INTO availability_log(schedule_id, client_ip)
    VALUES (MOD(i,400)+1, '10.0.0.'||MOD(i,255));
  END LOOP;
  COMMIT;
END;
/

-- =========================
-- 4. Generar estadísticas
-- =========================
BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(USER, CASCADE=>TRUE);
END;
/

-- Consult:
EXPLAIN PLAN FOR
SELECT c.customer_id, c.first_name, COUNT(b.booking_id) AS num_bookings
FROM customers c
JOIN bookings b ON c.customer_id=b.customer_id
GROUP BY c.customer_id, c.first_name
ORDER BY num_bookings DESC FETCH FIRST 10 ROWS ONLY;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX idx_bookings_customer ON bookings(customer_id);

CREATE INDEX idx_customers_customer ON customers(customer_id, first_name);

CREATE INDEX idx_bookings_customer_booking ON bookings(customer_id, booking_id);

DROP INDEX idx_bookings_customer_booking;