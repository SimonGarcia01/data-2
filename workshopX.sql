--Create Customer dimension table in Data Warehouse which will hold customer personal details.
Create table DimCustomer
(
CustomerID int primary key,
CustomerAltID varchar(10) not null,
CustomerName varchar(50),
Gender varchar(20)
);

--Create sequence and trigger to generate surrogate key for Customer dimension table.
Create sequence DimCustomerSeq
start with 1
increment by 1
minvalue 1
maxvalue 999999999999999999999999999;

create or replace trigger DimCustomerSeqTrigger
before insert on DimCustomer
for each row
    when (new.CustomerID is null)
begin
    :new.CustomerID := DimCustomerSeq.NEXTVAL;
end;
/         

--Create basic level of Product Dimension table without considering any Category or Subcategory
Create table DimProduct(
ProductKey int primary key,
ProductAltKey varchar(10)not null,
ProductName varchar(100),
ProductActualCost Numeric(10,2),
ProductSalesCost Numeric(10,2)
);

--Create sequence and trigger to generate surrogate key for Product dimension table.
Create sequence DimProductSeq
start with 1
increment by 1
minvalue 1
maxvalue 999999999999999999999999999;

create or replace trigger DimProductSeqTrigger
before insert on DimProduct
for each row
    when (new.ProductKey is null)
begin
    :new.ProductKey := DimProductSeq.NEXTVAL;
end;        
/

--Create Store Dimension table which will hold details related stores available across various places.
Create table DimStores(
StoreID int primary key,
StoreAltID varchar(10)not null,
StoreName varchar(100),
StoreLocation varchar(100),
City varchar(100),
State varchar(100),
Country varchar(100)
);

--Create sequence and trigger to generate surrogate key for Product dimension table.
Create sequence DimStoresSeq
start with 1
increment by 1
minvalue 1
maxvalue 999999999999999999999999999;

create or replace trigger DimStoresSeqTrigger
before insert on DimStores
for each row
    when (new.StoreID is null)
begin
    :new.StoreID := DimStoresSeq.NEXTVAL;
end;
/
--Create Dimension Sales Person table which will hold details related stores available across various places.
Create table DimSalesPerson(
SalesPersonID int primary key,
SalesPersonAltID varchar(10)not null,
SalesPersonName varchar(100),
StoreID int,
City varchar(100),
State varchar(100),
Country varchar(100)
);

--Create sequence and trigger to generate surrogate key for Sales Person dimension table.
Create sequence DimSalesPersonSeq
start with 1
increment by 1
minvalue 1
maxvalue 999999999999999999999999999;

create or replace trigger DimSalesPersonSeqTrigger
before insert on DimSalesPerson
for each row
    when (new.SalesPersonID is null)
begin
    :new.SalesPersonID := DimSalesPersonSeq.NEXTVAL;
end;
/


--Fill the Customer dimension with sample Values
Insert into DimCustomer(CustomerAltID,CustomerName,Gender)values ('IMI-001','Henry Ford','M');
Insert into DimCustomer(CustomerAltID,CustomerName,Gender)values ('IMI-002','Bill Gates','M');
Insert into DimCustomer(CustomerAltID,CustomerName,Gender)values ('IMI-003','Muskan Shaikh','F');
Insert into DimCustomer(CustomerAltID,CustomerName,Gender)values ('IMI-004','Richard Thrubin','M');
Insert into DimCustomer(CustomerAltID,CustomerName,Gender)values ('IMI-005','Emma Wattson','F');

--Fill the Product dimension with sample Values
Insert into DimProduct(ProductAltKey,ProductName, ProductActualCost, ProductSalesCost)values('ITM-001','Wheat Floor 1kg',5.50,6.50);
Insert into DimProduct(ProductAltKey,ProductName, ProductActualCost, ProductSalesCost)values('ITM-002','Rice Grains 1kg',22.50,24);
Insert into DimProduct(ProductAltKey,ProductName, ProductActualCost, ProductSalesCost)values('ITM-003','SunFlower Oil 1 ltr',42,43.5);
Insert into DimProduct(ProductAltKey,ProductName, ProductActualCost, ProductSalesCost)values('ITM-004','Nirma Soap',18,20);
Insert into DimProduct(ProductAltKey,ProductName, ProductActualCost, ProductSalesCost)values('ITM-005','Arial Washing Powder 1kg',135,139);

