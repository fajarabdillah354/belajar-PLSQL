select *from mahasiswa; 

SELECT * FROM mahasiswa WHERE nim = '2109';

desc mahasiswa;


insert into mahasiswa(nim, nama, tempatlahir, tanggallahir, email)
values('2105', 'sandy maldini', 'jakarta', '13-09-2000', 'sandy.maldini@gmail.com');

insert into mahasiswa(nim, nama, tempatlahir, tanggallahir, email)
values('2106', 'satriawibawa', 'jakarta', '13-12-2002', 'satria@gmail.com'),
        ('2107', 'ibnu bahtiar', 'jakarta', '2-06-2002', 'ayam@gmail.com');
        
update mahasiswa set tempatlahir='kuningan'
where nim='2107';

update mahasiswa set nim='2104', nama='fajar abdillah ahmad', tempatlahir='jakarta', tanggallahir='30-12-2000', email='fajar.ahmad@midasteknologi.com'
where nim='21030';


delete from mahasiswa where nim='2107';


