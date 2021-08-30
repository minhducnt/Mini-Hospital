use BenhVien
go
--Tạo tài khoản
Create trigger [dbo].[TaoTaiKhoan] on [dbo].[TaiKhoan] for insert
as
begin
     begin transaction
	 declare @Account varchar(20),@password1 varchar(20),@UserName varchar(20),@roles varchar(20)
	 select @Account=inserted.Account,@password1=inserted.password1,@UserName=inserted.UserName,@roles=inserted.roles from inserted
	 --Them login
	 declare @CreateLogin nvarchar(200)
	 set @CreateLogin = 'CREATE LOGIN ['+@Account+'] WITH PASSWORD = '''+@password1+''''+', DEFAULT_DATABASE=[BenhVien]'
	 execute (@CreateLogin)

	 --Them user
	 declare @CreateUser NVARCHAR(200)
	 Set @CreateUser = 'CREATE USER [' + @UserName + '] FOR LOGIN [' + @Account + ']'
	 execute(@CreateUser)

	 --Gan role cho user
	 if(@roles='manager')
	 begin
		execute sp_addrolemember 'manager', @UserName
	 end
	 else if(@roles = 'employee')
			begin
				execute sp_addrolemember 'employee', @UserName
			end
	-- Rollback khi có loi
	if (@@ERROR <> 0)
	begin
		raiserror(N'Loi he thong', 16, 1)
		rollback transaction
		return
	end
	commit transaction
end
go
Create trigger [dbo].[CapNhatTaiKhoan] on [dbo].[TaiKhoan] for update
as
begin
	declare @Account varchar(20), @oldpass varchar(20),@newpass varchar(20)
	select @Account=deleted.Account,@oldpass=deleted.password1 from deleted
	select @newpass=inserted.password1 from inserted
	if(@newpass=@oldpass) 
		return
	begin transaction
	--Cap nhat
	declare @Update nvarchar(200)
	set @Update = 'ALTER LOGIN [' + @Account + '] WITH PASSWORD = ''' + @newpass + ''''
	print (@Update)
	execute (@Update)
	--Rollback khi co loi
	if(@@ERROR <> 0)
	begin
		Raiserror(N'Loi cap nhat', 16, 1)
		rollback transaction
		return
	end
	commit transaction
end
go
ALTER trigger [dbo].[XoaTaiKhoan] on [dbo].[TaiKhoan] for delete
as
begin
	begin transaction
	declare @Account varchar(20), @User varchar(20)
	select @Account=deleted.Account,@User=deleted.UserName from deleted

	--Xoa user
	declare @DeleteUser NVARCHAR(200)
	set @DeleteUser = 'DROP USER ' + @User
	execute(@DeleteUser)

	--Xoa tai khoan
	declare @DeleteLogin NVARCHAR(200)
	set @DeleteLogin = 'DROP LOGIN ' + @Account
	execute(@DeleteLogin)

	--Rollback khi co loi
	if(@@ERROR <> 0)
	begin
		Raiserror(N'Loi xoa tai khoan', 16, 1)
		rollback transaction
		return
	end
	commit transaction
end
