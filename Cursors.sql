SELECT * FROM books;
SELECT * FROM members;

--Eskplisit cursors
DECLARE
    v_copies_book books.total_copies%TYPE;  -- scalar variabel
BEGIN
    SELECT total_copies INTO v_copies_book FROM books
    WHERE book_id = 0;
    DBMS_OUTPUT.PUT_LINE('copies book is : '  || v_copies_book);
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THIS EMPLOYEE');
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('DATA TOO MANY ROW');
END;
/


SELECT * FROM v$parameter WHERE NAME='open_cursors';


SET SERVEROUTPUT ON;

--contoh fetch one column
DECLARE 
vtotal_copies books.total_copies%TYPE;
CURSOR c1 IS SELECT total_copies FROM books;
BEGIN

--open cursors
OPEN c1;

--fetch value from cursors
FETCH c1 INTO vtotal_copies;
DBMS_OUTPUT.PUT_LINE(vtotal_copies);
FETCH c1 INTO vtotal_copies;
DBMS_OUTPUT.PUT_LINE(vtotal_copies);

CLOSE c1;

END;
/


--contoh fetch data multiple column
DECLARE
    v_nick members.first_name%TYPE;
    v_last members.last_name%TYPE;
    CURSOR get_nickname IS
    SELECT first_name, last_name
    FROM members;
BEGIN
    OPEN get_nickname;
    LOOP
        FETCH get_nickname INTO v_nick, v_last;
        EXIT WHEN get_nickname%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_nick || ' ' || v_last);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('row has been execute is : ' ||get_nickname%ROWCOUNT);
    CLOSE get_nickname;
END;
/


--contoh fetch dengn pengkondisian dan dengan mengurutkan data
DECLARE 
    v_memberId members.member_id%TYPE;
    v_email members.email%TYPE;
    v_join members.email%TYPE;
    CURSOR res_member IS
    SELECT member_id, email, join_date FROM members
        ORDER BY join_date DESC;
BEGIN
    OPEN res_member;
    LOOP
        FETCH res_member INTO v_memberId, v_email, v_join;
        EXIT WHEN (res_member%ROWCOUNT > 4 OR res_member%NOTFOUND);
        DBMS_OUTPUT.PUT_LINE('member id : ' || v_memberId || ' ,email : '|| v_email || ' ,join date : '|| v_join);
    END LOOP;
    CLOSE res_member;
END;
/

--cursor for loop, no need open and close cursor
DECLARE
    CURSOR c_member IS
    SELECT email, expiry_date FROM members
    ORDER BY expiry_date DESC;
BEGIN
    FOR rec in c_member LOOP
--        for take some row in the table we use FOR variable is that rec
        DBMS_OUTPUT.PUT_LINE('email member : '|| rec.email || ' ,expiry date member : ' || rec.expiry_date);
    END LOOP;
END;
/



--CURSOR WITH PARAMETER
--we can fetch any data like 2 id in the table
--BELOW EXAMPLE WITHOUT PARAMATER
DECLARE 
    v_first members.first_name%TYPE;
    v_email members.email%TYPE;
    CURSOR c_id1 IS 
        SELECT first_name, email FROM members
        WHERE member_id=2;
    CURSOR c_id2 IS
        SELECT first_name, email FROM members
        WHERE member_id=4; 
BEGIN
    OPEN c_id1;
    LOOP
        FETCH c_id1 INTO v_first, v_email;    
        EXIT WHEN c_id1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_first || ' - ' || v_email);
    END LOOP;
    CLOSE c_id1;
    OPEN c_id2;
    LOOP
        FETCH c_id2 INTO v_first, v_email;
        EXIT WHEN c_id2%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_first|| ' - ' ||v_email);
    END LOOP;
    CLOSE c_id2;
END;
/


--BELOW EXAMPLE WITH PARAMETER
DECLARE 
    v_id NUMBER(10);
    v_first members.first_name%TYPE;
--    we declare cursor with parameter, and give to where condition
    CURSOR c_id1(prm_id_1 NUMBER) IS
        SELECT member_id, first_name FROM members
        WHERE member_id=prm_id_1;
    CURSOR c_id2(prm_id_2 NUMBER) IS
        SELECT member_id, first_name FROM members
        WHERE member_id=prm_id_2;
