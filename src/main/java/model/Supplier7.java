package model;

import java.io.Serializable;

/**
 * Thuc the Nha cung cap (tuong ung bang tblSupplier7).
 */
public class Supplier7 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String supplierCode;
    private String name;
    private String address;
    private String phone;
    private String email;
    private String contactPerson;
    private String note;

    public Supplier7() {
    }

    public Supplier7(int id, String supplierCode, String name, String address,
                     String phone, String email, String contactPerson, String note) {
        this.id = id;
        this.supplierCode = supplierCode;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.contactPerson = contactPerson;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSupplierCode() {
        return supplierCode;
    }

    public void setSupplierCode(String supplierCode) {
        this.supplierCode = supplierCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
