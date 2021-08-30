use BenhVien
go
-- Danh sách nhân viên
Create proc [dbo].[sp_DanhSachNhanVien]
as
begin
	select*from NhanVien
end
-- Lọc nhân viên theo chức vụ
Create proc [dbo].[sp_DanhSachNhanVienTheoChucVu] @ChucVu nvarchar(10)
as
begin
	select *from NhanVien where ChucVu=@ChucVu

end
go
-- Kiểm tra khóa chính 
Create function [dbo].[KT_NhanVien](@maNV varchar(20)) returns int
as
begin
	declare @dem int
	select @dem=count(*) from NhanVien where NhanVien.MaNV=@maNV
	return @dem
end
go
Create proc [dbo].[sp_NhapNhanVien]
@MANV varchar(20),@TenVN nvarchar(20),@SDT char(11),
@DiaChi nvarchar(40),@GioiTinh nvarchar(5),@ChucVu nvarchar(10),
@Luong float,@ngsinh datetime,@hinh image
as
begin
	if(dbo.KT_NhanVien(@MANV)=0)
	begin
		insert dbo.NhanVien(MaNV,TenNV,SDT,DiaChi,GioiTinh,ChucVu,Luong,NgSinh,hinh)
		values (@MANV,@TenVN,@SDT,@DiaChi,@GioiTinh,@ChucVu,@Luong,@ngsinh,@hinh)		
	end
end
go
Create proc [dbo].[sp_SapXepNhanVienTheoTen] 
as
begin
    select *from NhanVien 
    order by TenNV desc ---asc tang dang dan # desc
end
go
-- Sửa thông tin nhân viên
Create proc [dbo].[sp_SuaNhanVien] @MANV varchar(20),@TenVN nvarchar(20),@SDT char(11),
@DiaChi nvarchar(40),@GioiTinh nvarchar(5),@ChucVu nvarchar(10),
@Luong float,@ngsinh datetime,@hinh image
as 
begin
	update dbo.NhanVien
	set TenNV=@TenVN,SDT=@SDT,DiaChi=@DiaChi,
	GioiTinh=@GioiTinh,ChucVu=@ChucVu,Luong=@Luong,NgSinh=@ngsinh,hinh=@hinh
	where @MANV=MaNV
end
go
-- Xóa nhân viên
Create  proc [dbo].[sp_XoaNhanVien](@id varchar(20))
as
begin
	begin transaction XoaNhanVien
	--xoa nhan vien trong bang Thoi diem kham benh
	delete ThoiDiemKhamBenh where ThoiDiemKhamBenh.MaNv in
	(select MaNv from ThoiDiemKhamBenh where ThoiDiemKhamBenh.MaNv=@id)
	--xoa nhan vien trong bang Noi tru dieu tri
	delete NoiTruDieuTri where NoiTruDieuTri.MaNV in	
	(select MaNv from NoiTruDieuTri where NoiTruDieuTri.MaNV=@id)
	--Xoa nhan vien trong bang Nhan Vien
	delete NhanVien where NhanVien.MaNV=@id
	--loi
	if(@@ERROR<>0)
	begin
		rollback transaction
		return 
	end
		--cho phep xoa
	else
		begin
		commit transaction XoaNhanVien	
		print 'Xoa Nhan Vien Thanh Cong'
		end
end

go
-- Tìm kiếm bệnh nhân theo tên nhân viên 
Create function [dbo].[TF_TimKiemNhanVien] (@tenNhanVien nvarchar(20))
returns table
as
return(    select*
        from NhanVien nv
        where nv.TenNV like '%'+@tenNhanVien+'%')

go
