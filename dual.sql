--CONTOH PENGGUNAAN DUAL
/*
    DUAL adalah bagian dari sys db yang bertujuan untuk membuat dumy data dari suatu table,
    meskipus data yang dicari tidak ada di dalam database kita bisa membuatnya seolah2 ada dengan menggunakan DUAL
*/
SELECT 'fajar abdillah ahmad' FROM DUAL;



/*
    dengan menggunakan SUBSTR(String, start, end) kita bisa mengambil data yang ingin kita ambil
*/
SELECT SUBSTR('FAJAR ABDILLAH AHMAD', 4, 6) AS fullname FROM DUAL;
SELECT SUBSTR('BASA SIMANJUNTAK', -1, 5) AS fullname FROM DUAL;



--STUDI KASUS MEMBUAT SEGITIGA dengan menggunakan procedure
--SELECT        
--*
--**
--***
--****
CREATE OR REPLACE PROCEDURE asterik(jml in NUMBER)
AS
BEGIN
    FOR i IN 1..jml LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD('*', i, '*' ));
    END LOOP;
END;
/ 1
SET SERVEROUTPUT ON;
EXECUTE asterik(5);

--MENDAPATKAN TANGGAL DARI SISTEM 
SELECT SYSDATE  AS datanow FROM DUAL;   
    




