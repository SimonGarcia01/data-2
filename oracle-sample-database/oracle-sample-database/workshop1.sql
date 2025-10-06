explain plan for select * from customers;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

explain plan for Select * from customers where customer_id = 47;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

explain plan for Select * from customers where customer_id = 50;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

explain plan for Select * from customers where customer_id < 50;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);