SELECT * FROM authors;



SET SERVEROUTPUT ON;
DECLARE 
    v_author VARCHAR2(100);
    v_author_birth VARCHAR2(20);
BEGIN
    SELECT author_name, birth_date  INTO v_author, v_author_birth FROM authors
    WHERE author_id = 1;
    DBMS_OUTPUT.PUT_LINE('author name is : ' || v_author);
    DBMS_OUTPUT.PUT_LINE('author birth day is : ' || v_author_birth);
END;
/



//Kita bisa mengupdate dengan menggunkan anonymous class
BEGIN
    UPDATE authors SET author_name = 'J.K. Rowlings'
    WHERE author_id=1;
    COMMIT;
END;
/


DECLARE
    a BOOLEAN := False;
BEGIN
    IF a THEN
        DBMS_OUTPUT.PUT_LINE('A Is True');
    ELSE
        DBMS_OUTPUT.PUT_LINE('There''s Not True');
    END IF;
END;
/


DECLARE
    var_a NUMBER := 20;
    var_b NUMBER := 20;
BEGIN
    IF var_a > var_b THEN
        DBMS_OUTPUT.PUT_LINE(var_a ||' greater then '|| var_b);
    ELSIF var_b < var_a THEN
        DBMS_OUTPUT.PUT_LINE(var_b || ' greater then '|| var_a);
    ELSE
        DBMS_OUTPUT.PUT_LINE(var_a || ' equals with ' || var_b);
    END IF;
END;
/

SELECT * FROM books;
DESC books;



SET SERVEROUTPUT ON;
DECLARE
    var_copies NUMBER(10);
    var_book_id NUMBER(10) := &v_id;
BEGIN
    SELECT total_copies INTO var_copies FROM books
    WHERE book_id = var_book_id;
    
    CASE
        WHEN var_copies > 3 THEN
            DBMS_OUTPUT.PUT_LINE('Higher var_copies');
        WHEN var_copies < 3 THEN
            DBMS_OUTPUT.PUT_LINE('Lower var_copies');
        WHEN var_copies = 3 THEN
            DBMS_OUTPUT.PUT_LINE('Standart var_copies');
    END CASE;
END;
/
