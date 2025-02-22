--MELIHAT DAFTAR FUNCTION
SELECT object_name FROM user_objects WHERE object_type='FUNCTION';

CREATE OR REPLACE FUNCTION nama_anda
    RETURN VARCHAR2
IS
    nama VARCHAR2(100);
BEGIN
    nama := 'fajar abdillah ahmad';
    RETURN nama;
END;
/
SET SERVEROUTPUT ON;

/*
    Menjalankan function ada 3 cara
    1. dengan EXECUTE DBMS..()
    2. dengan DECLARE, dan BEGIN function_name END;
    3. dengan SELECT nama_function FROM DUAL;
*/

--CONTOH MENJALANAKAN FUNCTION DENGAN CONTOH 1
EXECUTE DBMS_OUTPUT.PUT_LINE(nama_anda);


--CONTOH MENJALANKAN FUNCTION DENGAN CONTOH 2
BEGIN DBMS_OUTPUT.PUT_LINE(nama_anda);
END;
/
--CONTOH MENJALANKAN FUNCTION DENGAN CONTOH 3
--SELECT INTERN.NAMA_ANDA FROM DUAL;


--CONTOH FUNCTION DENGAN PARAMETER
CREATE OR REPLACE FUNCTION faktorial(n IN NUMBER)
    RETURN NUMBER
IS
    //deklarasi semua variabel yang dibutuhkan 
    i NUMBER(2);
    hitung NUMBER(10);
BEGIN 
    hitung := 1;
    FOR i IN 1..n LOOP
        hitung := hitung * i;
    END LOOP;
    RETURN hitung;
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE('hasil faktorial : ' || faktorial(5))