BEGIN
    OPEN c_id1(2);
    LOOP
        FETCH c_id1 INTO v_id, v_first;
        EXIT WHEN c_id1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_first);
    END LOOP;
    CLOSE c_id1;
    OPEN c_id2(5);
    LOOP
        FETCH c_id2 INTO v_id, v_first;
        EXIT WHEN c_id2%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_first);
    END LOOP;
    CLOSE c_id2;
END;
/

DECLARE 
    CURSOR c_get_book(no_book NUMBER) IS
    SELECT * FROM books
    WHERE book_id = no_book;
BEGIN
    FOR temp in c_get_book(3) LOOP
        DBMS_OUTPUT.PUT_LINE('id book : ' || temp.book_id);
        DBMS_OUTPUT.PUT_LINE('title book : ' || temp.title);
        DBMS_OUTPUT.PUT_LINE('ISBN book : ' || temp.isbn);
    END LOOP;
END;
/


--kita bisa membuat cursor pada 2 table sekaligus, dan otomatis kita bisa nge fetch 2 table sekaligus
DECLARE
    v_member_id NUMBER;
    v_book_title VARCHAR2(100);
    v_expiry_date members.expiry_date%TYPE;
    CURSOR c_member IS
        SELECT member_id, expiry_date FROM members;
    CURSOR c_book IS 
        SELECT title FROM books;
BEGIN
    OPEN c_member;
    DBMS_OUTPUT.PUT_LINE('======== THIS FROM MEMBERS TABLE ========');
    LOOP
        FETCH c_member INTO v_member_id, v_expiry_date;
        EXIT WHEN c_member%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_member_id || ' : ' || v_expiry_date);
    END LOOP;
    CLOSE c_member;
    
    OPEN c_book;
    DBMS_OUTPUT.PUT_LINE('======== THIS FROM BOOKS TABLE =========');
    LOOP
        FETCH c_book INTO v_book_title;
        EXIT WHEN c_book%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('book title : ' || v_book_title);
    END LOOP;
    CLOSE c_book;
END;
/


--###REF CURSOR
--1. STRONG -> USE TYPE AND NEED RETURN VALUE
--2. WEEK

--WEEK EXAMPLE (TIDAK PUNYA RETURN VALUE)

DECLARE
    TYPE ref_cursor IS REF CURSOR;
    TYPE ref_cursor_member IS REF CURSOR;
    rc_member_list ref_cursor_member;
    rc_books_list ref_cursor;
    v_title VARCHAR2(100);
    v_first VARCHAR2(100);
BEGIN
    OPEN rc_books_list 
    FOR SELECT title FROM books;
    DBMS_OUTPUT.PUT_LINE('===== CURSORS FOR TABLE BOOKS ======');
    LOOP
        FETCH rc_books_list INTO v_title;
        EXIT WHEN rc_books_list%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_title);
    END LOOP;
    CLOSE rc_books_list;
    
    OPEN rc_member_list
    FOR SELECT first_name FROM members;
    DBMS_OUTPUT.PUT_LINE('===== CURSORS FOR TABLE MEMBERS ======');
    LOOP
        FETCH rc_member_list INTO v_first;
        EXIT WHEN rc_member_list%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_first);
    END LOOP;
    CLOSE rc_member_list;
END;
/


--STRONG EXAMPLE(PUNYA RETURN VALUE)

DECLARE 
    TYPE ref_cursor_member IS REF CURSOR RETURN members%ROWTYPE;
--    membuat variabel baru dengan type cursor yang telah dibuat
    rc_member ref_cursor_member;
    v_record members%ROWTYPE;
BEGIN
--    yang diopen adalah variabel yang mempunyai type ref cursor yang telah dibuat
    OPEN rc_member FOR SELECT * FROM members;
    LOOP
        FETCH rc_member INTO v_record;
        EXIT WHEN rc_member%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_record.first_name || ' ' || v_record.last_name);
    END LOOP;
    CLOSE rc_member;
END;
/