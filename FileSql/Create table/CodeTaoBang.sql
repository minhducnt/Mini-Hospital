Create database BenhVien
go
Create table NhanVien
(
	MaNV varchar(20) primary key,
	TenNV nvarchar(20) not null,
	SDT char(11),
	DiaChi nvarchar(40),
	GioiTinh nvarchar(5),
	ChucVu nvarchar(10) not null,
	Luong float,
	NgSinh datetime default getdate(),
	hinh image,
	Check(Luong>10000)
)
go
CREATE TABLE HoSoBenhNhan
(
	MaHoSo varchar(20) primary key,
	TenBenhNhan nvarchar(30) not null,
	DiaChi nvarchar(30),
	SDT char(11),
	GioiTinh nvarchar(10),
	NgSinh Datetime not null,
	NgLapHoSo Datetime not null default getdate(),
	NgHetHanHoSo Datetime not null default getdate(),
	hinh image
)
go
Create table Phong
(
	MaPhong varchar(20) primary key,
	TenPhong nvarchar(50) not null,
	ViTri nvarchar(20),
	SoLuongGiuong int check(SoLuongGiuong > 0),
	unique(vitri)    
)
go
CREATE TABLE LOAITHUOC
(
	MaLoaiThuoc varchar(20) primary key,
	TenLoaiThuoc nvarchar(200) not null
)
go
CREATE TABLE THUOC
(
	MaThuoc varchar(20) primary key,
	TenThuoc nvarchar(50) not null,
	Gia float,
	SoLuong int,
	MaLoaiThuoc varchar(20) foreign key references LoaiThuoc(MaLoaiThuoc),
	hinhthuoc image,
	Check(Gia>1000)
)
go
CREATE TABLE CapPhatThuoc
(
	MaHoSo varchar(20) foreign key references HoSoBenhNhan(MaHoSo),
	MaThuoc varchar(20) foreign key references Thuoc(MaThuoc),
	ThoiDiemCap datetime not null default getdate(),
	SoLuong int,
	Primary key(MaHoSo,MaThuoc)
)
go
Create table ThoiDiemKhamBenh
(
	MaNv varchar(20) foreign key references NhanVien(Manv),
	ThoiDiemKham datetime not null default getdate(),
	MaHoSo varchar(20) foreign key references HoSoBenhNhan(MaHoSo),
	primary key(ThoiDiemKham,MaHoSo)
)
go
Create table ThoiDiemKhamBenh
(
	MaNv varchar(20) foreign key references NhanVien(Manv),
	ThoiDiemKham datetime not null default getdate(),
	MaHoSo varchar(20) foreign key references HoSoBenhNhan(MaHoSo),
	primary key(ThoiDiemKham,MaHoSo)
)
go
Create table TaiKhoan
(
	Manv varchar(20) foreign key references NhanVien(Manv),
    Account varchar(20) primary key,
    password1 varchar(20) not null,
    UserName varchar(20) not null,
    roles varchar(20) not null,
	unique(Manv)
)
