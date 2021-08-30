
Create trigger [dbo].[KTGiuongTrong] on [dbo].[NoiTruDieuTri] after insert
as
begin
     declare @MaPhong varchar(20), @SLGiuong int
     select @MaPhong= inserted.MaPhong from inserted 
     select @SLGiuong=p.SLGiuongConLai+1 from PF_SoLuongGiuong(@MaPhong) p
     if(@SLGiuong=0)
     begin
		print N'Trong phòng này hiện không còn giường trống '
          rollback
     end
end