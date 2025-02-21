CREATE SEQUENCE product_id START WITH 1;
CREATE TABLE customers(
    id NUMBER,
    customer_id VARCHAR2(6),
    name VARCHAR2(100),
    email VARCHAR2(50),
    phone VARCHAR2(20),
    PRIMARY KEY(id)
);

CREATE TABLE products(
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    price NUMBER(10,2),
    stock NUMBER
);

CREATE TABLE ulasan(
    ulasan_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    rating NUMBER,
    tanggal DATE
);

--MEMBUAT AUTOINCREMENT DENGAN SEQUENCE 
CREATE SEQUENCE customer_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

--DROP TRIGGER
DROP TRIGGER customer_id_trigger;
--MEMBUAT TRIGGER UNTUK AUTOINCREMENT
CREATE OR REPLACE TRIGGER customer_id_trigger
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := customer_seq.NEXTVAL;
    END IF;
END;
/

INSERT INTO customers(name, email, phone)
VALUES('Fajar Abdillah Ahmad', 'fajardillah25@gmail.com', '081336412');
INSERT INTO customers(name, email, phone)
VALUES('SYARUL IRAWAN', 'irulwan@gmail.com', '0890215195');
INSERT INTO customers(name, email, phone)
VALUES('DODI SAPUTRA', 'dodi123@gmail.com', '08120125814');
INSERT INTO customers(name, email, phone)
VALUES('UJEH AJADAH', 'ujiehhh@gmail.com', '08023581295');
INSERT INTO customers(name, email, phone)
VALUES('ABDUL HALIM', 'bangdul@gmail.com', '08135912513');

SELECT * FROM customers;

--DML EXAMPLE(ADD NEW COLOMN TO CUSTOMER)
ALTER TABLE customers
ADD alamat VARCHAR2(100);

ALTER TABLE customers
RENAME COLUMN name TO fullname;

DESC customers;

--INDEXING
SELECT index_name, table_name FROM user_indexes WHERE table_name='CUSTOMERS';

--CREATE INDEX
SELECT * FROM customers WHERE name LIKE 'F%';
SELECT COUNT(*) FROM customers;

--MEMBUAT INDEX DARI NAME
CREATE INDEX cus_name ON customers(name); 

--MEMBUAT UNIQUE INDEX DARI EMAIL DI TABLE CUSTOMERS
CREATE UNIQUE INDEX cus_email ON customers(email);

--MENGUBAH NAMA INDEX
/*
ALTER INDEX cus_name RENAME TO unq_name;
ALTER INDEX cus_email RENAME TO unq_email;
*/

--MELIHAT DAFTAR VIEW
SELECT view_name FROM user_views;

--MEMBUAT VIEW 
CREATE VIEW view_customer AS
    SELECT fullname, email FROM customers
    WHERE alamat= 'Radar Selatan';
CREATE VIEW view_name_alamat AS
    SELECT fullname, alamat FROM customers;
    
--MELIHAT STRUKTUR VIEW
DESC view_contact_customer;
DESC view_name_alamat;
--DESC view_customer;
    
--MENAMPILKAN KOLOM fullname dan phone sebagai contact tanpa menggunakan VIEW
SELECT fullname || ' | ' || phone as contact FROM customers;
--TAMPILAN JIKA MENGGUNAKAN VIEW
CREATE VIEW view_contact_customer AS
    SELECT fullname || ' | ' || phone as contact FROM customers;

--MEMANGGIL VIEW YANG TELAH DIBUAT


--MENGHAPUS VIEW
DROP VIEW view_contact_customer;
DROP VIEW view_name_alamat;

--MELIHAT SEMUA RECORD TABLE CUSTOMERS
SELECT *FROM customers;

--INSERT DATA KE DALAM VIEW
--BEGIN
--    INSERT INTO customers(customer_id, name, email, phone)
--    SELECT customer_id.NEXTVAL, name, email, phone
--    FROM(
--        SELECT 'FAJAR ABDILLAH AHMAD', 'fajardillah25@gmail.com', '081336412' FROM DUAL UNION ALL
--        SELECT 'KEVIN MARKLIN', 'kimak@gmail.com', '082362354' FROM DUAL UNION ALL
--        SELECT 'AHMAD FATURROZI', 'ozi@gmail.com', '082512839' FROM DUAL UNION ALL
--        SELECT 'IKHWAN SEDAYU', 'sdy@gmail.com', '081204159' FROM DUAL  
--    );
--    COMMIT;
--END;
--/


--MEMASUKAN DATA KE DALAM TABEL PRODUCTS
INSERT INTO products(product_id, name, price, stock)
VALUES(1, 'ACER NITRO AN515-58', 15000000, 112),
        (2, 'ASUS TUF GAMING 2', 12000000, 101),
        (3, 'ACER HELIOS', 20000000, 68),
        (4, 'DELL ALIENWARE', 30000000, 98),
        (5, 'SAMSUNG NOTE 5', 10000000, 54);


--MELIHAT SEMUA TABLE YANG ADA DI USER 
SELECT * FROM tab;

--MELIHAT DESKRIPSI TABLE CUSTOMERS
DESC customers;

--MELIHAT PROCEDURE
SELECT object_name FROM user_procedures;

DECLARE
    v_name customers.name%type;
BEGIN
    SELECT name INTO  v_name
    FROM customers
    WHERE customer_id = 1;
    
    IF v_name IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('PELANGGAN TIDAK DITEMUKAN');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PELANGGAN DITEMUKAN: '||v_name);
    END IF;
