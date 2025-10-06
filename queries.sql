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