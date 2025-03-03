--STUDI KASUS: SISTEM MANAJEMEN PERPUSTAKAAN

SELECT * FROM tab;

--TABLE KATEGORI
CREATE TABLE categories(
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL,
    description VARCHAR2(200)
);

--TABLE PENULIS
CREATE TABLE authors(
    author_id NUMBER PRIMARY KEY,
    author_name VARCHAR2(100) NOT NULL,
    birth_date DATE,
    country VARCHAR2(50)
);

--TABLE BUKU
CREATE TABLE books(
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    isbn VARCHAR2(20) UNIQUE,
    published_date DATE,
    category_id NUMBER,
    available_copies NUMBER DEFAULT 0,
    total_copies NUMBER DEFAULT 0,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


--TABLE RELASI BUKU-PENULIS
CREATE TABLE book_authors(
    book_id NUMBER,
    author_id NUMBER,
    CONSTRAINT pk_book_authors PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_book FOREIGN KEY(book_id) REFERENCES books(book_id),
    CONSTRAINT fk_author FOREIGN KEY(author_id) REFERENCES authors(author_id)
);


--TABLE ANGGOTA 
CREATE TABLE members(
    member_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    join_date DATE DEFAULT SYSDATE,
    expiry_date DATE,
    status VARCHAR2(20) DEFAULT 'ACTIVE'
);



--TABLE PEMINJAM
CREATE TABLE loans(
    loan_id NUMBER PRIMARY KEY,
    book_id NUMBER,
    member_id NUMBER,
    loan_date DATE DEFAULT SYSDATE,
    due_date DATE,
    return_date DATE,
    fine_amount NUMBER(10,2) DEFAULT 0,
    CONSTRAINT fk_loan_book FOREIGN KEY(book_id) REFERENCES books(book_id),
    CONSTRAINT fk_loan_member FOREIGN KEY(member_id) REFERENCES members(member_id)  
);


--TABLE LOG ACTIVITY
CREATE TABLE activity_logs(
    log_id NUMBER PRIMARY KEY,
    activity_type VARCHAR2(50) NOT NULL,
    activity_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    description VARCHAR2(200),
    user_id NUMBER
);


--SEQUENCE ID
CREATE SEQUENCE category_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE author_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE book_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE member_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE loan_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE log_seq START WITH 1 INCREMENT BY 1;


--TRIGGER 

--TRIGGER UNTUK UPDATE JUMLAH BUKU
CREATE OR REPLACE TRIGGER update_book_availability
AFTER INSERT OR UPDATE ON loans
FOR EACH ROW
DECLARE
    v_increment NUMBER := 0;
BEGIN 
    IF :NEW.return_date IS NULL AND :OLD.return_date IS NULL AND :NEW.loan_date IS NOT NULL THEN
        v_increment := -1;
    ELSIF :NEW.return_date IS NOT NULL AND :OLD.return_date IS NULL THEN
        v_increment := 1;
    END IF;
    
    IF v_increment != 0 THEN
        UPDATE books
        SET available_copies = available_copies + v_increment
        WHERE book_id = :NEW.book_id;
    END IF;
END;
/    
   

--TRIGGER UNTUK MENGHITUNG DENDA 
CREATE OR REPLACE TRIGGER calculate_fine
BEFORE UPDATE ON loans
FOR EACH ROW
WHEN(NEW.return_date IS NOT NULL AND OLD.return_date IS NULL)
DECLARE
    v_days_late NUMBER;
    v_fine_per_day NUMBER := 1.00;
BEGIN
    IF :NEW.return_date > :NEW.due_date THEN 
        v_days_late := :NEW.return_date - :NEW.due_date;
        :NEW.fine_amount := v_days_late * v_fine_per_day;
    ELSE 
        :NEW.fine_amount := 0;
    END IF;
END;
/


--TRIGGER UNTUK LOGGING
CREATE OR REPLACE TRIGGER log_member_activity
AFTER UPDATE OR INSERT OR DELETE ON members
FOR EACH ROW
DECLARE
    v_activity VARCHAR2(50);
    v_description VARCHAR2(200);
BEGIN
    IF INSERTING THEN 
        v_activity := 'INSERT';
        v_description := 'new member added : '|| :NEW.first_name || ' ' || :NEW.last_name;
    ELSIF UPDATING THEN
        v_activity := 'UPDATE';
        v_description := 'member updated : ' || :NEW.first_name || ' ' || :NEW.last_name;
    ELSIF DELETING THEN
        v_activity := 'DELETE';
        v_description := 'member deleted : ' || :OLD.first_name || ' ' || :OLD.last_name;   
    END IF;
    
    INSERT INTO activity_logs(log_id, activity_type, description)
    VALUES(log_seq.NEXTVAL, v_activity, v_description);
END;
/
 

--PROCEDURE UNTUK PEMINJAMAN BUKU
CREATE OR REPLACE PROCEDURE borrow_book(
    p_book_id IN NUMBER,
    p_member_id IN NUMBER,
    p_days IN NUMBER DEFAULT 14,
    p_loan_id OUT NUMBER
)
IS
    v_available NUMBER;
    v_member_status VARCHAR2(20);
    v_outstanding_loans NUMBER;
    e_no_copies EXCEPTION;
    e_inactive_member EXCEPTION;
    e_too_many_loans EXCEPTION;
BEGIN
--    CEK KESEDIAN BUKU
    SELECT available_copies INTO v_available
    FROM books
    WHERE book_id = p_book_id;
    
    IF v_available <= 0 THEN
        RAISE e_no_copies;
    END IF;

--    CEK STATUS MEMBER
    SELECT status INTO v_member_status
    FROM members
    WHERE member_id = p_member_id;
    
    IF v_member_status != 'ACTIVE' THEN
        RAISE e_inactive_member;
    END IF;
    
--    CEK JUMLAH PEMINJAMAN
    SELECT COUNT(*) INTO v_outstanding_loans 
    FROM loans
    WHERE member_id = p_member_id AND return_date IS NULL;
    
    
    IF v_outstanding_loans >= 5 THEN
        RAISE e_too_many_loans;
    END IF;
    
--    PROSES PEMINJAMAN
    p_loan_id := loan_seq.NEXTVAL;    
    INSERT INTO loans(loan_id, book_id, member_id, loan_date, due_date)
    VALUES(p_loan_id, p_book_id, p_member_id,SYSDATE, SYSDATE + p_days);
    
--    LOG AKTIVITAS
    INSERT INTO activity_logs(log_id, activity_type, description, user_id)
    VALUES(log_seq.NEXTVAL, 'Borrow', 'Book borrow : ' || p_book_id, p_member_id);
    COMMIT;
    
EXCEPTION
    WHEN e_no_copies THEN
        RAISE_APPLICATION_ERROR(-20001, 'No copies available for borrowing');
    WHEN e_inactive_member THEN
        RAISE_APPLICATION_ERROR(-20002, 'Member is not active');
    WHEN e_too_many_loans THEN
        RAISE_APPLICATION_ERROR(-20003, 'Member has too many outstanding loans');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/


--PROCEDURE PENGEMBALIAN BUKU
CREATE OR REPLACE PROCEDURE return_book(
    p_loan_id IN NUMBER,
    p_fine_paid OUT NUMBER
)
IS
    v_return_date DATE;
    v_due_date DATE;
BEGIN
--    CEK STATUS PEMINJAMAN

    SELECT return_date, due_date INTO v_return_date, v_due_date
    FROM loans
    WHERE loan_id = p_loan_id;
    
    IF v_return_date IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Book already returned');
    END IF;
    
--    PROSES PENGEMBALIAN
    UPDATE loans
    SET return_date = SYSDATE
    WHERE loan_id = p_loan_id;

--    AMBIL FINE_AMOUNT (trigger calculate_fine akan berjalan)
    SELECT fine_amount INTO p_fine_paid
    FROM loans
    WHERE loan_id = p_loan_id;
    
--    LOG AKTIVITAS
    INSERT INTO activity_logs(log_id, activity_type, description)
    VALUES(log_seq.NEXTVAL, 'RETURN', 'Book returned : Loan ID ' || p_loan_id);
    
    COMMIT;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Loan record not found');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

--FUNCTION UNTUK MENGHITUNG DENDA JIKA BUKU DIKEMBALIKAN HARI INI
CREATE OR REPLACE FUNCTION calculate_potential_fine(
    p_loan_id IN NUMBER
) RETURN NUMBER
IS 
    v_due_date DATE;
    v_days_late NUMBER;
    v_fine_per_days NUMBER := 1.00;
BEGIN 
    SELECT due_date INTO v_due_date
    FROM loans
    WHERE loan_id = p_loan_id AND return_date IS NULL;
    
    IF SYSDATE > v_due_date THEN 
        v_days_late := SYSDATE - v_due_date;
        RETURN v_days_late * v_fine_per_days;
    ELSE 
        RETURN 0;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/


--FUNCTION UNTUK MENGHITUNG TOTAL PEMINJAMAN ANGGOTA

CREATE OR REPLACE FUNCTION get_member_loan_count(
    p_member_id IN NUMBER,
    p_status IN VARCHAR2 DEFAULT 'ALL'
)RETURN NUMBER
IS 
    v_count NUMBER := 0;
BEGIN 
    CASE p_status 
        WHEN 'ALL' THEN 
            SELECT COUNT(*) INTO v_count
            FROM loans
            WHERE member_id = p_member_id;
        WHEN 'ACTIVE' THEN
            SELECT COUNT(*) INTO v_count
            FROM loans
            WHERE member_id = p_member_id AND return_date IS NULL;
        WHEN 'RETURNED' THEN
            SELECT COUNT(*) INTO v_count
            FROM loans
            WHERE member_id = p_member_id AND return_date IS NOT NULL;
        WHEN 'OVERDUE' THEN
            SELECT COUNT(*) INTO v_count
            FROM loans
            WHERE member_id = p_member_id AND return_date IS NULL AND due_date < SYSDATE;
        ELSE
            v_count := -1;
    END CASE;
    
    RETURN v_count;
END;
/


--DUMMY DATA
INSERT INTO categories VALUES(category_seq.NEXTVAL, 'FICTION', 'Novels and Made-Up Stories');
INSERT INTO categories VALUES(category_seq.NEXTVAL, 'NON-FICTION', 'True Stories and Factual Information');
INSERT INTO categories VALUES(category_seq.NEXTVAL, 'SCIENCE FICTION', 'Future and Technology');
INSERT INTO categories VALUES(category_seq.NEXTVAL, 'Mistery', 'Scarries and Mistery');
INSERT INTO categories VALUES(category_seq.NEXTVAL, 'BIOGRAPHY', 'Account Of a Person''s life');


INSERT INTO authors VALUES(author_seq.NEXTVAL, 'J.K Rowling', TO_DATE('31-07-1995', 'DD-MM-YYYY'), 'United Kingdom');
INSERT INTO authors VALUES(author_seq.NEXTVAL, 'Stephen King', TO_DATE('21-09-1947', 'DD-MM-YYYY'), 'United States');
INSERT INTO authors VALUES(author_seq.NEXTVAL, 'George Orwell', TO_DATE('25-06-1903', 'DD-MM-YYYY'), 'United Kingdom');
INSERT INTO authors VALUES(author_seq.NEXTVAL, 'Agatha Christie', TO_DATE('15-09-1890', 'DD-MM-YYYY'), 'United States');
INSERT INTO authors VALUES(author_seq.NEXTVAL, 'Pramudya Ananta', TO_DATE('15-09-1998', 'DD-MM-YYYY'), 'Indonesia');

    
INSERT INTO books VALUES(book_seq.NEXTVAL, 'Harry Potter and The Philosopher Stone', '9780747532699', TO_DATE('26-06-1997','DD-MM-YYYY'), 1, 5, 5);
INSERT INTO books VALUES(book_seq.NEXTVAL, 'The Shinning', '9780747532698', TO_DATE('28-01-1977','DD-MM-YYYY'), 1, 3, 3);
INSERT INTO books VALUES(book_seq.NEXTVAL, '1984', '9780747532697', TO_DATE('08-06-1949','DD-MM-YYYY'), 3, 2, 2);
INSERT INTO books VALUES(book_seq.NEXTVAL, 'Murder on the Orient Express', '9780747532696', TO_DATE('01-01-1900','DD-MM-YYYY'), 4, 3, 3);
INSERT INTO books VALUES(book_seq.NEXTVAL, 'Gadis Pantai', '9780747532695', TO_DATE('22-01-2000','DD-MM-YYYY'), 5, 4, 4);


INSERT INTO book_authors VALUES(1,1);
INSERT INTO book_authors VALUES(2,2);
INSERT INTO book_authors VALUES(3,3);
INSERT INTO book_authors VALUES(4,4);
INSERT INTO book_authors VALUES(5,5);


INSERT INTO members VALUES(member_seq.NEXTVAL, 'John', 'Doe', 'johnlbf@email.com', '081344567213', SYSDATE-180, SYSDATE+185, 'ACTIVE');
INSERT INTO members VALUES(member_seq.NEXTVAL, 'Ujeh', 'Prasatya', 'ujeh123@email.com', '081344569011', SYSDATE-150, SYSDATE+215, 'ACTIVE');
INSERT INTO members VALUES(member_seq.NEXTVAL, 'Sri', 'Mulyani', 'smulyani@email.com', '081129567213', SYSDATE-120, SYSDATE+245, 'ACTIVE');
INSERT INTO members VALUES(member_seq.NEXTVAL, 'Jokowi', 'Mulyono', 'rajajamet@email.com', '081244567213', SYSDATE-110, SYSDATE+170, 'ACTIVE');
INSERT INTO members VALUES(member_seq.NEXTVAL, 'Probowo', 'Subianto', 'bowoni@email.com', '081344567111', SYSDATE-180, SYSDATE+185, 'EXPIRED');



INSERT INTO loans VALUES(loan_seq.NEXTVAL, 1, 1, SYSDATE-30, SYSDATE-16, SYSDATE-15, 0);
INSERT INTO loans VALUES(loan_seq.NEXTVAL, 2, 2, SYSDATE-25, SYSDATE-11, SYSDATE-5, 6);
INSERT INTO loans VALUES(loan_seq.NEXTVAL, 3, 3, SYSDATE-20, SYSDATE-6, NULL, 0);
INSERT INTO loans VALUES(loan_seq.NEXTVAL, 4, 4, SYSDATE-15, SYSDATE-1, NULL, 0);
INSERT INTO loans VALUES(loan_seq.NEXTVAL, 5, 5, SYSDATE-10, SYSDATE+6, NULL, 0);



--CREATE VIEW 

--VIEW UNTUK BUKU TERSEDIA

CREATE OR REPLACE VIEW available_book AS
SELECT b.book_id, b.title, b.isbn, a.author_name, c.category_name, b.available_copies
FROM books b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN authors a ON ba.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
WHERE b.available_copies > 0;


--VIEW UNTUK PEMINJAM YANG TERLAMBAT
CREATE OR REPLACE VIEW overdue_loans AS
SELECT  l.loan_id, b.title, m.first_name || ' ' || m.last_name AS member_name, l.loan_date, l.due_date, SYSDATE - l.due_date AS days_overdue, calculate_potential_fine(l.loan_id) AS potential_fine
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.due_date < SYSDATE;


--VIEW UNTUK STATIKTIK ANGGOTA
CREATE OR REPLACE VIEW member_statistics AS 
SELECT m.member_id, m.first_name || ' ' || m.last_name AS member_name,
        get_member_loan_count(m.member_id, 'ALL') AS total_loans,
        get_member_loan_count(m.member_id, 'ACTIVE') AS active_loans,
        get_member_loan_count(m.member_id, 'RETURNED') AS returned_loans,
        get_member_loan_count(m.member_id, 'OVERDUE') AS overdue_loans,
        (SELECT NVL(SUM(fine_amount),0) FROM loans WHERE member_id = m.member_id) AS total_fines
FROM members m;



--BUKU PALING SERING DIPINJEM
SELECT b.title, COUNT(l.loan_id) AS loan_count
FROM books b
JOIN loans l ON b.book_id = l.book_id
GROUP BY b.title
ORDER BY loan_count DESC;


--TOTAL DENDA PER BULAN
SELECT TO_CHAR(return_date, 'YYYY-MM') AS month, SUM(fine_amount) AS total_fines
FROM loans
WHERE return_date IS NOT NULL AND fine_amount > 0
GROUP BY TO_CHAR(return_date, 'YYYY-MM')
ORDER BY month;


--RATA-RATA DURASI PEMINJAMAN
SELECT ROUND(AVG(return_date - loan_date), 1)AS avg_loan_days
FROM loans
WHERE return_date IS NOT NULL;

SELECT * FROM books;
SELECT * FROM members;


SET SERVEROUTPUT ON;
BEGIN
    borrow_book(6,6,14);
END;
/

SELECT
    COUNT(*) AS total_books,
    SUM(available_copies) AS total_available_books,
    SUM(total_copies - available_copies) AS total_borrow_books
FROM books;


SELECT 
    c.category_name,
    SUM(b.available_copies) AS available_copies,
    SUM(b.total_copies - available_copies) AS borrowed_book
FROM books b
JOIN categories c ON b.category_id = c.category_id
GROUP BY c.category_name
ORDER BY c.category_name;

SELECT
    m.member_id,
    m.first_name || ' ' || m.last_name AS member_name,
    COUNT(l.loan_id) AS total_loans
FROM members m
JOIN loans l ON m.member_id =  l.loan_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY total_loans DESC;

SELECT
    b.book_id,
    c.category_name AS category,
    b.title AS books_title, 
    MAX(b.total_copies) AS max_total_copies
FROM books b
JOIN categories c ON b.category_id = c.category_id
GROUP BY b.book_id, c.category_name, b.title
ORDER BY max_total_copies DESC;

