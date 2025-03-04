SELECT SUBSTR('CODEJAR',1,7) FROM DUAL;
SELECT * FROM members;


--CREATE OR REPLACE FUNCTION saldo_hike(p_id IN NUMBER) RETURN NUMBER
--AS
--    v_name members.first_name%TYPE;
--    v_ac members.status%TYPE;
--    v_new NUMBER;
--BEGIN
--    SELECT first_name, status INTO v_name, v_ac FROM  members
--    WHERE member_id = p_id;
--    RETURN v_new;  
--END saldo_hike;

CREATE TABLE employee_info(
    emp_id NUMBER(5) PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL
);


CREATE TABLE emp_address_details(
    emp_address_id NUMBER(5) PRIMARY KEY,
    emp_id NUMBER(5) REFERENCES employee_info(emp_id),
    city VARCHAR2(15),
    state VARCHAR2(15),
    country VARCHAR(20),
    zip_code VARCHAR2(10)
);

SELECT * FROM employee_info;
SELECT * FROM emp_address_details;
DESC emp_address_details;
INSERT INTO employee_info VALUES(01, 'Fajar Abdillah', 'Ahmad');
INSERT INTO employee_info VALUES(02, 'Andi', 'Rasyidin');
INSERT INTO employee_info VALUES(03, 'Sukatni', 'Madaelang');

SET SERVEROUTPUT ON;

INSERT INTO emp_address_details VALUES(01,01, 'Jakarta Timur', 'Jakarta', 'Indonesia', '17411');
INSERT INTO emp_address_details VALUES(02,02, 'Bekasi Barat', 'Kebalen', 'Indonesia', '17690');
INSERT INTO emp_address_details VALUES(03,03, 'Depok Raya', 'Margonda', 'Indonesia', '13912');

COMMIT;

CREATE OR REPLACE FUNCTION get_complete_address(in_emp_id IN NUMBER)
    RETURN VARCHAR2
IS
    v_emp_detail VARCHAR2(150);
BEGIN
    SELECT 'NAME - ' || emp.first_name || ' ' || emp.last_name || ' ,
        CITY- ' || address.city || ' ,State- ' || address.state || ' ,Country- ' || address.country ||
        ',ZIP CODE - ' || address.zip_code
    INTO v_emp_detail
    FROM  employee_info emp, emp_address_details address
    WHERE emp.emp_id = in_emp_id
    AND address.emp_id = emp.emp_id;
    
    RETURN(v_emp_detail);
END;
/

--RUNNING FUNCTION
SELECT get_complete_address(3) AS "emp address" FROM DUAL;
EXECUTE DBMS_OUTPUT.PUT_LINE(get_complete_address(3));

SELECT * FROM customers ORDER BY id DESC;


--CONTOH YANG TIDAK MENGGUNAKAN PARAMETER
CREATE OR REPLACE PROCEDURE insert_cus
AS
BEGIN  
    INSERT INTO customers (customer_id, name, email, phone) VALUES('cs002', 'Raden Fatah', 'rdnfath@gmail.com', '081288328730');
    COMMIT;
END;
/

EXEC insert_cus;



--CONTOH INSERT YANG MENGGUNAKAN PARAMETER
/*
    saat kita ingin meng insert data hanya tinggal memanggil procedure yang telah kita buat
*/
CREATE OR REPLACE PROCEDURE insert_cus_param(id IN NUMBER,cs_id IN VARCHAR2, name IN VARCHAR2, email IN VARCHAR2, phone IN VARCHAR2)
AS
BEGIN
    INSERT INTO customers VALUES(id,cs_id, name, email, phone);
    COMMIT;
END;
/
EXEC insert_cus_param(9, 'cs003', 'Reyna', 'rynaduel@gmail.com', '085709542153');


--CONTOH FUNCTION OVERLOADING (NAMA FUNCTION SAMA HANYA SAJA BEHAVIORNYA BERBEDA)
/*
    dengan function yang sama kita bisa mendapatkan 2 hasil yang berbeda tergantung dengan parameter yang kita berikan
*/
--dibawah ini function untuk melakukan penjumlahan
CREATE OR REPLACE FUNCTION add_num(a NUMBER, b NUMBER) RETURN NUMBER
AS 
    c NUMBER;
BEGIN
    c := a+b;
    RETURN c;
END;
/


--FUNCTION DIBAWAH INI UNTUK MENCARI LUAS SEGITIGA
CREATE OR REPLACE FUNCTION add_num(a NUMBER, b NUMBER, c NUMBER) RETURN NUMBER
AS
    d NUMBER;
BEGIN
    d := (a*b)/2;
    RETURN d;
END;
/

--execute function dengan 2 parameter
SELECT add_num(5,5) FROM DUAL;

--execute function dengan 3 parameter
SELECT add_num(14,31,2) FROM DUAL;


SELECT table_name
FROM user_tables
ORDER BY table_name;


















