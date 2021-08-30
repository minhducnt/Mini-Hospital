use BenhVien
go
create proc [dbo].[sp_DanhSachBenhNhan]
as
begin
     select * from HoSoBenhNhan
end
go
Create function [dbo].[KT_HoSoKhamBenh] (@MaHoSo varchar(20))
returns int
as
begin
     declare @dem int
	 select @dem = count(*)
	 from HoSoBenhNhan as hs
	 where @MaHoSo = hs.MaHoSo
	 return @dem
end
go
create proc [dbo].[sp_NhapHoSoKhamBenh] @MaHoSo varchar(20), @TenBenhNhan nvarchar(30), @DiaChi nvarchar(30), @SDT char(11),
@GioiTinh nvarchar(10), @NgSinh Datetime, @NgLapHoSo Datetime, @NgHetHanHoSo Datetime , @hinh image
as
begin
     if (dbo.KT_HoSoKhamBenh (@MaHoSo)=0)
	 begin
     insert HoSoBenhNhan (MaHoSo, TenBenhNhan, DiaChi, SDT, GioiTinh, NgSinh, NgLapHoSo, NgHetHanHoSo, hinh)
	  values (@MaHoSo, @TenBenhNhan, @DiaChi, @SDT, @GioiTinh, @NgSinh, @NgLapHoSo, @NgHetHanHoSo, @hinh) 
	  end
end
go
Create proc [dbo].[sp_SuaHoSoKhamBenh] @MaHoSo varchar(20), @TenBenhNhan nvarchar(30), @DiaChi nvarchar(30), @SDT char(11),
@GioiTinh nvarchar(10), @NgSinh Datetime, @NgLapHoSo Datetime, @NgHetHanHoSo Datetime , @hinhbn image
as
begin
     
     update dbo.HoSoBenhNhan set TenBenhNhan= @TenBenhNhan,DiaChi=@DiaChi,SDT= @SDT,GioiTinh= @GioiTinh,NgSinh=@NgSinh,
	  NgLapHoSo= @NgLapHoSo,NgHetHanHoSo=@NgHetHanHoSo,hinh=@hinhbn
	  where MaHoSo= @MaHoSo
	  
end
go
Create proc [dbo].[sp_XoaHoSoBenhNhan] (@MaHS varchar(20))
as
begin
    begin transaction XoaHoSo
	delete dbo.NoiTruDieuTri where NoiTruDieuTri.MaHoSo in (
	select hs.MaHoSo from HoSoBenhNhan hs where hs.MaHoSo=@MaHS)
	delete dbo.CapPhatThuoc where CapPhatThuoc.MaHoSo  in (
	select cpt.MaHoSo from CapPhatThuoc cpt where cpt.MaHoSo=@MaHS)
	delete dbo.ThoiDiemKhamBenh where ThoiDiemKhamBenh.MaHoSo  in (
	select td.MaHoSo from ThoiDiemKhamBenh td where td.MaHoSo=@MaHS)
	delete HoSoBenhNhan where HoSoBenhNhan.MaHoSo = @MaHS
	if(@@ERROR <> 0)
	begin
	    rollback transaction 
		return
	end
	    commit transaction XoaHoSo
end
go
Create proc [dbo].[sp_DanhSachHoSoHetHan]
as
begin
     declare @hethan int
	 select * from HoSoBenhNhan where DATEDIFF(day,getdate(),HoSoBenhNhan.NgHetHanHoSo) <0
end
go
Create function [dbo].[HSF_TimKiemHoSoBenhNhan](@TenBenhNhan nvarchar(30))
returns table
as return 
          select * from dbo.HoSoBenhNhan hs
		  where hs.TenBenhNhan like '%' + @TenBenhNhan + '%'

go
Create function [dbo].[HSF_PhanTramDenKham]()
returns @table table(PhanTramTreEm float,PhanTramNguoiLon float, PhanTramNguoiGia float)
as
begin
     declare @TongHoSo int
     declare @PhanTramTreEm float, @PhanTramNguoiLon float, @PhanTramNguoiGia float
     declare @TreEm float, @NguoiLon float, @NguoiGia float
     select @TongHoSo = count(*) from HoSoBenhNhan
     select @TreEm= count(*) from HoSoBenhNhan where year(getdate())-year(HoSoBenhNhan.NgSinh) >=0 and year(getdate())-year(HoSoBenhNhan.NgSinh) <=16
     select @NguoiLon= count(*) from HoSoBenhNhan where year(getdate())-year(HoSoBenhNhan.NgSinh) >16 and year(getdate())-year(HoSoBenhNhan.NgSinh) <50
     select @NguoiGia=count(*) from HoSoBenhNhan where year(getdate())-year(HoSoBenhNhan.NgSinh) >=50
     set @PhanTramTreEm=(@TreEm/@TongHoSo)*100
     set @PhanTramNguoiLon=(@NguoiLon/@TongHoSo)*100
     set @PhanTramNguoiGia=(@NguoiGia/@TongHoSo)*100
	 --set convert(float, @PhanTramTreEm)
     Insert @table select @PhanTramTreEm,@PhanTramNguoiLon,@PhanTramNguoiGia
     return
end
