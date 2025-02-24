# PL/SQL Learning Repository

## Introduction to Databases

### Overview of Databases and SQL
- Database adalah kumpulan data yang terorganisir dengan baik.
- SQL (Structured Query Language) digunakan untuk mengakses dan mengelola data di dalam database.

### Introduction to PL/SQL
- PL/SQL adalah bahasa pemrograman prosedural yang diperluas dari SQL dan digunakan di dalam Oracle Database.

### Setting Up the Environment (Oracle Database)
Untuk mulai menggunakan PL/SQL di Oracle Database:
```sql
-- Aktifkan output agar dapat melihat hasil cetakan
SET SERVEROUTPUT ON;
```

## Basic PL/SQL Syntax

### PL/SQL Blocks
PL/SQL memiliki tiga bagian utama:
```sql
DECLARE  -- Deklarasi variabel
    v_message VARCHAR2(50) := 'Hello, PL/SQL!';
BEGIN  -- Blok utama eksekusi
    DBMS_OUTPUT.PUT_LINE(v_message);
EXCEPTION  -- Blok penanganan error
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Terjadi kesalahan.');
END;
/
```

### Variables and Data Types
PL/SQL mendukung berbagai tipe data:
```sql
DECLARE
    v_name VARCHAR2(100);
    v_age NUMBER := 25;
    v_active BOOLEAN := TRUE;
BEGIN
    v_name := 'Bagas';
    DBMS_OUTPUT.PUT_LINE('Nama: ' || v_name || ', Umur: ' || v_age);
END;
/
```

### Control Structures (IF, CASE)
#### IF-ELSE Statement
```sql
DECLARE
    v_score NUMBER := 85;
BEGIN
    IF v_score >= 80 THEN
        DBMS_OUTPUT.PUT_LINE('Nilai: A');
    ELSIF v_score >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('Nilai: B');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nilai: C');
    END IF;
END;
/
```

#### CASE Statement
```sql
DECLARE
    v_day VARCHAR2(10) := 'Monday';
BEGIN
    CASE v_day
        WHEN 'Monday' THEN DBMS_OUTPUT.PUT_LINE('Hari Senin');
        WHEN 'Tuesday' THEN DBMS_OUTPUT.PUT_LINE('Hari Selasa');
        ELSE DBMS_OUTPUT.PUT_LINE('Hari lainnya');
    END CASE;
END;
/
```

## Cursors

### Introduction to Cursors
Cursors digunakan untuk mengambil banyak baris data dari database.

### Implicit vs. Explicit Cursors
#### Implicit Cursor
```sql
BEGIN
    FOR rec IN (SELECT name FROM customers) LOOP
        DBMS_OUTPUT.PUT_LINE('Nama: ' || rec.name);
    END LOOP;
END;
/
```

#### Explicit Cursor
```sql
DECLARE
    CURSOR c_customers IS SELECT name FROM customers;
    v_name customers.name%TYPE;
BEGIN
    OPEN c_customers;
    LOOP
        FETCH c_customers INTO v_name;
        EXIT WHEN c_customers%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nama: ' || v_name);
    END LOOP;
    CLOSE c_customers;
END;
/
```

## Procedures and Functions

### Creating and Using Procedures
```sql
CREATE OR REPLACE PROCEDURE greet_user (p_name VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, ' || p_name || '!');
END;
/

EXECUTE greet_user('Bagas');
```

### Creating and Using Functions
```sql
CREATE OR REPLACE FUNCTION get_square (p_number NUMBER) RETURN NUMBER AS
BEGIN
    RETURN p_number * p_number;
END;
/

DECLARE
    v_result NUMBER;
BEGIN
    v_result := get_square(5);
    DBMS_OUTPUT.PUT_LINE('Hasil: ' || v_result);
END;
/
```

### Differences Between Procedures and Functions
| Feature | Procedure | Function |
|---------|-----------|---------|
| Return Value | Tidak wajib | Wajib |
| Dapat dipanggil di SELECT | Tidak | Ya |

## Exception Handling

### Types of Exceptions
- **Predefined Exceptions**: Seperti `NO_DATA_FOUND`, `ZERO_DIVIDE`.
- **User-defined Exceptions**: Dibuat dengan `EXCEPTION` keyword.

### Using Exception Handling in PL/SQL
```sql
DECLARE
    v_div NUMBER;
BEGIN
    v_div := 10 / 0; -- Error Zero Division
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Pembagian dengan nol tidak diperbolehkan.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error lain terjadi.');
END;
/
```

## Triggers

### Introduction to Triggers
Triggers adalah prosedur yang dijalankan secara otomatis saat terjadi peristiwa tertentu pada tabel.

### Creating a Simple Trigger
```sql
CREATE OR REPLACE TRIGGER before_insert_customer
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Customer baru ditambahkan: ' || :NEW.name);
END;
/
```

## Collections

### Introduction to Collections
Collections adalah struktur data dalam PL/SQL yang dapat menyimpan banyak elemen, ada 3 yaitu type assosiative array, varray, nested.

### Using ASSOSIATIVE ARRAY
```sql
SET SERVEROUTPUT ON;

DECLARE 
    TYPE population IS TABLE OF NUMBER
        INDEX BY VARCHAR2(64);
    city_population population;
    i VARCHAR2(64);
    
BEGIN
    city_population('SMALLVILLE') := 2000;
    city_population('MIDLAND') := 4000;
    city_population('MEGALOPOLIS') := 10000;
    
    city_population('SMALLVILLE') := 4500;
    
    i := city_population.FIRST;
    
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('population of ' || i || ' is ' || city_population(i));
        i := city_population.NEXT(i);
    END LOOP;
END;
/
```

### Using VARRAY
```sql
DECLARE
    TYPE arr_type IS VARRAY(5) OF VARCHAR2(20);
    v_names arr_type := arr_type('Ali', 'Budi', 'Citra');
BEGIN
    FOR i IN 1..v_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_names(i));
    END LOOP;
END;
/
```

### Using NESTED
```sql
DECLARE
  TYPE nested_type IS TABLE OF VARCHAR2(100);
  my_nested nested_type := nested_type();
BEGIN
  my_nested.EXTEND(3);
  my_nested(1) := 'One';
  my_nested(2) := 'Two';
  my_nested(3) := 'Three';
  
  FOR i IN 1..my_nested.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(my_nested(i));
  END LOOP;
END;
/
```


## Records

### Introduction to Records
Records adalah tipe data yang dapat menyimpan banyak nilai dalam satu variabel.

### Using Records in PL/SQL
```sql
DECLARE
    TYPE customer_record IS RECORD (
        id customers.id%TYPE,
        name customers.name%TYPE
    );
    v_customer customer_record;
BEGIN
    SELECT id, name INTO v_customer FROM customers WHERE id = 1;
    DBMS_OUTPUT.PUT_LINE('Customer: ' || v_customer.name);
END;
/
```

## Contributing
Silakan lakukan pull request atau issue jika ingin menambahkan materi baru! 🚀

