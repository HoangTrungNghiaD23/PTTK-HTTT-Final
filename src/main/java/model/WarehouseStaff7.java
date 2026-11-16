package model;

import java.sql.Date;

/**
 * Thuc the Nhan vien kho (ke thua Staff7).
 */
public class WarehouseStaff7 extends Staff7 {
    private static final long serialVersionUID = 1L;

    public WarehouseStaff7() {
        super();
    }

    public WarehouseStaff7(int id, String staffCode, String username, String password,
                           String fullName, Date dateOfBirth, String address,
                           String phone, String email, String position, String role, String note) {
        super(id, staffCode, username, password, fullName, dateOfBirth,
              address, phone, email, position, role, note);
    }

    /**
     * Sao chep thong tin tu doi tuong Staff7 sau khi xac thuc dang nhap thanh cong.
     */
    public WarehouseStaff7(Staff7 staff) {
        super(
            staff != null ? staff.getId() : 0,
            staff != null ? staff.getStaffCode() : null,
            staff != null ? staff.getUsername() : null,
            staff != null ? staff.getPassword() : null,
            staff != null ? staff.getFullName() : null,
            staff != null ? staff.getDateOfBirth() : null,
            staff != null ? staff.getAddress() : null,
            staff != null ? staff.getPhone() : null,
            staff != null ? staff.getEmail() : null,
            staff != null ? staff.getPosition() : null,
            staff != null ? staff.getRole() : null,
            staff != null ? staff.getNote() : null
        );
    }
}
