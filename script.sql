alter session set "_ORACLE_SCRIPT"=true; 
set serveroutput on;
conn sys/1234 as sysdba;
begin
    EXECUTE IMMEDIATE 'DROP USER BENHVIEN CASCADE';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/
--
--
CREATE USER BENHVIEN IDENTIFIED BY "1234";
grant create session to BENHVIEN;
GRANT UNLIMITED TABLESPACE TO BENHVIEN;
grant create any table to BENHVIEN;
grant create view to BENHVIEN;
grant create trigger to BENHVIEN;
grant create procedure to BENHVIEN;
grant all on SYS.DBMS_CRYPTO to BENHVIEN;

create table BENHVIEN.ThongTinUser(
    username nvarchar2(50),
    password nvarchar2(50),
    chucvu nvarchar2(50),
    manv nvarchar2(10),
    
    primary key(username)
);
/

create table BENHVIEN.NhanVien
(
    MaNV nvarchar2(10),
    TenNV nvarchar2(50),
    LoaiNV nvarchar2(10),
    MaPhongBan nvarchar2(10),
    LuongCoBan nvarchar2(1024),
    PhuCap nvarchar2(1024),
    SoNgayCong nvarchar2(1024),
    primary key(MaNV)
);
/

create table BENHVIEN.LoaiNhanVien
(
    MaLoai nvarchar2(10),
    TenLoaiNV nvarchar2(50),
    primary key(MaLoai)
);
/

create table BENHVIEN.PhongBan
(
    MaPB nvarchar2(10),
    TenPB nvarchar2(50),
    primary key(MaPB)
);
/

create table BENHVIEN.Truc
(
    MaPB nvarchar2(10),
    MaNV nvarchar2(10),
    GioBatDau TIMESTAMP,
    GioKetThuc TIMESTAMP,

    primary key(MaPB,MaNV)
);
/

create table BENHVIEN.DichVuKham
(
    MaDichVu nvarchar2(10),
    TenDichVu nvarchar2(50),
    Gia INTEGER,
    primary key(MaDichVu)
);
/

create table BENHVIEN.Thuoc
(
    MaThuoc nvarchar2(10),
    TenTenThuoc nvarchar2(50),
    DonGia INTEGER,
    primary key(MaThuoc)
);
/


create table BENHVIEN.BenhNhan
(
    MaBN nvarchar2(10),
    TenBN nvarchar2(40),
    DiaChi nvarchar2(40),
    SDT nvarchar2(40),
    TrieuChung nvarchar2(1024),
    primary key(MaBN)
);
/

create table BENHVIEN.KhamBenh
(
    MaBN nvarchar2(1024),
    MaKhamBenh nvarchar2(10),
    MaNV nvarchar2(10),
    TongTienKham nvarchar2(1024),
    primary key(MaKhamBenh)
);
/

create table BENHVIEN.CT_DVKhamBenh
(
    MaKhamBenh nvarchar2(10),
    MaCTKB nvarchar2(10),
    MaNV nvarchar2(10),
    MaDichVu nvarchar2(1024),
    Tien nvarchar2(1024),
    primary key(MaCTKB)
);
/

create table BENHVIEN.CT_DonThuoc
(
    MaKhamBenh nvarchar2(10),
    MaCTDT nvarchar2(10),
    MaNV nvarchar2(10),
    MaThuoc nvarchar2(1024),
    SoLuong INTEGER,
    Tien nvarchar2(1024),
    primary key(MaCTDT)
);
/

ALTER TABLE BENHVIEN.NhanVien ADD CONSTRAINT fk_nv_pb FOREIGN KEY (MaPhongBan) REFERENCES BENHVIEN.PhongBan(MaPB);

ALTER TABLE BENHVIEN.NhanVien ADD CONSTRAINT fk_nv_loai FOREIGN KEY (LoaiNV) REFERENCES BENHVIEN.LoaiNhanVien(MaLoai);

ALTER TABLE BENHVIEN.Truc ADD CONSTRAINT fk_nv_truc FOREIGN KEY (MaNV) REFERENCES BENHVIEN.NhanVien(MaNV);
ALTER TABLE BENHVIEN.Truc ADD CONSTRAINT fk_nv_truc_phong FOREIGN KEY (MaPB) REFERENCES BENHVIEN.PhongBan(MaPB);

--ALTER TABLE BENHVIEN.KhamBenh ADD CONSTRAINT fk_bn_kb FOREIGN KEY (MaBN) REFERENCES BENHVIEN.BenhNhan(MaBN);
ALTER TABLE BENHVIEN.KhamBenh ADD CONSTRAINT fk_nv_kb FOREIGN KEY (MaNV) REFERENCES BENHVIEN.NhanVien(MaNV);

--ALTER TABLE BENHVIEN.CT_DVKhamBenh ADD CONSTRAINT fk_ctdvkb FOREIGN KEY (MaKhamBenh) REFERENCES BENHVIEN.KhamBenh(MaKhamBenh);
--ALTER TABLE BENHVIEN.CT_DVKhamBenh ADD CONSTRAINT fk_ctdvkb_dv FOREIGN KEY (MaDichVu) REFERENCES BENHVIEN.DichVuKham(MaDichVu);
--
--ALTER TABLE BENHVIEN.CT_DonThuoc ADD CONSTRAINT fk_ctdt FOREIGN KEY (MaKhamBenh) REFERENCES BENHVIEN.KhamBenh(MaKhamBenh);
--ALTER TABLE BENHVIEN.CT_DonThuoc ADD CONSTRAINT fk_ctdt_dt FOREIGN KEY (MaThuoc) REFERENCES BENHVIEN.Thuoc(MaThuoc);


-- ========================================================
create table BENHVIEN.KEYEN(
    key varchar2(20)
);
insert into BENHVIEN.KEYEN values('ILoveOracle');
/

create or replace function benhvien.enData(input_string varchar2)
return raw
is
    key_string varchar2(20);
    encryption_type    PLS_INTEGER :=          -- total encryption type DES_CBC_PCKCS5
                            DBMS_CRYPTO.ENCRYPT_DES
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
begin
    select k.key into key_string from BENHVIEN.KEYEN k;
    return DBMS_CRYPTO.ENCRYPT(
         src => UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8'),
         typ => encryption_type,
         key => rawtohex(UTL_I18N.STRING_TO_RAW (key_string, 'AL32UTF8'))
    );
end;
/
-- ==============================================

