use BenhVien
go
create proc [dbo].[sp_DanhSachPhong]
as
begin
     select * from Phong
end
go
Create function [dbo].[KT_Phong](@MaPhong varchar(20)) returns int
as
begin
	declare @dem int
	select @dem=count(*) from Phong where Phong.MaPhong=@MaPhong
	return @dem
end
go
Create proc [dbo].[sp_NhapPhong] 
@MaPhong varchar(20),@TenPhong nvarchar(50),
@Vitri nvarchar(20),@SLGiuong int
as
begin
	if(dbo.KT_Phong(@MaPhong)=0)
	begin
		insert dbo.Phong(MaPhong,TenPhong,Vitri,SoLuongGiuong)
		values (@MaPhong,@TenPhong,@Vitri,@SLGiuong)		
	end
end

go
Create proc [dbo].[sp_SuaThongTinPhong] @MaPhong char(20),@TenPhong nvarchar(50),
@Vitri nvarchar(20),@SLGiuong int
as 
begin
	update dbo.Phong
	set TenPhong=@TenPhong,ViTri=@Vitri,
	SoLuongGiuong=@SLGiuong
	where MaPhong=@MaPhong
end
go
Create proc [dbo].[sp_XoaPhong](@MaPhong char(20))
as
begin
	begin transaction XoaPhong
	--xoa Phong Trong Bang Noi tru Dieu tri truoc
	delete NoiTruDieuTri where NoiTruDieuTri.MaPhong in
	(select MaPhong from NoiTruDieuTri where NoiTruDieuTri.MaPhong=@MaPhong)	
	--Xoa Phong
	delete Phong where Phong.MaPhong=@MaPhong
	--loi
	if(@@ERROR<>0)
	begin
		rollback transaction
		return 
			end
		--cho phep xoa
	else
		begin
		commit transaction XoaPhong
		end
end

go
create function [dbo].[TF_SLYTaTrucPhong](@maphong varchar(20))
returns int
as
begin
	declare @soluong int
	SET @soluong=0
    select @soluong=count(nv.MaNV) from NhanVien nv ,NoiTruDieuTri nt,Phong p
    where nv.MaNV=nt.MaNV and nv.ChucVu='Y ta'and
	p.MaPhong=@maphong and nt.MaPhong=@maphong  group by p.MaPhong
	return @soluong
end
go
Create function [dbo].[PF_SoLuongGiuong](@MaPhong varchar(20))
returns @table table (MaPhong varchar(20),SLGiuong int, SLGiuongDaDung int, SLGiuongConLai int)
as
begin
     declare @SLGiuongDaSuDung int, @SLGiuongConLai int
     select @SLGiuongDaSuDung=count(MaHoSo),@SLGiuongConLai=Phong.SoLuongGiuong-@SLGiuongDaSuDung from NoiTruDieuTri inner join Phong 
    on NoiTruDieuTri.MaPhong=Phong.MaPhong where NoiTruDieuTri.MaPhong=@MaPhong group by Phong.MaPhong,Phong.SoLuongGiuong
    insert @table select Phong.MaPhong,Phong.SoLuongGiuong,@SLGiuongDaSuDung,@SLGiuongConLai
    from NoiTruDieuTri inner join Phong on NoiTruDieuTri.MaPhong=Phong.MaPhong
    where NoiTruDieuTri.MaPhong=@MaPhong group by Phong.MaPhong,Phong.SoLuongGiuong
    return
end
