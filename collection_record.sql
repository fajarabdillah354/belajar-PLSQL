--SETTING SERVEROUT AGAR OUTPUT DBMS BISA TAMPIL
SET SERVEROUTPUT ON;

/*

    
    Dalam collection ada 3 type 
    1. assosiative array 
        Associative Array adalah jenis collection yang menggunakan indeks berbasis angka atau string untuk mengakses elemen di dalamnya. Associative Array juga disebut Index-by Table karena elemen-elemennya diakses menggunakan indeks yang tidak harus berurutan.
    2. varray (variabel size array)
        Collection dengan jumlah elemen tetap.
    3. nested
        Collection yang mirip VARRAY tetapi bisa bertambah dan berkurang secara dinamis.

*/



--Example Associative Array Indexed by String
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


--example function return assosiative array indexed by PLS_INTEGER
DECLARE 
    TYPE sum_multiple IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    n PLS_INTEGER := 5;
    sn PLS_INTEGER := 10;
    m PLS_INTEGER := 3;
    FUNCTION get_sum_multiples(
        multiple IN PLS_INTEGER,
        num IN PLS_INTEGER
    ) RETURN sum_multiple
    IS
        s sum_multiple;
    BEGIN
        FOR i IN 1..num LOOP
            s(i) := multiple * ((i * (i + 1))/ 2);
        END LOOP;
        RETURN s;
    END get_sum_multiples;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'SUM OF THE FIRST ' || TO_CHAR(n) || ' multiples of ' ||
        TO_CHAR(m) || ' is ' || TO_CHAR(get_sum_multiples (m, sn) (n))
    );
END;
/


--CONTOH PENERAPAN VARRAY COLLECTION
DECLARE
--    dalam parameter dalam varray adalah index dari banyaknya data yang bisa di tampung
    TYPE Usergame IS VARRAY(5) OF VARCHAR2(50);
    
    team Usergame := Usergame('aa', 'ii', 'uu', 'ee', 'oo');
    PROCEDURE print_team (heading VARCHAR2) IS
    BEGIN 
        DBMS_OUTPUT.PUT_LINE(heading);
        
        FOR i IN 1..5 LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' . ' || team(i));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END;
BEGIN
    print_team('Mobile Legend Squad 1 : ');
    team(3) := 'JOKOWI';
    team(4) := 'MULYUNO';
    print_team('Mobile Legend Squad 2 : ');
    team := Usergame('BAHLIL', 'PUGAW', 'TEDY', 'DEDY', 'LUHUT');
    print_team('Mobile Legend Squad 3 : ');
END;
/


--CONTOH PENERAPAN NESTED COLLECTION
DECLARE
    TYPE Roster IS TABLE OF VARCHAR2(30);
    
    names Roster := Roster('Upin', 'Ipin', 'Jarjit', 'Mail', 'Fizi');
    
    PROCEDURE print_name(heading VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(heading);
        
        FOR i IN names.FIRST .. names.Last LOOP
            DBMS_OUTPUT.PUT_LINE(names(i));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('----------------------');
    END;
BEGIN
    print_name('Upin & Ipin frieand : ');
    names(3) := 'Fajar Abdillah ';
    print_name('New Upin Friend : ');
    names := Roster('MULYONO', 'GIBRAN', 'BOWO', 'LUHUT');
    print_name('INDOG KINGDOM : ');
END;
/


/*
    RECORD
    Record adalah struktur data yang dapat menyimpan berbagai tipe data dalam satu variabel
*/

--MEMBUAT RECORD
DECLARE 
--    MENGGUNAKAN TYPE DIIKUTI NAMA RECORD YANG AKAN DIBUAT LALU BERI TAHU DENGAN IS RECORD
    TYPE employee_record IS RECORD(
        emp_id NUMBER,
        emp_name VARCHAR2(100),
        salary NUMBER
    );
    
    emp employee_record;
BEGIN
    emp.emp_id := 1;
    emp.emp_name := 'fajar abdillah ahmad';
    emp.salary := 10000000;
    
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE ID : ' || emp.emp_id);
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME : ' || emp.emp_name);
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE SALARY : ' || emp.salary);
END;
/
    
    
--CONTOH RECORD BERDASARKAN TABLE ROW    
/*
    untuk contoh ini harus sudah memiliki table terlebih dahulu
*/
DECLARE
  nasabah rekening%ROWTYPE;
BEGIN
  SELECT * INTO nasabah
  FROM rekening
  WHERE nomor_rekening = 1001;
  
  DBMS_OUTPUT.PUT_LINE('Name : ' || nasabah.nama_nasabah);
  DBMS_OUTPUT.PUT_LINE('Tempat Lahir : ' || nasabah.tempat_lahir);
  DBMS_OUTPUT.PUT_LINE('Alamat : ' || nasabah.alamat);
  DBMS_OUTPUT.PUT_LINE('Saldo : ' || nasabah.saldo);
END;
/
    