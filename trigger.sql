--MELIHAT DAFTAR TRIGGER
SELECT trigger_name FROM user_triggers;

--MENGHAPUS TRIGGER 
--DROP TRIGGER trigger_name


/*
    contoh dibawah ini adalah contoh penerapan trigger dalam table 
    rekening dan transfer

*/
CREATE TABLE rekening(
    nomor_rekening NUMBER CONSTRAINT rekening_pk PRIMARY KEY,
    nama_nasabah VARCHAR2(50) NOT NULL,
    tempat_lahir VARCHAR(20),
    tanggal_lahir DATE,
    alamat VARCHAR2(50),
    saldo NUMBER DEFAULT 0 NOT NULL
);


CREATE TABLE transfer(
    no_transaksi NUMBER GENERATED AS IDENTITY CONSTRAINT transfer_pk PRIMARY KEY,
    waktu_transaksi TIMESTAMP DEFAULT SYSDATE NOT NULL,
    norek_pengirim NUMBER,
    norek_penerima NUMBER,
    nominal_transfer NUMBER,
    keterangan VARCHAR2(20),
    CONSTRAINT norek_pengirim_fk FOREIGN KEY(norek_pengirim) REFERENCES rekening(nomor_rekening),
    CONSTRAINT norek_penerima_fk FOREIGN KEY(norek_penerima) REFERENCES rekening(nomor_rekening)
);

SELECT * FROM transfer;
SELECT *FROM rekening;

--Dummy data yang tersedia
INSERT INTO rekening VALUES(1001, 'Fajar Abdillah Ahmad', 'Jakarta', TO_DATE('30-12-2000', 'dd-mm-yyyy'), 'Radar Selatan No.25', 10000);
INSERT INTO rekening VALUES(1002, 'Suratman Disek', 'Depok', TO_DATE('8-10-2003', 'dd-mm-yyyy'), 'Jambore 3', 10000);
INSERT INTO rekening VALUES(1003, 'Mulyono Jokowi', 'Bekasi', TO_DATE('11-04-2004', 'dd-mm-yyyy'), 'Kedung Sari 2', 4000);

--test trigger
INSERT INTO transfer (norek_pengirim, norek_penerima, nominal_transfer, keterangan)
VALUES (1001, 1002, 1000, 'beli makan kucing');

--test trigger
INSERT INTO transfer (norek_pengirim, norek_penerima, nominal_transfer, keterangan)
VALUES (1003, 1001, 5000, 'bayar utang');

--test trigger
INSERT INTO transfer (norek_pengirim, norek_penerima, nominal_transfer, keterangan)
VALUES (1002, 1003, 5000, 'bayar utang');


--KODE UNTUK MEMBUAT TRIGGER 
CREATE OR REPLACE TRIGGER proses_transfer
AFTER INSERT ON transfer
FOR EACH ROW
DECLARE 
    var_saldo NUMBER;
BEGIN
    SELECT saldo INTO var_saldo FROM rekening WHERE nomor_rekening =: NEW.norek_pengirim;
    IF var_saldo < :NEW.nominal_transfer THEN
        RAISE_APPLICATION_ERROR(-20001, 'tidak dapat melakukan transfer karna saldo tidak cukup');
    ELSE
        UPDATE rekening SET saldo = saldo-:NEW.nominal_transfer WHERE nomor_rekening =: NEW.norek_pengirim;
        UPDATE rekening SET saldo = saldo+:NEW.nominal_transfer WHERE nomor_rekening =: NEW.norek_penerima;
    END IF;
END;
/