--Fill the Store Dimension with sample Values
Insert into DimStores(StoreAltID,StoreName,StoreLocation,City,State,Country )values ('LOC-A1','X-Mart','S.P. RingRoad','Ahmedabad','Guj','India');
Insert into DimStores(StoreAltID,StoreName,StoreLocation,City,State,Country )values ('LOC-A2','X-Mart','Maninagar','Ahmedabad','Guj','India');
Insert into DimStores(StoreAltID,StoreName,StoreLocation,City,State,Country )values ('LOC-A3','X-Mart','Sivranjani','Ahmedabad','Guj','India');

--Fill the Dimension Sales Person with sample values:
Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values ('SP-DMSPR1','Ashish',1,'Ahmedabad','Guj','India');
Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values ('SP-DMSPR2','Ketan',1,'Ahmedabad','Guj','India');
Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values ('SP-DMNGR1','Srinivas',2,'Ahmedabad','Guj','India');
Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values ('SP-DMNGR2','Saad',2,'Ahmedabad','Guj','India');
Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values ('SP-DMSVR1','Jasmin',3,'Ahmedabad','Guj','India');
Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values ('SP-DMSVR2','Jacob',3,'Ahmedabad','Guj','India');



--Facts Table
--Facts Table
Create Table FactProductSales(
TransactionId int primary key,
SalesInvoiceNumber int not null,
StoreID int not null,
CustomerID int not null,
ProductID int not null,
SalesPersonID int not null,
Quantity float,
SalesTotalCost Numeric(10,2),
ProductActualCost Numeric(10,2),
Deviation float
);
--Create sequence and trigger to generate surrogate key for Facts table.
Create sequence FactsSeq
start with 1
increment by 1
minvalue 1
maxvalue 999999999999999999999999999;

create or replace trigger FactProductSalesSeqTrigger
before insert on FactProductSales
for each row
    when (new.TransactionId is null)
begin
    :new.TransactionId := FactsSeq.NEXTVAL;
end;
/

-- Add relation between fact table foreign keys to Primary keys of Dimensions
AlTER TABLE FactProductSales ADD CONSTRAINT 
FK_StoreID FOREIGN KEY (StoreID)REFERENCES DimStores(StoreID);
AlTER TABLE FactProductSales ADD CONSTRAINT 
FK_CustomerID FOREIGN KEY (CustomerID)REFERENCES Dimcustomer(CustomerID);
AlTER TABLE FactProductSales ADD CONSTRAINT 
FK_ProductKey FOREIGN KEY (ProductID)REFERENCES Dimproduct(ProductKey);
AlTER TABLE FactProductSales ADD CONSTRAINT 
FK_SalesPersonID FOREIGN KEY (SalesPersonID)REFERENCES Dimsalesperson(SalesPersonID);

--Making sure that the info is not deleted
-- COMMIT;

-- Fact table is missing the SALESDATEKEY so it can be realted to the DIMDATE table
ALTER TABLE FactProductSales ADD SalesDateKey number;