END;
/


SET SERVEROUTPUT ON;
DECLARE 
    v_email VARCHAR2(100) := 'test@gmail.com';
    email VARCHAR2(50);
BEGIN
    SELECT email INTO email FROM customers
    WHERE customer_id=1;
    
    IF v_email <> email THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL TIDAK ADA DI DATABASE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('EMAIL SESUAI: ' ||v_email);
    END IF;
END;
/



--contoh penggunakan ROWTYPE
DECLARE
    user_customer customers%ROWTYPE;
BEGIN
    SELECT * INTO user_customer FROM customers WHERE customer_id = 1;
        
    
    DBMS_OUTPUT.PUT_LINE('id customer : '|| user_customer.customer_id);
    DBMS_OUTPUT.PUT_LINE('nama customer :' || user_customer.name);
    DBMS_OUTPUT.PUT_LINE('email customer :' || user_customer.email);
    DBMS_OUTPUT.PUT_LINE('phone customer :' || user_customer.phone);
END;
/    


/*
HARI 2: SINTANKS DASAR PL/SQL
1. BLOK PL/SQL
Stuktur dasar kode PL/SQL adalah blok yang terdiri dari 
- Section DECLARE(Optional): untuk deklarasi variabel
- Section BEGIN(Wajib): berisi pernyataan eksekusi
- Section EXCEPTION(Optional) : error handle
- Section END(Wajib) : penutup blok
*/

DECLARE
    v_total_customer NUMBER;
    v_company_name VARCHAR2(100) := 'ABC Group';
BEGIN
    SELECT COUNT(*) INTO v_total_customer FROM customers;
    DBMS_OUTPUT.PUT_LINE('JUMLAH PELANGGAN ' || v_company_name || ': ' || v_total_customer);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('TABEL CUSTOMERS TIDAK DITEMUKAN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TERJADI KESALAHAN: '|| SQLERRM);
END;
/


--2. CASE NILAI WITH IF STATEMENT
/*
    bagian struktur kontrol untuk menemukan alur program
*/
DECLARE 
    v_score NUMBER := 60;
    v_grade VARCHAR2(2);
BEGIN
    IF v_score >= 90 THEN
        v_grade := 'A';
    ELSIF v_score >= 70 THEN
        v_grade := 'B';
    ELSIF v_score >= 50 THEN
        v_grade := 'C';
    ELSE
        v_grade := 'D';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('NILAI : ' || v_score || ', GRADE : ' || v_grade);
END;
/


--3. VARIABEL DAN TIPE DATE
/*
    PL/SQL MENDUKUNG BERBAGAI TIPE DATA
    - TIPE SKALAR = NUMBER, VARCHAR2, DATE, BOOLEAN
    - TIPE KOMPOSIT = RECORD, TABLE
    - TIPE REFERENSI = %TYPE, %ROWTYPE
    
    A. %ROWTYPE digunakan untuk membuat variabel yang memiliki struktur yang sama dengan tabel, kita juga bisa menyimpan seluruh baris tabel dalam suatu variabel yang memiliki %ROWTYPE
*/
DECLARE
--    tipe skalar
    v_id NUMBER := 4;
    v_name VARCHAR2(100) := 'SANDY MALDINI';
    v_hiring_date DATE := SYSDATE;
    v_is_active BOOLEAN := TRUE;
    
--    tipe referensi menggunakan %type
    v_email customers.email%type;
    
--    tipe komposit menggunakan %ROWTYPE
    v_customer_rec customers%ROWTYPE;
    
BEGIN
    SELECT * into v_customer_rec
    FROM customers
    WHERE customer_id = v_id;
    
    DBMS_OUTPUT.PUT_LINE('ID : '|| v_id);
    DBMS_OUTPUT.PUT_LINE('NAME : '|| v_name);
    DBMS_OUTPUT.PUT_LINE('EMAIL : '|| v_customer_rec.email);
    DBMS_OUTPUT.PUT_LINE('ALAMAT : '|| v_customer_rec.alamat);
    DBMS_OUTPUT.PUT_LINE('DATE : '|| v_hiring_date);
   
END;
/

--STUDI CASE 1
DECLARE 
    salary NUMBER := 6000;
    commision NUMBER := 0.20;
BEGIN
--    DIVISION HAS HIGHER PRECENDANCE THAN ADDITION;
    DBMS_OUTPUT.PUT_LINE('5 + 12 / 4 = ' || TO_CHAR(5+12/4));
    DBMS_OUTPUT.PUT_LINE('12/4+5 = ' || TO_CHAR(12/4+5));
    
--    PARENTHEHES OVERRIDE DEFAULT OPERATOR PRECENDENCE
    DBMS_OUTPUT.PUT_LINE('8+6/2 = ' || TO_CHAR(8+6/2));
    DBMS_OUTPUT.PUT_LINE('(8+6)/2 = ' || TO_CHAR((8+6)/2));
    
--    MOST DEEPLY NESTED OPERATION IS EVALUATED FIRST
    DBMS_OUTPUT.PUT_LINE('100 + (20/5+(7-3)) = ' || TO_CHAR(100+(20/5+(7-3))));
    
--    PARENTHESES, EVEN WHEN UNNECESSERY, IMPOVE READABILITY
    DBMS_OUTPUT.PUT_LINE('(salary * 0.10) + (commision * 0.25) = ' || TO_CHAR((salary * 0.10) + (commision * 0.25)));
END;
/
    
--HARI 3: CURSOR


