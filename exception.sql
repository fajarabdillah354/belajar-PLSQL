--EXCEPTION HANDLING

/*
    Exception Handling dalam PL/SQL adalah mekanisme yang digunakan untuk menangani kesalahan atau situasi yang tidak terduga selama eksekusi program.  
*/

DECLARE 
    v_div NUMBER;
BEGIN
    v_div := 10/0;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error : Pembagian tidak boleh dilakukan dengan zero');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error lain terjadi');
END;
/
