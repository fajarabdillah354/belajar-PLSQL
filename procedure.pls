SELECT * FROM tab;
DESC customers;


CREATE VIEW view_contact_customer AS
    SELECT name || ' | ' || phone AS contact FROM customers;
    
SELECT * FROM view_contact_customer;

--PROSEDURE
CREATE OR REPLACE PROCEDURE print_data
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('FAJAR ABDILLAH AHMAD');
    DBMS_OUTPUT.PUT_LINE('JAKARTA TIMUR');
END;
/

--MENAMPILKAN OUTPUT DARI PROSEDURE YANG DIBUAT
SET SERVEROUTPUT ON
BEGIN print_data;
END;
/

--CONTOH MEMBUAT PROCEDURE MENGHITUNG LUAS SEGITIGA
CREATE OR REPLACE PROCEDURE hitung_luas_segitiga
AS
    alas NUMBER(5);
    tinggi NUMBER(5); 
    luas NUMBER(10);
BEGIN
    alas := 10;
    tinggi := 20;
    luas := (alas * tinggi)/2;
    DBMS_OUTPUT.PUT_LINE('segitiga dengan alas ' || alas || ' dan tinggi : '|| tinggi || ' adalah = '|| luas);
END;
/
EXECUTE hitung_luas_segitiga;


--CONTOH PROCEDURE DENGAN PARAMETER
CREATE OR REPLACE PROCEDURE hitung_luas_persegi(s IN NUMBER)
AS
    luas NUMBER(10);
BEGIN
    luas := s*s;
    DBMS_OUTPUT.PUT_LINE('luas persegi dengan sisi : ' || s || ' adalah = ' || luas);
END;
/
EXECUTE hitung_luas_persegi(5);


--CONTOH PROCEDURE DENGAN LOOPING
CREATE OR REPLACE PROCEDURE hitung_loop(jumlah in INTEGER)
AS
    i INTEGER;
BEGIN
    FOR i in 1..jumlah LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/
EXECUTE hitung_loop(20);


--CONTOH KOMBINASI SQL DAN PROCEDURE
CREATE OR REPLACE PROCEDURE total_customer
AS
    total NUMBER;
BEGIN 
    SELECT COUNT(*) INTO total FROM customers;
    DBMS_OUTPUT.PUT_LINE('TOTAL CUSTOMER : ' || total);
END;
/
SET SERVEROUTPUT ON
BEGIN total_customer;
END;
/

DESC customers;
SELECT * FROM customers;
--CONTOH PROCEDURE DENGAN QUERY SQL INSERT
CREATE OR REPLACE PROCEDURE insert_customer(cus_id in customers.customer_id%TYPE, cus_name in customers.name%TYPE, cus_email in customers.email%TYPE, cus_phone in customers.phone%TYPE)
AS
BEGIN
    INSERT INTO customers(customer_id, name, email, phone)
    VALUES(cus_id, cus_name, cus_email, cus_phone);
    DBMS_OUTPUT.PUT_LINE('SUKSES MENAMBAH DATA TABLE CUSTOMERS');
END;
/

EXECUTE insert_customer('cs001', 'BAGAS TRIKORA', 'btriko@gmail.com', '08912312541');