create or replace function benhvien.deData(encrypted_raw raw)
return varchar2
is
    key_string varchar2(20);
    encryption_type PLS_INTEGER :=          -- total encryption type
                            DBMS_CRYPTO.ENCRYPT_DES
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
begin
    select k.key into key_string from BENHVIEN.KEYEN k;
    return UTL_I18N.RAW_TO_CHAR(DBMS_CRYPTO.DECRYPT(
         src => encrypted_raw,
         typ => encryption_type,
         key => rawtohex(UTL_I18N.STRING_TO_RAW (key_string, 'AL32UTF8'))) , 'AL32UTF8');
end;
/
--==============================================================

create or replace trigger trg_insert_nhanvien
before insert on BENHVIEN.NhanVien
for each row
DECLARE
    encrypted_raw RAW(2048);
begin
    encrypted_raw := enData(:new.LuongCoBan);
    :new.LuongCoBan := encrypted_raw;
    encrypted_raw := enData(:new.phucap);
    :new.phucap := encrypted_raw;
    encrypted_raw := enData(:new.songaycong);
    :new.songaycong := encrypted_raw;
end;
/
-- ========================================================

create or replace trigger trg_insert_benhnhan
before insert on BENHVIEN.benhnhan
for each row
DECLARE
    encrypted_raw RAW(2048);
begin
    encrypted_raw := enData(:new.trieuchung);
    :new.trieuchung := encrypted_raw;
end;
/
-- ========================================================

create or replace trigger trg_insert_ctdv_khambenh
before insert on BENHVIEN.CT_DVKhamBenh
for each row
DECLARE
    encrypted_raw RAW(2048);
begin
    encrypted_raw := enData(:new.Tien);
    :new.Tien := encrypted_raw;
    encrypted_raw := enData(:new.MaDichVu);
    :new.MaDichVu := encrypted_raw;
end;
/

create or replace trigger trg_insert_ctdv_khambenh_update
before update on BENHVIEN.CT_DVKhamBenh
for each row
DECLARE
    encrypted_raw RAW(2048);
    tienv varchar2(2048);
    madichvuv varchar2(2048);
begin
    select tien, madichvu into tienv, madichvuv from BENHVIEN.CT_DVKhamBenh where MACTKB=:new.mactkb;
    if(:new.tien != tienv) then
        encrypted_raw := enData(:new.tien);
        :new.tien := encrypted_raw;
    end if;
    
    if(:new.MaDichVu != madichvuv) then
        encrypted_raw := enData(:new.MaDichVu);
        :new.MaDichVu := encrypted_raw;
    end if;
end;
/


-- ========================================================

create or replace trigger trg_insert_ctdv_donthuoc
before insert on BENHVIEN.CT_DonThuoc
for each row
DECLARE
    encrypted_raw RAW(2048);
begin
    encrypted_raw := enData(:new.Tien);
    :new.Tien := encrypted_raw;
    encrypted_raw := enData(:new.MaThuoc);
    :new.MaThuoc := encrypted_raw;
end;
/


create or replace trigger trg_insert_ct_donthuoc_update
before update on BENHVIEN.CT_donthuoc
for each row
DECLARE
    encrypted_raw RAW(2048);
    tienv varchar2(2048);
    mathuocv varchar2(2048);
begin
    select tien, mathuoc into tienv, mathuocv from BENHVIEN.CT_donthuoc where mactdt=:new.mactdt;
    if(:new.tien != tienv) then
        encrypted_raw := enData(:new.tien);
        :new.tien := encrypted_raw;
    end if;
    
    if(:new.mathuoc != mathuocv) then
        encrypted_raw := enData(:new.mathuoc);
        :new.mathuoc := encrypted_raw;
    end if;
end;
/
-- ========================================================

create or replace trigger trg_insert_khambenh
before insert on BENHVIEN.KhamBenh
for each row
DECLARE
    encrypted_raw RAW(2048);
begin
    encrypted_raw := enData(:new.MaBN);
    :new.MaBN := encrypted_raw;
    encrypted_raw := enData(:new.TongTienKham);
    :new.TongTienKham := encrypted_raw;
end;
/

-- ========================================================

INSERT INTO BENHVIEN.PhongBan VALUES ('PB001', N'quản lý');
INSERT INTO BENHVIEN.PhongBan VALUES ('PB002', N'tiếp tân');
INSERT INTO BENHVIEN.PhongBan VALUES ('PB003', N'đi�?i phối bệnh');
INSERT INTO BENHVIEN.PhongBan VALUES ('PB004', N'bác sĩ');
INSERT INTO BENHVIEN.PhongBan VALUES ('PB005', N'tài vụ');
INSERT INTO BENHVIEN.PhongBan VALUES ('PB006', N'bán thuốc');
INSERT INTO BENHVIEN.PhongBan VALUES ('PB007', N'kế toán');

INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI001', N'QUAN LY TAI NGUYEN NHAN SU QLTNNS');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI002', N'QL TAI VU QLTV');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI003', N'QL CHUYEN MON QLCM');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI004', N'QL TIEP TAN QLTTDP');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI005', N'QL PHONG TAI VU PTV');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI006', N'QL BAC SI NBS');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI007', N'QL BO PHAN BAN THUOC QLBPBT');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI008', N'Quan Ly Ke Toan QLBPKT');
INSERT INTO BENHVIEN.LoaiNhanVien VALUES ('LOAI009', N'NHAN VIEN NV');

