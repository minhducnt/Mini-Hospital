use BenhVien
go
Create function [dbo].[KT_CapPhatThuoc](@mahoso varchar(20),@mathuoc varchar(20)) returns int
as
begin
	declare @dem int
	select @dem=count(*) from CapPhatThuoc where CapPhatThuoc.MaHoSo=@mahoso and CapPhatThuoc.MaThuoc=@mathuoc
	return @dem
end
go
create proc [dbo].[sp_ThemCapPhatThuoc](@MaHoSo varchar(20),@MaThuoc varchar(20),@ThoiDiemCap datetime,@SoLuong int)
as
begin
     if(dbo.KT_CapPhatThuoc (@MaHoSo,@MaThuoc)=0)
	 begin
	     insert CapPhatThuoc(MaHoSo,MaThuoc,ThoiDiemCap,SoLuong) values (@MaHoSo,@MaThuoc,@ThoiDiemCap,@SoLuong)
	 end
end
go
Create proc [dbo].[sp_XoaCapPhatThuoc] (@MaHoSo varchar(20),@MaThuoc char(20))
as
begin
    begin transaction XoaCapPhatThuoc
	
	delete CapPhatThuoc where MaHoSo=@MaHoSo and MaThuoc=@MaThuoc
	--loi
	if(@@ERROR<>0)
	begin
		rollback transaction
		return 
	end
		--cho phep xoa
	else
		begin
		commit transaction XoaCapPhatThuoc	
		end
end
go
-- Danh sách cấp phát thuốc
CREATE proc [dbo].[sp_DanhSachCapPhatThuoc](@mahoso varchar(20))
as
begin
	select * from CapPhatThuoc where CapPhatThuoc.MaHoSo=@mahoso
end
go
Create proc [dbo].[sp_SuaCapPhatThuoc](@MaHoSo varchar(20),@MaThuoc varchar(20),@ThoiDiemCap datetime,@SoLuong int)
as
begin
     update CapPhatThuoc set ThoiDiemCap=@ThoiDiemCap,SoLuong=@SoLuong
	 where MaHoSo=@MaHoSo and MaThuoc=@MaThuoc
end
go
Create proc [dbo].[sp_ThongTinCaPhatThuocChoBenhNhan] (@mahs varchar(20))
as
begin
   select  t.TenThuoc, cpt.SoLuong,cpt.ThoiDiemCap , sum(cpt.SoLuong*t.Gia) as SoTien
   from HoSoBenhNhan hs,CapPhatThuoc cpt,THUOC t
   where hs.MaHoSo = cpt.MaHoSo and t.MaThuoc=cpt.MaThuoc and hs.MaHoSo=@mahs
   group by hs.MaHoSo,hs.TenBenhNhan, t.TenThuoc, cpt.SoLuong,cpt.ThoiDiemCap
end
