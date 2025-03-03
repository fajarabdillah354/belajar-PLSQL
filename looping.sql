--SIMPLE LOOP

SET SERVEROUTPUT ON;
DECLARE 
    c NUMBER:=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('PAGE ' ||C|| ' OF 20');
        c:=c+1;
    EXIT WHEN C>20; 
    END LOOP;
END;
/



--WHILE LOOP
DECLARE
    v_absen NUMBER := 1;
BEGIN
    WHILE(v_absen < 10)
        LOOP
            v_absen := v_absen +1;
            DBMS_OUTPUT.PUT_LINE('Absen ke ' || v_absen);
        END LOOP;
END;
/



--FOR LOOP
DECLARE 
--    deklarasi variabel 
    c1 NUMBER;
BEGIN
--    fungsi reverse digunakan untuk membalik reverse yang ada
    FOR c1 in REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('looping ke - ' || c1);
    END LOOP;
END;
/