INSERT INTO BENHVIEN.NhanVien VALUES ('NV001', N'Nguyễn Văn A TNNS','LOAI009','PB001',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV002', N'Nguyễn Văn B TNNS','LOAI009','PB001',1001,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV003', N'Nguyễn Văn C TNNS','LOAI009','PB001',1002,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV004', N'Nguyễn Văn D QLTV','LOAI009','PB002',1003,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV005', N'Nguyễn Văn E QLTV','LOAI009','PB003',1004,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV006', N'Nguyễn Văn F CM','LOAI009','PB005',1005,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV007', N'Nguyễn Văn G CM','LOAI009','PB004',1006,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV008', N'Nguyễn Văn H CM','LOAI009','PB006',1007,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV009', N'Nguyễn Văn I TTDP','LOAI009','PB007',1008,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV010', N'Nguyễn Văn K TTDP','LOAI009','PB004',1009,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV011', N'Nguyễn Văn L TTDP','LOAI009','PB004',1009,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV012', N'Nguyễn Văn M TTDP','LOAI009','PB004',1011,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV013', N'Nguyễn Văn N PTV','LOAI009','PB004',1055,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV014', N'Nguyễn Văn O PTV','LOAI009','PB004',1063,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV015', N'Nguyễn Văn P PTV','LOAI009','PB004',1005,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV016', N'Nguyễn Văn Q BPBT','LOAI009','PB002',1020,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV017', N'Nguyễn Văn R BPKT','LOAI009','PB002',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV018', N'Nguyễn Văn S BPKT','LOAI009','PB003',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV019', N'Nguyễn Văn T BPKT','LOAI009','PB003',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV020', N'Nguyễn Văn X BPKT','LOAI009','PB003',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('NV021', N'Nguyễn Văn Y BPKT','LOAI009','PB006',1000,20,1);

INSERT INTO BENHVIEN.NhanVien VALUES ('BS001', N'Nguyễn Văn A','LOAI001','PB001',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS002', N'Nguyễn Văn B','LOAI002','PB001',1001,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS003', N'Nguyễn Văn C','LOAI003','PB001',1002,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS004', N'Nguyễn Văn D','LOAI004','PB002',1003,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS005', N'Nguyễn Văn E','LOAI005','PB003',1004,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS006', N'Nguyễn Văn F','LOAI006','PB005',1005,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS007', N'Nguyễn Văn G','LOAI007','PB004',1006,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS008', N'Nguyễn Văn H','LOAI008','PB006',1007,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS009', N'Nguyễn Văn I','LOAI009','PB007',1008,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('BS010', N'Nguyễn Văn K','LOAI007','PB004',1009,20,1);

INSERT INTO BENHVIEN.NhanVien VALUES ('QL001', N'Quan Ly TNNS QLTNNS','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL002', N'Quan Ly Tai Vu QLTV','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL003', N'Quan Ly Chuyen Mon QLCM','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL004', N'Quan Ly Tiep Tan Dieu Phoi QLTTDP','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL005', N'Quan Ly Phong Tai Vu PTV','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL006', N'Quan Ly Bac Si NBS','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL007', N'Quan Ly Bo Phan Ban Thuoc QLBPBT','LOAI007','PB004',1000,20,1);
INSERT INTO BENHVIEN.NhanVien VALUES ('QL008', N'Quan Ly Ke Toan QLBPKT','LOAI007','PB004',1000,20,1);

INSERT INTO BENHVIEN.NhanVien VALUES ('GD001', N'Giam Doc Phia Nam','LOAI007','PB004',1000,20,1);

INSERT INTO BENHVIEN.BenhNhan VALUES ('BN001', N'Trần Văn A','Sài Gòn','0123456789','sốt ho đau h�?ng, covid 19');
INSERT INTO BENHVIEN.BenhNhan VALUES ('BN002', N'Trần Văn B','Quận 2,Sài Gòn','0123456789','sốt ho đau h�?ng, covid 20..');
INSERT INTO BENHVIEN.BenhNhan VALUES ('BN003', N'Trần Văn D','Sài Gòn','0123456789','CAM HO SO MUI');
INSERT INTO BENHVIEN.BenhNhan VALUES ('BN004', N'Trần Văn D','Quận 2,Sài Gòn','0123456789','DAU HONG, DAU MAT');

INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC001',N'Motilium-M',5);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC002',N'Morihepamin',3);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC003',N'Montegol 5',7);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC004',N'Momate-S',2);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC005',N'Mocetrol',2);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC006',N'Mixtard 30 Flexpeni',10);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC007',N'Metformin',3);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC008',N'Meteospasmyl',4);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC009',N'Marathone',8);
INSERT INTO BENHVIEN.Thuoc VALUES ('THUOC010',N'Inberco Viên',12);

INSERT INTO BENHVIEN.DichVuKham VALUES ('DV001',N'Khám tổng quát',20);
INSERT INTO BENHVIEN.DichVuKham VALUES ('DV002',N'Xét Nghiệm máu',3);
INSERT INTO BENHVIEN.DichVuKham VALUES ('DV003',N'Xét Ngiệm nước ti�?u',3);
INSERT INTO BENHVIEN.DichVuKham VALUES ('DV004',N'Xét nghiệm covid 19',1);
INSERT INTO BENHVIEN.DichVuKham VALUES ('DV005',N'Chuẩn đoán tìm mạch',3);
INSERT INTO BENHVIEN.DichVuKham VALUES ('DV006',N'Chụp x quang',7);
INSERT INTO BENHVIEN.DichVuKham VALUES ('DV007',N'Chuẩn đoán chấn thương',3);

INSERT INTO BENHVIEN.KhamBenh VALUES ('BN001','KB001','BS001',10);
INSERT INTO BENHVIEN.KhamBenh VALUES ('BN001','KB002','BS001',100);
INSERT INTO BENHVIEN.KhamBenh VALUES ('BN002','KB003','BS002',15);
INSERT INTO BENHVIEN.KhamBenh VALUES ('BN002','KB004','BS003',20);
INSERT INTO BENHVIEN.KhamBenh VALUES ('BN003','KB005','BS004',15);
INSERT INTO BENHVIEN.KhamBenh VALUES ('BN003','KB006','BS004',20);

INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB001','CTKB001','BS001','DV002',3);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB001','CTKB002','BS001','DV003',3);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB002','CTKB003','BS002','DV001',20);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB003','CTKB004','BS002','DV004',1);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB003','CTKB005','BS002','DV005',3);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB004','CTKB006','BS003','DV002',7);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB005','CTKB007','BS005','DV005',7);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB005','CTKB008','BS005','DV006',7);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB005','CTKB009','BS004','DV005',7);
INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('KB006','CTKB010','BS004','DV006',7);

INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB001','CTDT001','BS001','THUOC001',5,25);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB001','CTDT002','BS001','THUOC007',3,9);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB001','CTDT003','BS001','THUOC008',4,16);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB001','CTDT004','BS001','THUOC010',5,60);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB002','CTDT005','BS002','THUOC010',5,60);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB002','CTDT006','BS002','THUOC003',5,35);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB003','CTDT007','BS002','THUOC004',5,10);
INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('KB004','CTDT008','BS003','THUOC005',5,10);

