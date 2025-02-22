--COMPARISION OPERATOR
/*
    1. LIKE operator
        DENGAN MENGGUNAKAN 
*/


DECLARE 
    PROCEDURE compare(
        value VARCHAR2,
        pattern VARCHAR2
    )
    IS
    BEGIN
        IF value LIKE pattern THEN
            DBMS_OUTPUT.PUT_LINE('TRUE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('FALSE');
        END IF;
    END;
BEGIN
    compare('FAJAR','F%j_r');
    compare('fAjaR', 'F%j_r');
END;
/

SET SERVEROUTPUT ON
BEGIN compare('Fajar','F%j_r');
END;
/


/*
    2. LIKE operator dalam escape character in pattern
*/

DECLARE
PROCEDURE half_off(sale_sign VARCHAR2)
IS
BEGIN
    IF sale_sign LIKE '50\% off!' ESCAPE '\' THEN
        DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END;
BEGIN
    half_off('going wrong');
    half_off('50% off!');
END;
/

/*
    3. BEETWEN OPERATOR
*/
--MEMBUAT PROCEDURE print_boolean() yang selanjutnya di panggil 
CREATE OR REPLACE PROCEDURE print_boolean(b_name VARCHAR2, b_value BOOLEAN) AUTHID DEFINER 
IS
BEGIN
    IF b_value IS NULL THEN
        DBMS_OUTPUT.PUT_LINE(b_name || ' : NULL ');
    ELSIF b_value = TRUE THEN
        DBMS_OUTPUT.PUT_LINE(b_name || ' : TRUE ');
    ELSE
        DBMS_OUTPUT.PUT_LINE(b_name || ' : FALSE ');
    END IF;
END;
/

--memanggil procedure print_boolean
BEGIN
    print_boolean('2 BETWEEN 1 DAN 3', 2 BETWEEN 1 AND 3);
    print_boolean('5 BETWEEN 9 DAN 10', 5 BETWEEN 9 AND 10);
    print_boolean   ('7 BETWEEN 6 DAN 8', 7 BETWEEN 6 AND 8);
END;
/



    