-- Scripts for the DimDate table
--drop table dimdate;
CREATE TABLE DIMDATE AS 
WITH base_calendar AS
(
    SELECT
        --newid
        TO_NUMBER(TO_CHAR(currdate, 'YYYY') || LPAD(TO_CHAR(EXTRACT(MONTH FROM currdate)), 2, '0') || LPAD(TO_CHAR(EXTRACT(DAY FROM currdate)), 2, '0')) AS dateKey,
		currdate AS day_id,
        INITCAP(RTRIM(TO_CHAR(currdate,'MONTH'))) ||' ' || TO_CHAR(currdate,'DD') || ', ' || RTRIM(TO_CHAR(currdate,'YYYY')) AS day_name,
        1 AS num_days_in_day,
        currdate AS day_end_date,
        TO_CHAR(currdate,'Day') AS week_day_full,
        TO_CHAR(currdate,'DY') AS week_day_short,
        to_number(TRIM(LEADING '0' FROM TO_CHAR(currdate,'D'))) AS day_num_of_week,
        to_number(TRIM(LEADING '0' FROM TO_CHAR(currdate,'DD'))) AS day_num_of_month,
        to_number(TRIM(LEADING '0' FROM TO_CHAR(currdate,'DDD'))) AS day_num_of_year,
        initcap(TO_CHAR(currdate,'Mon') || '-' || TO_CHAR(currdate,'YY')) AS month_id,
        TO_CHAR(currdate,'Mon') || ' ' || TO_CHAR(currdate,'YYYY') AS month_short_desc,
        rtrim(TO_CHAR(currdate,'Month')) || ' ' || TO_CHAR(currdate,'YYYY') AS month_long_desc,
        TO_CHAR(currdate,'Mon') AS month_short,
        TO_CHAR(currdate,'Month') AS month_long,
        to_number(TRIM(LEADING '0' FROM TO_CHAR(currdate,'MM'))) AS month_num_of_year,
        'Q' || upper(TO_CHAR(currdate,'Q') || TO_CHAR(currdate,'YYYY')) AS quarter_id,
        'Q' || upper(TO_CHAR(currdate,'Q') || '-' || TO_CHAR(currdate,'YYYY')) AS quarter_name,
        to_number(TO_CHAR(currdate,'Q') ) AS quarter_num_of_year,
        CASE
            WHEN to_number(TO_CHAR(currdate,'Q') ) <= 2 THEN 1
            ELSE 2
        END AS half_num_of_year,
        CASE
            WHEN to_number(TO_CHAR(currdate,'Q') ) <= 2
                THEN 'H' || 1 || '-' || TO_CHAR(currdate,'YYYY')
            ELSE 'H' || 2 || '-' || TO_CHAR(currdate,'YYYY')
        END AS half_of_year_id,
        TO_CHAR(currdate,'YYYY') AS year_id
    FROM
    (
        SELECT
            level n,
            TO_DATE('31/12/2018','DD/MM/YYYY') + numtodsinterval(level,'DAY') currdate
        FROM
            dual
        CONNECT BY
            level <= 1461
    )
) 
SELECT
    -- Nueva columna dateId en formato YYYYMMDD
    dateKey AS dateKey,
	day_id AS fulldate,
    day_name AS day_name,
    num_days_in_day AS num_days_in_day,
    day_end_date AS day_end_date,
    day_num_of_week AS day_num_of_week,
    day_num_of_month AS day_num_of_month,
    day_num_of_year AS day_number_in_year,
    day_num_of_month AS day_number_in_month,
    day_num_of_week AS day_number_in_week,
    month_id AS month_id,
    month_id AS month_name,
    COUNT(*) OVER(PARTITION BY month_id) AS month_time_span,
    MAX(day_id) OVER(PARTITION BY month_id) AS month_end_date,
    month_num_of_year AS month_number_in_year,
    quarter_id AS quarter_id,
    quarter_name AS quarter_name,
    COUNT(*) OVER(PARTITION BY quarter_id) AS quarter_time_span,
    MAX(day_id) OVER(PARTITION BY quarter_id) AS quarter_end_date,
    quarter_num_of_year AS quarter_number_in_year,
    year_id AS year_id,
    year_id AS year_name,
    COUNT(*) OVER(PARTITION BY year_id) AS num_days_in_year,
    MAX(day_id) OVER(PARTITION BY year_id) AS year_end_date
FROM
    base_calendar
ORDER BY
    dateKey;


-- Add the primary key to the dimdate table
alter table DimDate add primary key (dateKey);

-- falta la regla de integridad para establecer la FK. Crearla.

AlTER TABLE FactProductSales ADD CONSTRAINT 
FK_SalesDateKey FOREIGN KEY (SalesDateKey)REFERENCES DimDate(DateKey);