insert into BENHVIEN.Truc values('PB003', 'NV007', to_date('2020/08/30','yyyy/mm/dd'),to_date('2020/08/31', 'yyyy/mm/dd'));
insert into BENHVIEN.Truc values('PB001', 'NV001', to_date('2020/08/30','yyyy/mm/dd'),to_date('2020/08/31', 'yyyy/mm/dd'));
insert into BENHVIEN.Truc values('PB001', 'NV002', to_date('2020/08/30','yyyy/mm/dd'),to_date('2020/08/31', 'yyyy/mm/dd'));
insert into BENHVIEN.Truc values('PB002', 'NV003', to_date('2020/08/30','yyyy/mm/dd'),to_date('2020/08/31', 'yyyy/mm/dd'));
insert into BENHVIEN.Truc values('PB003', 'NV004', to_date('2020/08/30','yyyy/mm/dd'),to_date('2020/08/31', 'yyyy/mm/dd'));

commit;
disconnect;

-- ========================================================================
-- Thuc Hien Co Che Bao Mat
conn sys/1234 as sysdba;

begin
    EXECUTE IMMEDIATE 'drop role r_qltnns';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_qltv';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_qlcm';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_ttdp';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_ptv';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_bs';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_bpbt';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
    EXECUTE IMMEDIATE 'drop role r_nvkt';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

create role r_qltnns; -- Role Bo Phan Quan Ly Tai Nguyen Nhan Su
create role r_qltv; -- Role Quan Ly Tai Vu
create role r_qlcm; -- Role Quan Ly Chuyen Mon 
create role r_ttdp; -- Role BP Tiep Tan va Dieu Phoi Benh
create role r_ptv; -- Role NV Phong Tai Vu
create role r_bs; -- Role Bac Si
create role r_bpbt; -- Role Nhan Vien Bo Phan Ban Thuoc
create role r_nvkt; -- Role NV Ke Toan

-- =================================
CREATE or replace PROCEDURE benhvien.grant_select(
    username VARCHAR2, 
    grantee VARCHAR2)
AS   
BEGIN
    FOR r IN (
        SELECT owner, table_name 
        FROM all_tables 
        WHERE owner = username
    )
    LOOP
        EXECUTE IMMEDIATE 
            'GRANT SELECT ON '||r.owner||'.'||r.table_name||' to ' || grantee;
    END LOOP;
END; 
/
-- =================================

-- Role Bo Phan Quan Ly Tai Nguyen Nhan Su ==============
grant select, insert, update, delete on benhvien.nhanvien to r_qltnns;
grant select, insert, update, delete on benhvien.LoaiNhanVien to r_qltnns;
grant select, insert, update, delete on benhvien.phongban to r_qltnns;
grant select, insert, update, delete on benhvien.truc to r_qltnns;
exec benhvien.grant_select('BENHVIEN', 'r_qltnns');

-- =================================

-- Role Quan Ly Tai Vu =============
grant select, insert, update on benhvien.thuoc to r_qltv;
grant select,insert, update on benhvien.DichVuKham to r_qltv;
exec grant_select('BENHVIEN', 'r_qltv');

-- =================================

-- Role Quan Ly Chuyen Mon ==============
exec benhvien.grant_select('BENHVIEN', 'r_qlcm');

create or replace view benhvien.v_qlcm_dichvukham as
select dedata(kb.mabn) mabn, dedata(bn.trieuchung) trieuchung, kb.makhambenh, kb.manv bacsi, dvk.tendichvu tendichvu
from benhvien.benhnhan bn,benhvien.khambenh kb, benhvien.ct_dvkhambenh ctdv, benhvien.dichvukham dvk
where bn.mabn = dedata(kb.mabn) and kb.makhambenh = ctdv.makhambenh and dvk.madichvu = dedata(ctdv.madichvu);
/

create or replace view benhvien.v_qlcm_donthuoc as
select dedata(kb.mabn) mabn, dedata(bn.trieuchung) trieuchung, kb.makhambenh, kb.manv bacsi, thuoc.tententhuoc tenthuoc
from benhvien.benhnhan bn, benhvien.khambenh kb, benhvien.ct_donthuoc ctdonthuoc, benhvien.thuoc thuoc
where bn.mabn = dedata(kb.mabn) and kb.makhambenh = ctdonthuoc.makhambenh and thuoc.mathuoc = dedata(ctdonthuoc.mathuoc);
/

grant select on benhvien.v_qlcm_dichvukham to r_qlcm;
grant select on benhvien.v_qlcm_donthuoc to r_qlcm;

-- =================================

-- Role BP Tiep Tan va Dieu Phoi Benh ==============
grant select, insert, update(tenbn, diachi, sdt), delete on benhvien.benhnhan to r_ttdp;
grant select on benhvien.ct_dvkhambenh to r_ttdp;

-- Tao policy cho Role Tiep tan dieu phoi
create or replace function benhvien.policyRolettdp(p_schema
varchar2, p_obj varchar2)
Return varchar2
is
    user VARCHAR2(100);
Begin
    user := SYS_CONTEXT('userenv','SESSION_USER');
    if(user = 'SYS' or user = 'BENHVIEN') then
        return '1=1';
    end if;
    if (substr(user, 0,4) = 'TTDP') then
            return '0=1';
    end if;
    return '';
end;
/

begin
    DBMS_RLS.DROP_POLICY('BENHVIEN', 'benhnhan', 'policyRolettdp_ct_benhnhan');
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
DBMS_RLS.ADD_POLICY (
  object_schema    => 'BENHVIEN',
  object_name      => 'benhnhan',
  policy_name      => 'policyRolettdp_ct_benhnhan',
  function_schema  => 'BENHVIEN',
  policy_function  => 'policyRolettdp',
  sec_relevant_cols => 'trieuchung',
  sec_relevant_cols_opt => dbms_rls.ALL_ROWS);
end;
/

begin
    DBMS_RLS.DROP_POLICY('BENHVIEN', 'ct_dvkhambenh', 'policyRolettdp_ct_dvkhambenh');
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
DBMS_RLS.ADD_POLICY (
  object_schema    => 'BENHVIEN',
  object_name      => 'ct_dvkhambenh',
  policy_name      => 'policyRolettdp_ct_dvkhambenh',
  function_schema  => 'BENHVIEN',
  policy_function  => 'policyRolettdp',
  sec_relevant_cols => 'Tien',
  sec_relevant_cols_opt => dbms_rls.ALL_ROWS);
end;
/

create or replace view benhvien.v_ttdp as
select dedata(kb.mabn) mabn, bn.tenbn, kb.makhambenh, kb.manv bacsi, dvk.tendichvu tendichvu
from benhvien.benhnhan bn,benhvien.khambenh kb, benhvien.ct_dvkhambenh ctdv, benhvien.dichvukham dvk
where bn.mabn = dedata(kb.mabn) and kb.makhambenh = ctdv.makhambenh and dvk.madichvu = dedata(ctdv.madichvu);
/

