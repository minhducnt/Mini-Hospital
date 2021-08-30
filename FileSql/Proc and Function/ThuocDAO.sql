use BenhVien
go
Create function [dbo].[KT_Thuoc] (@mathuoc varchar(20))
returns int
as
begin
    declare @dem int
	select @dem=COUNT(*)
	from THUOC
	where THUOC.MaThuoc=@mathuoc
    return @dem
end

go
Create proc  [dbo].[sp_NhapThuoc] @mathuoc varchar(20),@tenthuoc nvarchar(50), @gia float, @soluong int,@maloaithuoc varchar(20),@hinhthuoc image
as
begin
     if( dbo.KT_Thuoc(@mathuoc)=0)
	 begin
	     insert into THUOC(MaThuoc,TenThuoc,Gia,SoLuong,MaLoaiThuoc,hinhthuoc) 
		 values (@mathuoc,@tenthuoc , @gia, @soluong ,@maloaithuoc ,@hinhthuoc)
	 end
end
go
Create proc [dbo].[sp_SuaThuoc] @MaThuoc varchar(20), @TenThuoc nvarchar(50), @gia float, @SoLuong int,
@MaLoaiThuoc varchar(20), @HinhThuoc image
as
begin
     
     update dbo.THUOC set  TenThuoc= @TenThuoc,Gia=@gia,SoLuong= @SoLuong,MaLoaiThuoc= @MaLoaiThuoc,hinhthuoc=@HinhThuoc
	  where MaThuoc= @MaThuoc	  
end
go
Create proc [dbo].[sp_DanhSachThuocTrongMoiLoai] @TenLoaiThuoc nvarchar(50)
as
begin
     select t.MaThuoc,TenThuoc,t.Gia,t.SoLuong,t.MaLoaiThuoc,t.hinhthuoc
	 from THUOC t inner join LOAITHUOC lt
	 on lt.MaLoaiThuoc=t.MaLoaiThuoc and lt.TenLoaiThuoc=@TenLoaiThuoc
end
go
Create function [dbo].[TF_TimKiemPhong] (@tenphong nvarchar(50))
returns table
as
return(    select*
        from Phong p
        where p.TenPhong like '%'+@tenphong+'%')
