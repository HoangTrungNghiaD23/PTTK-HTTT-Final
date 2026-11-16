package model;

import java.io.Serializable;
import java.sql.Date;

/**
 * Thuc the Nhan vien (tuong ung bang tblStaff7).
 */
public class Staff7 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String staffCode;
    private String username;
    private String password;
    private String fullName;
    private Date dateOfBirth;
    private String address;
    private String phone;
    private String email;
    private String position;
    private String role;
    private String note;

    public Staff7() {
    }

    public Staff7(int id, String staffCode, String username, String password,
                  String fullName, Date dateOfBirth, String address,
                  String phone, String email, String position, String role, String note) {
        this.id = id;
        this.staffCode = staffCode;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.position = position;
        this.role = role;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStaffCode() {
        return staffCode;
    }

    public void setStaffCode(String staffCode) {
        this.staffCode = staffCode;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