grant select on benhvien.v_ttdp to r_ttdp;
-- =================================

-- Role NV Phong Tai Vu ==============
grant select, update(tien) on benhvien.ct_dvkhambenh to r_ptv;
grant select, update(tien) on benhvien.ct_donthuoc to r_ptv;

create or replace view BENHVIEN.v_ctdv_ptv as
select dv.MaKhamBenh,dv.MaCTKB,dv.MaNV,deData(dv.MaDichVu) MaDichVu,deData(dv.Tien) Tien
from benhvien.ct_dvkhambenh dv;
/

grant select on benhvien.v_ctdv_ptv to r_ptv;
-- =================================

-- Role Bac Si ==============
grant select, insert, update(madichvu) on benhvien.ct_dvkhambenh to r_bs;
grant select, insert, update(mathuoc) on benhvien.ct_donthuoc to r_bs;

create or replace view benhvien.getDSDVK as
select madichvu, tendichvu from benhvien.dichvukham;
/
create or replace view benhvien.getDSThuoc as
select mathuoc, tententhuoc from benhvien.thuoc;
/
create or replace view benhvien.v_ctdv_ptv as
select ctdv.mactkb, ctdv.makhambenh, ctdv.manv, dedata(ctdv.madichvu) madichvu, dvk.tendichvu from benhvien.ct_dvkhambenh ctdv, benhvien.dichvukham dvk
where dedata(ctdv.madichvu) = dvk.madichvu;
/
create or replace view benhvien.v_ctdt_ptv as
select ctdt.mactdt, ctdt.makhambenh, ctdt.manv, dedata(ctdt.mathuoc) mathuoc, thuoc.tententhuoc, ctdt.soluong from benhvien.ct_donthuoc ctdt, benhvien.thuoc thuoc
where dedata(ctdt.mathuoc) = thuoc.mathuoc;
/
grant select on benhvien.v_ctdv_ptv to r_bs;
grant select on benhvien.v_ctdt_ptv to r_bs;
grant select on benhvien.getDSDVK to r_bs;
grant select on benhvien.getDSThuoc to r_bs;

-- Tao policy cho Role Bac Si
create or replace function benhvien.policyRoleBS(p_schema
varchar2, p_obj varchar2)
Return varchar2
is
    user VARCHAR2(100);