-- Now insert information of the fact table
-- Generated by copilot
-- 1-jan-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (1,1,1,1,1,2,11,13,2,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (1,1,1,2,1,1,22.50,24,1.5,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (1,1,1,3,1,1,42,43.5,1.5,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (2,1,2,3,1,1,42,43.5,1.5,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (2,1,2,4,1,3,54,60,6,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (3,1,3,2,2,2,11,13,2,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (3,1,3,3,2,1,42,43.5,1.5,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (3,1,3,4,2,3,54,60,6,20190101);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (3,1,3,5,2,1,135,139,4,20190101);

-- 2-jan-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (4,1,1,1,1,2,11,13,2,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (4,1,1,2,1,1,22.50,24,1.5,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (5,1,2,3,1,1,42,43.5,1.5,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (5,1,2,4,1,3,54,60,6,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (6,1,3,2,2,2,11,13,2,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (6,1,3,5,2,1,135,139,4,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (7,2,1,4,3,3,54,60,6,20190102);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (7,2,1,5,3,1,135,139,4,20190102);

-- 3-jan-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (8,1,1,3,1,2,84,87,3,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (8,1,1,4,1,3,54,60,3,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (9,1,2,1,1,1,5.5,6.5,1,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (9,1,2,2,1,1,22.50,24,1.5,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (10,1,3,1,2,2,11,13,2,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (10,1,3,4,2,3,54,60,6,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (11,2,1,2,3,1,5.5,6.5,1,20190103);

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (11,2,1,3,3,1,42,43.5,1.5,20190103);

-- 3-feb-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (103,2,3,1,3,4,30.00,40.00,10.00,20190203);

-- 10-feb-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (106,3,3,5,1,6,18.00,22.00,4.00,20190210);

-- 17-feb-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (109,1,3,4,1,4,22.00,27.00,5.00,20190217);

-- 24-feb-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (112,3,3,2,3,2,14.50,18.50,4.00,20190224);

-- 1-apr-2019
Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (112,3,3,2,3,2,14.50,18.50,4.00,20190401);

-- commit to make sure all date is saved
-- COMMIT;

--Gathering info to insert in the fact table
--Making the insert of feb 15 2025
INSERT INTO DIMDATE (
    DATEKEY,
    FULLDATE,
    DAY_NAME,
    NUM_DAYS_IN_DAY,
    DAY_END_DATE,
    DAY_NUM_OF_WEEK,
    DAY_NUM_OF_MONTH,
    DAY_NUMBER_IN_YEAR,
    DAY_NUMBER_IN_MONTH,
    DAY_NUMBER_IN_WEEK,
    MONTH_ID,
    MONTH_NAME,
    MONTH_TIME_SPAN,
    MONTH_END_DATE,
    MONTH_NUMBER_IN_YEAR,
    QUARTER_ID,
    QUARTER_NAME,
    QUARTER_TIME_SPAN,
    QUARTER_END_DATE,
    QUARTER_NUMBER_IN_YEAR,
    YEAR_ID,
    NUM_DAYS_IN_YEAR,
    YEAR_END_DATE
) VALUES (
    20250215,                                     
    TO_DATE('2025-02-15', 'YYYY-MM-DD'),          
    'February 15, 2025',                          
    1,                                            
    TO_DATE('2025-02-15', 'YYYY-MM-DD'),          
    7,                                            
    15,                                           
    46,                                           
    15,                                           
    7,                                            
    'Feb-25',                                     
    'February',                                   
    28,                                           
    TO_DATE('2025-02-28', 'YYYY-MM-DD'),          
    2,                                            
    'Q12025',                                     
    'Q1-2025',                                    
    90,                                           
    TO_DATE('2025-03-31', 'YYYY-MM-DD'),          
    1,                                            
    '2025',                                       
    365,                                          
    TO_DATE('2025-12-31', 'YYYY-MM-DD')
);


-- Foreign keys
-- sales date key 15 feb 2025 20250215
-- CustomerID 1
-- sales person ID 1
-- store ID 1
-- product key 1
-- actual cost 5.5
-- sales cost 6.5
-- product key 2
-- actual cost 22.5
-- sales cost 24
-- Deviation = total cost - sales cost

Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (500,1,1,1,1,1,5.5,6.5,1.00,20250215);


Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (500,1,1,2,1,2,45,48,3.00,20190215);


Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (501,1,1,1,1,3,16.5,19.5,3.00,20190215);


Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (501,1,1,2,1,3,67.5,72,4.5,20190215);


Insert into FactProductSales(
    SalesInvoiceNumber, StoreID, CustomerID, ProductID, SalesPersonID,
    Quantity, ProductActualCost, SalesTotalCost, Deviation, SalesDateKey
) values (1001,1,1,1,1,1,5.5,6.5,1.00,20190215);

-- To visualize the last data added
-- commit;

-- QUERIES SECTION

-- Necesidad de visualizar las ganancias diarias, semanales, mensuales y trimestrales de cada tienda
--For daily profit
SELECT f.storeid, d.fulldate AS Fecha, SUM(f.salestotalcost - f.productactualcost) AS daily_profit
FROM factproductsales f
JOIN dimdate d ON f.salesdatekey = d.datekey
GROUP BY f.storeid, d.fulldate
ORDER BY f.storeid, d.fulldate;

--Completly done by copilot, had no idea how to do it
-- for weekly profit
SELECT f.storeid, TO_CHAR(d.fulldate, 'YYYY') AS year, TO_CHAR(d.fulldate, 'WW') AS week,
    SUM(f.salestotalcost - f.productactualcost) AS weekly_profit
FROM factproductsales f
JOIN dimdate d ON f.salesdatekey = d.datekey
GROUP BY f.storeid, TO_CHAR(d.fulldate, 'YYYY'), TO_CHAR(d.fulldate, 'WW')
ORDER BY f.storeid, year, week;

-- for monthly profit
SELECT f.storeid, d.month_id, SUM(f.salestotalcost - f.productactualcost) AS monthly_profit
FROM factproductsales f
JOIN dimdate d ON f.salesdatekey = d.datekey
GROUP BY f.storeid, d.month_id
ORDER BY f.storeid, d.month_id;

-- for quaterly profit
SELECT f.storeid, d.quarter_name, SUM(f.salestotalcost - f.productactualcost) AS quaterly_profit
FROM factproductsales f
JOIN dimdate d ON f.salesdatekey = d.datekey
GROUP BY f.storeid, d.quarter_name
ORDER BY f.storeid, d.quarter_name;


-- Identificar cuál producto tiene más demanda en cada ubicación.
CREATE OR REPLACE PROCEDURE get_top_product_by_store IS
    
    CURSOR c_top_product IS
        SELECT s.storelocation, p.productname
        FROM (
            SELECT storeid, productid
            FROM (
                SELECT storeid, productid, SUM(quantity) AS total_quantity
                FROM factproductsales
                GROUP BY storeid, productid
            )
            WHERE (storeid, total_quantity) IN (
                SELECT storeid, MAX(total_quantity)
                FROM (
                    SELECT storeid, productid, SUM(quantity) AS total_quantity
                    FROM factproductsales
                    GROUP BY storeid, productid
                )
                GROUP BY storeid
            )
        ) top
        JOIN dimstores s ON top.storeid = s.storeid
        JOIN dimproduct p ON top.productid = p.productkey;

    v_store_location VARCHAR2(100);
    v_product_name VARCHAR2(100);

    BEGIN
        OPEN c_top_product;
        LOOP
            FETCH c_top_product INTO v_store_location, v_product_name;
            
            EXIT WHEN c_top_product%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(v_store_location || ' - ' || v_product_name);
        END LOOP;
        CLOSE c_top_product;
    END;

BEGIN
    get_top_product_by_store();
END;


-- Obtener las ventas y ganancias de cada domingo de 2019.
SELECT f.storeid, d.fulldate, SUM(f.salestotalcost) AS total_sales, SUM(f.salestotalcost - f.productactualcost) AS profit
FROM factproductsales f
JOIN dimdate d ON f.salesdatekey = d.datekey
WHERE d.year_id = 2019 AND d.day_num_of_week = 1 -- apparently sunday is the 1 of the week
GROUP BY f.storeid, d.fulldate
ORDER BY f.storeid, d.fulldate;

-- Save everything
-- commit;