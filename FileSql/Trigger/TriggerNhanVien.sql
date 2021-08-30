use BenhVien
go
Create trigger [dbo].[DieuKienNhanVien] on [dbo].[NhanVien] for insert,update
as
begin
    declare @manv varchar(20),@tuoi int , @temp datetime,@chucvu nvarchar(20)
    --lay manv muon insert hay update 
    select @temp=inserted.NgSinh,@chucvu=inserted.ChucVu from inserted
    --tinh tuo
    set @tuoi=datediff(YEAR,@temp,GETDATE())
	print @tuoi
    if(@chucvu=N'Bác sĩ')
    begin
		if(@tuoi<35)
		begin
			print N'Bac si phai tu 35 tuoi!!!'
			rollback
        return
		end       
    end
    else
    begin
		if(@tuoi<25)
		begin
			print 'Y ta phai tu 25 tuoi!!!'
			rollback
        return
		end
    end
end
go