Begin
    user := SYS_CONTEXT('userenv','SESSION_USER');
    if (substr(user, 0,2) = 'BS') then
            return 'MANV=''' || user || '''';
    end if;
    return '';
end;
/

begin
    DBMS_RLS.DROP_POLICY('BENHVIEN', 'ct_dvkhambenh', 'policyRoleBS');
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
DBMS_RLS.ADD_POLICY (
  object_schema    => 'BENHVIEN',
  object_name      => 'ct_dvkhambenh',
  policy_name      => 'policyRoleBS',
  function_schema  => 'BENHVIEN',
  policy_function  => 'policyRoleBS',
  statement_types => 'select, update');
end;
/

begin
    DBMS_RLS.DROP_POLICY('BENHVIEN', 'ct_donthuoc', 'policyRoleBS');
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

begin
DBMS_RLS.ADD_POLICY (
  object_schema    => 'BENHVIEN',
  object_name      => 'ct_donthuoc',
  policy_name      => 'policyRoleBS',
  function_schema  => 'BENHVIEN',
  policy_function  => 'policyRoleBS',
  statement_types => 'select, update');
end;
/
-- =================================

-- Role Nhan Vien Bo Phan Ban Thuoc ==============
-- Tao View danh cho Role BP Ban Thuoc
create or replace view benhvien.v_bpbt as
select ct.makhambenh, dedata(ct.mathuoc) mathuoc, t.tententhuoc, ct.soluong, t.dongia
from benhvien.ct_donthuoc ct, benhvien.thuoc t
where dedata(ct.mathuoc) = t.mathuoc;
/
-- cap quyen tren view
grant select on benhvien.v_bpbt to r_bpbt;

-- =================================
    
-- Role NV Ke Toan ==============
-- Tao View danh cho NV Ke Toan
--drop view v_kt;
create or replace view benhvien.v_kt as
select nv.manv, deData(nv.luongcoban) luongcoban, deData(nv.phucap) phucap, 
deData(nv.songaycong) songaycong, 
to_number(deData(nv.luongcoban)) * to_number(deData(nv.songaycong)) + to_number(deData(nv.phucap)) tongluong
from benhvien.nhanvien nv;
/
-- cap quyen tren view
grant select on benhvien.v_kt to r_nvkt;


--drop user kt;
--create user kt identified by 1234;
--grant create session to kt;
--grant r_nvkt to kt;

declare CURSOR listUser is select manv from benhvien.nhanvien;
begin
    for username in listUser
    loop
        dbms_output.put_line(username.manv);
        EXECUTE IMMEDIATE 'DROP USER ' || username.manv ||  ' CASCADE';
    end loop;
end;
/

declare
    CURSOR listUser is select manv, TenNV from benhvien.nhanvien;
    rolename varchar2(10);
begin
    for username in listUser
    loop
        EXECUTE IMMEDIATE 'CREATE USER ' || username.manv ||  ' IDENTIFIED BY 1234';
        EXECUTE IMMEDIATE 'grant create session to ' || username.manv;
        EXECUTE IMMEDIATE 'grant select on benhvien.nhanvien to ' || username.manv;
        if(username.TenNV like '%TNNS%') then
            EXECUTE IMMEDIATE 'grant r_qltnns to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;
        
        if(username.TenNV like '%QLTV%') then
            EXECUTE IMMEDIATE 'grant r_qltv to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;
        
        if(username.TenNV like '%CM%' ) then
            EXECUTE IMMEDIATE 'grant r_qlcm to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;
        
        if(username.TenNV like '%TTDP%' ) then
            EXECUTE IMMEDIATE 'grant r_ttdp to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;

        if(username.TenNV like '%BPBT%') then
            EXECUTE IMMEDIATE 'grant r_bpbt to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;
        
        if(username.TenNV like '%PTV%') then
            EXECUTE IMMEDIATE 'grant r_ptv to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;

        if(username.TenNV like '%BPKT%') then
            EXECUTE IMMEDIATE 'grant r_nvkt to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;
        
        if(username.manv like '%BS%') then
            EXECUTE IMMEDIATE 'grant r_bs to ' || username.manv;
--            DBMS_OUTPUT.PUT_LINE(username.manv); 
        end if;

    end loop;
end;
/
disconnect;

-- ====================================================================
-- ============================ Cai Dat OLS ===========================
conn sys/1234 as sysdba;

begin
    EXECUTE IMMEDIATE 'drop user BENHVIEN_mgr';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

CREATE USER BENHVIEN_mgr IDENTIFIED BY 1234;
grant create session to BENHVIEN_mgr;
grant create user to BENHVIEN_mgr;
grant all on BENHVIEN.nhanvien to BENHVIEN_mgr;
grant all on BENHVIEN.KEYEN to BENHVIEN_mgr;

disconnect;
-- ===========================================
conn lbacsys/1234;

-- tao policy OLS

begin
    SA_SYSDBA.DROP_POLICY(policy_name => 'CS_OLS');
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

disconnect;

conn lbacsys/1234;

begin SA_SYSDBA.CREATE_POLICY(
    policy_name => 'CS_OLS',
    column_name => 'COT_OLS'
);
end;
/

--select object_type,owner from dba_objects where object_name='AUD$';

-- cap Role cho BENHVIEN_mgr
grant CS_OLS_dba to BENHVIEN_mgr;

-- cap quyen quan ly OLS cho user 
GRANT EXECUTE ON sa_components TO BENHVIEN_mgr;
GRANT EXECUTE ON sa_label_admin TO BENHVIEN_mgr;
GRANT EXECUTE ON sa_user_admin TO BENHVIEN_mgr;
GRANT EXECUTE ON char_to_label TO BENHVIEN_mgr;
GRANT EXECUTE ON SA_POLICY_ADMIN TO BENHVIEN_mgr;
grant all on dba_sa_groups to BENHVIEN_mgr;
grant all on dba_sa_compartments to BENHVIEN_mgr;
grant all on dba_sa_levels to BENHVIEN_mgr;
grant all on dba_sa_labels to BENHVIEN_mgr;
grant all on dba_sa_policies to BENHVIEN_mgr;

disconnect;
-- ===============================================================

conn BENHVIEN_mgr/1234;
-- tao group
begin
    sa_components.CREATE_GROUP(
    policy_name => 'CS_OLS',
    long_name => 'Benh vien',
    short_name => 'BV',
    group_num => 1,
    parent_name => NULL);
    
    sa_components.CREATE_GROUP(
    policy_name => 'CS_OLS',
    long_name => 'Mien Bac',
    short_name => 'MB',
    group_num => 100,
    parent_name => 'BV');
    
    sa_components.CREATE_GROUP(
    policy_name => 'CS_OLS',
    long_name => 'Mien Trung',
    short_name => 'MT',
    group_num => 110,
    parent_name => 'BV');
    
    sa_components.CREATE_GROUP(
    policy_name => 'CS_OLS',
    long_name => 'Mien Nam',
    short_name => 'MN',
    group_num => 120,
    parent_name => 'BV');
end;
/
-- xem danh sach compartment
--SELECT * FROM dba_sa_groups ORDER BY group_num;

-- ===============================================================

-- tao compartment
begin
sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'QL Tai Nguyen Nhan Su',
short_name => 'QLTNNS',
comp_num => 1000);  

sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'QL Tai Vu',
short_name => 'QLTV',
comp_num => 900);  

sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'QL Chuyen Mon',
short_name => 'QLCM',
comp_num => 800);


sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'Tiep Tan Dieu Phoi',
short_name => 'TTDP',
comp_num => 700);

sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'Phong Tai Vu',
short_name => 'PTV',
comp_num => 600);

sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'Nhom Bac Si',
short_name => 'NBS',
comp_num => 500);

sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'Bo Phan Ban Thuoc',
short_name => 'BPBT',
comp_num => 400);

sa_components.create_compartment
(policy_name => 'CS_OLS',
long_name => 'Bo Phan Ke Toan',
short_name => 'BPKT',
comp_num => 300);

end;
/

--BEGIN
--  SA_COMPONENTS.DROP_COMPARTMENT (
--   policy_name     => 'CS_OLS',
--   short_name      => 'QLTV');
--END;

-- xem danh sach compartment
--SELECT * FROM dba_sa_compartments ORDER BY comp_num;

-- ===============================================================

-- tao level
begin SA_COMPONENTS.CREATE_LEVEL(
policy_name => 'CS_OLS',
level_num   => 9000,
short_name => 'EXEC',
long_name   => 'Giam Doc'
);

SA_COMPONENTS.CREATE_LEVEL(
policy_name => 'CS_OLS',
level_num   => 8000,
short_name => 'MGR',
long_name   => 'Quan Ly'
);

SA_COMPONENTS.CREATE_LEVEL(
policy_name => 'CS_OLS',
level_num   => 7000,
short_name => 'EMP',
long_name   => 'Nhan Vien'
);
end;
/

-- xem danh sach level
--SELECT * FROM dba_sa_levels ORDER BY level_num;

--BEGIN
-- SA_COMPONENTS.DROP_LEVEL (
--   policy_name     => 'CHINHSACH_OLS',
--   level_num       => 7000);
--END;

--begin SA_LABEL_ADMIN.DROP_LABEL(
--    policy_name => 'CS_OLS',
--    label_tag   => 300
--); end;

-- ============================== tao label
begin 
SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 300,
    label_value => 'EMP: QLTNNS: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 310,
    label_value => 'EMP: QLTV: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 320,
    label_value => 'EMP: QLCM : MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 330,
    label_value => 'EMP: TTDP: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 340,
    label_value => 'EMP: PTV: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 350,
    label_value => 'EMP: NBS: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 360,
    label_value => 'EMP: BPBT: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 370,
    label_value => 'EMP: BPKT: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 380,
    label_value => 'MGR: QLTNNS: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 390,
    label_value => 'MGR: QLTV: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 400,
    label_value => 'MGR: QLCM: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 410,
    label_value => 'MGR: TTDP: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 420,
    label_value => 'MGR: PTV: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 430,
    label_value => 'MGR: NBS: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 440,
    label_value => 'MGR: BPBT: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 450,
    label_value => 'MGR: BPKT: MN',
    data_label  => TRUE
);

SA_LABEL_ADMIN.CREATE_LABEL(
    policy_name => 'CS_OLS',
    label_tag   => 500,
    label_value => 'EXEC: QLTNNS, QLTV, QLCM, TTDP, PTV, NBS, BPBT, BPKT: MN',
    data_label  => TRUE
);

end;
/

-- xem danh sach label
--SELECT * FROM dba_sa_labels;

-- ================================================
--DESC BENHVIEN.nhanvien;
-- gan chinh sach OLS vao bang 
BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
  policy_name    => 'CS_OLS',
  schema_name    => 'BENHVIEN',
  table_name     => 'nhanvien',
  table_options    => 'NO_CONTROL');
END;
/
-- ================================================
-- gan nhan chp table
UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:QLTNNS:MN')
where tennv like '%TNNS%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:QLTV:MN')
where tennv like '%QLTV%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:QLCM:MN')
where tennv like '%CM%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:TTDP:MN')
where tennv like '%TTDP%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:PTV:MN')
where tennv like '%PTV%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:NBS:MN')
where manv like '%BS%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:BPBT:MN')
where tennv like '%BPBT%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EMP:BPKT:MN')
where tennv like '%BPKT%' and manv like '%NV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'EXEC:BPKT,BPBT,NBS,PTV,TTDP,QLCM,QLTV,QLTNNS:MN')
where manv = 'GD001';


UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:QLTNNS:MN')
WHERE manv LIKE '%QL%' and tennv like '%QLTNNS%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:QLTV:MN')
WHERE manv LIKE '%QL%' and tennv like '%QLTV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:QLCM:MN')
WHERE manv LIKE '%QL%' and tennv like '%QLCM%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:TTDP:MN')
WHERE manv LIKE '%QL%' and tennv like '%QLTTDP%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:PTV:MN')
WHERE manv LIKE '%QL%' and tennv like '%PTV%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:NBS:MN')
WHERE manv LIKE '%QL%' and tennv like '%NBS%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:BPBT:MN')
WHERE manv LIKE '%QL%' and tennv like '%QLBPBT%';

UPDATE BENHVIEN.nhanvien
SET COT_OLS = char_to_label ('CS_OLS', 'MGR:BPKT:MN')
WHERE manv LIKE '%QL%' and tennv like '%QLBPKT%';

commit work;
-- ================================================

--select * from benhvien.nhanvien;

-- xem cac policy OLS
--SELECT * FROM dba_sa_policies;

-- set level cho user
--BEGIN 
-- SA_USER_ADMIN.DROP_USER_ACCESS (
--  policy_name       => 'CHINHSACH_OLS',
--  user_name         => 'ols_mgr');
--END;

--==============================================

-- kick hoat chinh sach OLS

begin
    sa_policy_admin.remove_table_policy
    (policy_name =>'CS_OLS',
    schema_name => 'BENHVIEN',
    table_name => 'nhanvien');
--    drop_column => true
end;
/

begin
    sa_policy_admin.apply_table_policy
    (policy_name =>'CS_OLS',
    schema_name => 'BENHVIEN',
    table_name => 'nhanvien',
    table_options =>
    'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL');
end;
/

disconnect;

--===================================================
-- Gan OLS cho bang luu key ma khoa

conn BENHVIEN_mgr/1234;

-- gan chinh sach OLS vao bang 
BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
  policy_name    => 'CS_OLS',
  schema_name    => 'BENHVIEN',
  table_name     => 'KEYEN',
  table_options    => 'NO_CONTROL');
END;
/

-- gan nhan chp table
UPDATE BENHVIEN.KEYEN
SET COT_OLS = char_to_label ('CS_OLS', 'EXEC:BPKT,BPBT,NBS,PTV,TTDP,QLCM,QLTV,QLTNNS:MN');
commit;

-- kick hoat chinh sach OLS

begin
    sa_policy_admin.remove_table_policy
    (policy_name =>'CS_OLS',
    schema_name => 'BENHVIEN',
    table_name => 'KEYEN');
end;
/

begin
    sa_policy_admin.apply_table_policy
    (policy_name =>'CS_OLS',
    schema_name => 'BENHVIEN',
    table_name => 'KEYEN',
    table_options =>
    'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL');
end;
/

disconnect;
-- ================================================

-- ====================================================
conn BENHVIEN_mgr/1234;
-- Gan label cho user
set serveroutput on;

BEGIN
    SA_USER_ADMIN.SET_USER_LABELS (
    policy_name       => 'CS_OLS',
    user_name         => 'nv001',
    max_read_label    => 'EMP:QLTNNS:MN',
    max_write_label   => 'EMP:QLTNNS:MN',
    def_label         => 'EMP:QLTNNS:MN',
    row_label         => 'EMP:QLTNNS:MN');
    
    SA_USER_ADMIN.SET_USER_LABELS (
    policy_name       => 'CS_OLS',
    user_name         => 'nv002',
    max_read_label    => 'EMP:QLTNNS:MN',
    max_write_label   => 'EMP:QLTNNS:MN',
    def_label         => 'EMP:QLTNNS:MN',
    row_label         => 'EMP:QLTNNS:MN');
    
    SA_USER_ADMIN.SET_USER_LABELS (
    policy_name       => 'CS_OLS',
    user_name         => 'nv003',
    max_read_label    => 'EMP:QLTNNS:MN',
    max_write_label   => 'EMP:QLTNNS:MN',
    def_label         => 'EMP:QLTNNS:MN',
    row_label         => 'EMP:QLTNNS:MN');
    
    SA_USER_ADMIN.SET_USER_LABELS (
    policy_name       => 'CS_OLS',
    user_name         => 'nv004',
    max_read_label    => 'EMP:QLTV:MN',
    max_write_label   => 'EMP:QLTV:MN',
    def_label         => 'EMP:QLTV:MN',
    row_label         => 'EMP:QLTV:MN');
    
    SA_USER_ADMIN.SET_USER_LABELS (
    policy_name       => 'CS_OLS',
    user_name         => 'nv006',
    max_read_label    => 'EMP:QLCM:MN',
    max_write_label   => 'EMP:QLCM:MN',
    def_label         => 'EMP:QLCM:MN',
    row_label         => 'EMP:QLCM:MN');
    
    SA_USER_ADMIN.SET_USER_LABELS (
    policy_name       => 'CS_OLS',
    user_name         => 'nv009',
    max_read_label    => 'EMP:TTDP:MN',
    max_write_label   => 'EMP:TTDP:MN',
    def_label         => 'EMP:TTDP:MN',
    row_label         => 'EMP:TTDP:MN');
    
  SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'GD001',
  max_read_label    => 'EXEC:BPKT,BPBT,NBS,PTV,TTDP,QLCM,QLTV,QLTNNS:MN',
  max_write_label   => 'EXEC:BPKT,BPBT,NBS,PTV,TTDP,QLCM,QLTV,QLTNNS:MN',
  def_label         => 'EXEC:BPKT,BPBT,NBS,PTV,TTDP,QLCM,QLTV,QLTNNS:MN',
  row_label         => 'EXEC:BPKT,BPBT,NBS,PTV,TTDP,QLCM,QLTV,QLTNNS:MN');
--
 SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL001',
  max_read_label    => 'MGR:QLTNNS:MN',
  max_write_label   => 'MGR:QLTNNS:MN',
  def_label         => 'MGR:QLTNNS:MN',
  row_label         => 'MGR:QLTNNS:MN');
  
   SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL002',
  max_read_label    => 'MGR:QLTV:MN',
  max_write_label   => 'MGR:QLTV:MN',
  def_label         => 'MGR:QLTV:MN',
  row_label         => 'MGR:QLTV:MN');
  
    SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL003',
  max_read_label    => 'MGR:QLCM:MN',
  max_write_label   => 'MGR:QLCM:MN',
  def_label         => 'MGR:QLCM:MN',
  row_label         => 'MGR:QLCM:MN');
  
  SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL004',
  max_read_label    => 'MGR:TTDP:MN',
  max_write_label   => 'MGR:TTDP:MN',
  def_label         => 'MGR:TTDP:MN',
  row_label         => 'MGR:TTDP:MN');
  
  SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL005',
  max_read_label    => 'MGR:PTV:MN',
  max_write_label   => 'MGR:PTV:MN',
  def_label         => 'MGR:PTV:MN',
  row_label         => 'MGR:PTV:MN');
  
  SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL006',
  max_read_label    => 'MGR:NBS:MN',
  max_write_label   => 'MGR:NBS:MN',
  def_label         => 'MGR:NBS:MN',
  row_label         => 'MGR:NBS:MN');
  
  SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL007',
  max_read_label    => 'MGR:BPBT:MN',
  max_write_label   => 'MGR:BPBT:MN',
  def_label         => 'MGR:BPBT:MN',
  row_label         => 'MGR:BPBT:MN');
  
  SA_USER_ADMIN.SET_USER_LABELS (
  policy_name       => 'CS_OLS',
  user_name         => 'QL008',
  max_read_label    => 'MGR:BPKT:MN',
  max_write_label   => 'MGR:BPKT:MN',
  def_label         => 'MGR:BPKT:MN',
  row_label         => 'MGR:BPKT:MN');

END;
/

--BEGIN
--    sa_user_admin.set_user_privs
--    (policy_name =>'CS_OLS',
--    user_name => 'BENHVIEN',
--    PRIVILEGES => 'PROFILE_ACCESS');
--END;
--/

disconnect;
--=================================================================
-- ============================ Thuc Hien Audit ===================
conn sys/1234 as sysdba;
-- DROP USER
begin
    EXECUTE IMMEDIATE 'DROP USER benhvienaudit CASCADE';
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

-- CREATE DBA USER AS SYS
create USER benhvienaudit IDENTIFIED BY "1234";
grant all privileges to benhvienaudit;
grant execute on DBMS_RLS to benhvienaudit;
grant AUDIT_ADMIN to benhvienaudit;
grant AUDIT_VIEWER to benhvienaudit;
/

-- ============================

CREATE OR REPLACE PROCEDURE benhvien.alert ( object_schema VARCHAR2, object_name VARCHAR2, policy_name VARCHAR2 )  AS 
BEGIN
    DBMS_OUTPUT.put_line('audit: ' || ' ON ' || object_schema || '.'|| object_name || ' Policy:' || policy_name);
END;
/

BEGIN
    DBMS_FGA.DISABLE_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'BenhNhan',
        POLICY_NAME => 'Read_BenhNhan'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    DBMS_FGA.DROP_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'BenhNhan',
        POLICY_NAME => 'Read_BenhNhan'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ACC_MAXBAL POLICY
BEGIN
    DBMS_FGA.DISABLE_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'NhanVien',
        POLICY_NAME => 'Select_NhanVien'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    DBMS_FGA.DROP_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'NhanVien',
        POLICY_NAME => 'Select_NhanVien'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ACC_MAXBAL POLICY
BEGIN
    DBMS_FGA.DISABLE_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'v_qlcm_dichvukham',
        POLICY_NAME => 'Read_v_qlcm_dichvukham'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    DBMS_FGA.DROP_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'v_qlcm_dichvukham',
        POLICY_NAME => 'Read_v_qlcm_dichvukham'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ACC_MAXBAL POLICY
BEGIN
    DBMS_FGA.DISABLE_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'v_kt',
        POLICY_NAME => 'Read_v_kt'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    DBMS_FGA.DROP_POLICY (
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'v_kt',
        POLICY_NAME => 'Read_v_kt'
    );
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

disconnect;

conn benhvienaudit/1234;

BEGIN
    DBMS_FGA.ADD_POLICY(
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'v_qlcm_dichvukham',
        POLICY_NAME => 'Read_v_qlcm_dichvukham',
        STATEMENT_TYPES => 'SELECT',
        HANDLER_SCHEMA => 'BENHVIEN',
        HANDLER_MODULE => 'alert'
    );
END;
/

BEGIN
    DBMS_FGA.ADD_POLICY(
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'v_kt',
        POLICY_NAME => 'Read_v_kt',
        STATEMENT_TYPES => 'SELECT',
        HANDLER_SCHEMA => 'BENHVIEN',
        HANDLER_MODULE => 'alert'
    );
END;
/

BEGIN
    DBMS_FGA.ADD_POLICY(
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'BenhNhan',
        POLICY_NAME => 'Read_BenhNhan',
        AUDIT_COLUMN => 'TrieuChung',
        STATEMENT_TYPES => 'SELECT',
        HANDLER_SCHEMA => 'BENHVIEN',
        HANDLER_MODULE => 'alert'
    );
END;
/

BEGIN
    DBMS_FGA.ADD_POLICY(
        OBJECT_SCHEMA => 'BENHVIEN',
        OBJECT_NAME => 'NhanVien',
        POLICY_NAME => 'Select_NhanVien',
        AUDIT_COLUMN => 'LuongCoBan',
        STATEMENT_TYPES => 'SELECT',
        HANDLER_SCHEMA => 'BENHVIEN',
        HANDLER_MODULE => 'alert',
        AUDIT_COLUMN_OPTS => DBMS_FGA.ALL_COLUMNS
    );
END;
/

disconnect;
--==============================================================





