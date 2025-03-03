SELECT * FROM rekening;
SELECT * FROM transfer;

INSERT INTO rekening VALUES(1004, 'Raden Srilanggit', 'Jakarta', TO_DATE('01-04-1996', 'dd-mm-yyyy'), 'Jalan Cempaka Putih 4 RT003/011 Jakarta Pusat', 23000 );
INSERT INTO rekening VALUES(1005, 'Ahmad Thoha', 'Jakarta', TO_DATE('12-02-1990', 'dd-mm-yyyy'), 'Jalan Kebon Bawang 3 TRS/9 Jakarta Utara', 41000 );
INSERT INTO rekening VALUES(1006, 'Junaedi Siregar', 'Jakarta', TO_DATE('30-04-1998', 'dd-mm-yyyy'), 'Jalan Swasembada Timur3 RT002/004 Jakarta Utara', 41000 );

INSERT INTO rekening VALUES(1007, 'Royan Firdaus', 'Jakarta', TO_DATE('17-02-2001', 'dd-mm-yyyy'), 'Jalan Pattimura RT001/012', 34500 );
INSERT INTO rekening VALUES(1008, 'Adam Subarkah', 'Semarang', TO_DATE('16-09-1999', 'dd-mm-yyyy'), 'Jalan Telonlang TRS/1 Semarang', 41000 );
INSERT INTO rekening VALUES(1009, 'Sakir', 'Bandung', TO_DATE('01-02-2000', 'dd-mm-yyyy'), 'Jalan Cimahi Kebangsan RT001/03 Bandung', 20000 );


SET SERVEROUTPUT ON;
DECLARE 
    v_nasabah rekening.nama_nasabah%type;
    v_saldo rekening.saldo%type;
    CURSOR c_rek_nasabah IS
    SELECT nama_nasabah, saldo FROM rekening
    WHERE nomor_rekening=1005;
BEGIN
    OPEN c_rek_nasabah;
        LOOP
        FETCH c_rek_nasabah INTO v_nasabah, v_saldo;
        EXIT WHEN c_rek_nasabah%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Data nasabah : '|| v_nasabah || ' - ' || v_saldo);
        END LOOP;
    CLOSE c_rek_nasabah;
END;
/


DECLARE
    CURSOR c_rek IS
    SELECT nomor_rekening, nama_nasabah, alamat FROM rekening;
BEGIN
        FOR temp in c_rek LOOP
            DBMS_OUTPUT.PUT_LINE('n_rek : '|| temp.nomor_rekening || ' ,Nama Nasabah : ' || temp.nama_nasabah || ' , Alamat : ' || temp.alamat);
        END LOOP;
END;
/



CREATE OR REPLACE PROCEDURE p_saldo(p_saldo IN NUMBER) 
AS
    v_saldo NUMBER;
    v_total NUMBER;
BEGIN
    v_saldo := p_saldo;
    IF v_saldo > 20000 THEN
        DBMS_OUTPUT.PUT_LINE('nabasah golongan priority');
    ELSIF v_saldo < 20000 THEN
        DBMS_OUTPUT.PUT_LINE('nabasah bukan priority');
    END IF;
END;
/

EXECUTE p_saldo(90000);

SELECT * FROM all_procedures;





--CONTOH CURSOR DALAM PROCEDURE
CREATE OR REPLACE PROCEDURE get_member
IS
    v_name rekening.nama_nasabah%type;
    v_saldo rekening.saldo%type;
    CURSOR c1 IS
    SELECT nama_nasabah, saldo FROM rekening
    WHERE ROWNUM<=3;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_name, v_saldo;
        EXIT WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ' : ' || v_saldo);
    END LOOP;
END;
/

execute get_member;





