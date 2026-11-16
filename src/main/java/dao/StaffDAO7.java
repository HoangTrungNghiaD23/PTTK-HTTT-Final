package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Staff7;

/**
 * Lop truy xuat du lieu nhan vien (tblStaff7).
 */
public class StaffDAO7 extends DAO7 {

    public StaffDAO7() {
        super();
    }

    /**
     * Kiem tra thong tin dang nhap va cap nhat day du thuoc tinh vao doi tuong staff.
     */
    public boolean checkLogin(Staff7 staff) {
        if (staff == null || staff.getUsername() == null || staff.getPassword() == null) {
            return false;
        }
        String username = staff.getUsername().trim();
        String password = staff.getPassword();
        if (username.isEmpty() || password.isEmpty() || !ensureConnection()) {
            return false;
        }

        String sql = "SELECT id, staffCode, username, password, fullName, dateOfBirth, "
                   + "address, phone, email, position, role, note "
                   + "FROM tblStaff7 WHERE username = ? AND password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staff.setId(rs.getInt("id"));
                    staff.setStaffCode(rs.getString("staffCode"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPassword(rs.getString("password"));
                    staff.setFullName(rs.getString("fullName"));
                    staff.setDateOfBirth(rs.getDate("dateOfBirth"));
                    staff.setAddress(rs.getString("address"));
                    staff.setPhone(rs.getString("phone"));
                    staff.setEmail(rs.getString("email"));
                    staff.setPosition(rs.getString("position"));
                    staff.setRole(rs.getString("role"));
                    staff.setNote(rs.getString("note"));
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
