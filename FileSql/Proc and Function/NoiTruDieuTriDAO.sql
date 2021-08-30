use BenhVien
go
-- Kiểm tra khóa chính
Create function [dbo].[KT_NoiTruDieuTri](@MaHS varchar(20),@MaNV varchar(20),@MaPhong varchar(20)) returns int
as
begin
    declare @dem int
    select @dem=count(*) from NoiTruDieuTri where MaHoSo=@MaHS and MaNV=@MaNV and MaPhong=@MaPhong
    return @dem
end
go
Create proc [dbo].[sp_NhapNoiTruDieuTri] @MaHS varchar(20),@MaNV varchar(20),@MaPhong varchar(20),@ThoiDiemTruc datetime,@NgayBatDau datetime,@NgayKetThuc datetime
as
begin
    if(dbo.KT_NoiTruDieuTri(@MaHS,@MaNV,@MaPhong)=0)
    begin
        insert dbo.NoiTruDieuTri (MaHoSo,MaNV,MaPhong,ThoiDiemTrucPhong,NgayBatDauNoiTru,NgayKetThucNoiTru)
        values (@MaHS,@MaNV,@MaPhong,@ThoiDiemTruc,@NgayBatDau,@NgayKetThuc)
    end
end
go
Create proc [dbo].[sp_SuaNoiTruDieuTri] @MaHS varchar(20),@MaNV varchar(20),@MaPhong varchar(20),
@ThoiDiemTruc datetime,@NgayBatDau datetime,@NgayKetThuc datetime
as
begin
        update dbo.NoiTruDieuTri
        set ThoiDiemTrucPhong =@ThoiDiemTruc ,NgayBatDauNoiTru=@NgayBatDau,NgayKetThucNoiTru=@NgayKetThuc
        where MaHoSo=@MaHS and MaNV=@MaNV and MaPhong=@MaPhong
end
go
Create proc [dbo].[sp_DanhSachNoiTruDieuTri]
as
begin
    select *from NoiTruDieuTri
end
go
Create proc [dbo].[sp_LocDuLieu]
as
begin
    delete NoiTruDieuTri where NoiTruDieuTri.NgayKetThucNoiTru<GETDATE()
end
go
Create proc sp_XoaNoiTruDieuTri @MaHS varchar(20),@MaNV varchar(20),@MaPhong varchar(20)
as
begin
    begin transaction XoaNoiTru
        delete NoiTruDieuTri where MaHoSo=@MaHS and MaNV=@MaNV and MaPhong=@MaPhong
    if(@@ERROR<>0)
        begin
            rollback transaction
            return
        end
    else
        begin
            commit transaction XoaNoiTru
            print'Xoa thanh cong'
        end
end
