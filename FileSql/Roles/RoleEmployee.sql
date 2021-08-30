-- Cấp quyền trên các bảng cho employee
grant select on HoSoBenhNhan to employee
grant select on Thuoc to employee
grant select on Phong to employee
grant select on Loaithuoc to employee
grant update on TaiKhoan to employee
-- Cấp quyền trên các StoreProcedure cho employee
grant exec on sp_DanhSachBenhNhan to employee
grant exec on sp_DoTuoiBenhNhan to empoyee
grant exec on sp_HoSoHetHan to employee
grant exec on sp_NoiTruDieuTri to employee
grant exec on sp_DanhSachPhong to employee
grant exec on sp_DanhSachThuocTrongMoiLoai to employee
grant exec on sp_DanhSachPhong to employee
grant exec on sp_NhapHoSoKhamBenh to employee
grant exec on sp_ThongTinCaPhatThuocChoBenhNhan to employee
-- Cấp quyền trên các Function cho employee
Grant exec on TF_SLYTaTrucPhong to employee
grant exec on KT_Thuoc to employee
grant select on TF_TimKiemThuoc to employee
grant select on TF_TimKiemPhong to employee
grant select on PF_SoLuongGiuong to employee
grant select on HSF_TimKiemHoSoBenhNhan to employee
grant select on HSF_PhanTramDenKham to employee
grant exec on KT_Phong to employee
grant exec on KT_NoiTruDieuTri to employee
