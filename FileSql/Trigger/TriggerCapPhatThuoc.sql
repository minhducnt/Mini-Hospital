USE [BenhVien]
GO
/****** Object:  Trigger [dbo].[CapNhatSoThuoc]    Script Date: 5/29/2021 7:46:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create trigger [dbo].[CapNhatSoThuoc] on [dbo].[CapPhatThuoc] after update
as
begin
     declare @ngayi datetime, @ngayd datetime,@soluongi int, @soluongd int
	 declare @thuoccapphat varchar(20), @soluong int, @SlThuocTrongKho int
	 select @thuoccapphat=inserted.MaThuoc, @soluong=inserted.SoLuong,@SlThuocTrongKho=THUOC.SoLuong
	 from inserted inner join THUOC on THUOC.MaThuoc=inserted.MaThuoc
	 select @ngayi=i.ThoiDiemCap,@ngayd=d.ThoiDiemCap,@soluongi=i.SoLuong,@soluongd=d.SoLuong from inserted i, deleted d
	 -- Nếu ngày sao khi update lớn hơn ngày trước update có nghĩa là bệnh nhân này được kê thêm thuốc, vì thế lượng thuốc 
	 --trong kho sẽ bị trừ
	 if(@ngayi>@ngayd)
	 begin
	        -- Nếu thuốc trong kho hết , không thể cấp phát
			if( @SlThuocTrongKho < @soluong)
		begin
			print N'Thuốc này trong kho đã hết'
			rollback
			return 
		 end
				update Thuoc set SoLuong=SoLuong-@soluong where MaThuoc=@thuoccapphat
	end
	 -- Nếu ngày không thay đổi có nghĩa là dữ liệu có thể bị nhập sai ở đây chia ra 2 trường hợp
	 --Nếu @soluong1 >0 có nghĩa là cấp thêm thuốc , thuốc trong kho sẽ bị trừ tương ứng với lượng tăng
	 --Nếu @soluong1<0 có nghĩa là cấp phát thuốc ít đi, thuôc sẽ được trả về trong kho
	 else if(@ngayi=@ngayd)
	 begin
		  set @SlThuocTrongKho=@SlThuocTrongKho+@soluongd
		  if(@SlThuocTrongKho<@soluongi)
		  begin
			print N'Thuốc này trong kho không còn đủ để cấp'
			rollback
			return 
		  end
	      declare @soluong1 int
		  set @soluong1=@soluongi-@soluongd 
		  if(@soluong1>0)
		  begin
		      update Thuoc set SoLuong=SoLuong-@soluong1 where MaThuoc=@thuoccapphat
		  end
		  else 
		  begin
		      set @soluong1=@soluong1*-1 
			  update Thuoc set SoLuong=SoLuong+@soluong1 where MaThuoc=@thuoccapphat
		  end
	 end
end