use BenhVien
go
Create proc [dbo].[sp_DanhSachThoiDiemKhamBenh]
as 
begin 
	select * from ThoiDiemKhamBenh
end
go
Create function [dbo].[KT_ThoiDiemKham](@mahoso varchar(20),@thoidiemkham datetime) returns int
as
begin
	declare @dem int
	select @dem=count(*) from ThoiDiemKhamBenh where ThoiDiemKhamBenh.MaHoSo=@thoidiemkham and ThoiDiemKhamBenh.MaHoSo=@mahoso
	return @dem
end
go
create proc [dbo].[sp_ThemThoiDiemKham] (@MaNhanVien char(20),@ThoiDiemKham datetime,@MaHoSo char(20))
as
begin
     if(dbo.KT_ThoiDiemKham (@MaHoSo,@ThoiDiemKham)=0)
	 begin
	      insert ThoiDiemKhamBenh(MaNv,ThoiDiemKham,MaHoSo) values (@MaNhanVien,@ThoiDiemKham,@MaHoSo)
	 end
end
go
Create proc [dbo].[sp_SuaThoiDiemKham] (@MaNV varchar(20),@ThoiDiemKham datetime,@MaHoSo varchar(20))
as
begin
     update ThoiDiemKhamBenh set ThoiDiemKham=@ThoiDiemKham
	 where ThoiDiemKham=@ThoiDiemKham and MaHoSo=@MaHoSo
end
go
Create proc [dbo].[sp_LocTheoThoiGian] @index int
as
begin
	if(@index=0)
	begin
		select * from ThoiDiemKhamBenh where datediff(day,ThoiDiemKhamBenh.ThoiDiemKham,GETDATE())=0
	end
	else if(@index=1)
	begin
		select * from ThoiDiemKhamBenh where datediff(day,ThoiDiemKhamBenh.ThoiDiemKham,GETDATE())<=7
	end
	else
	begin
		select * from ThoiDiemKhamBenh where datediff(day,ThoiDiemKhamBenh.ThoiDiemKham,GETDATE())>=7
		and datediff(day,ThoiDiemKhamBenh.ThoiDiemKham,GETDATE())<=31
	end
end

