package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Supplier7;

/**
 * Lop truy xuat du lieu nha cung cap (tblSupplier7).
 */
public class SupplierDAO7 extends DAO7 {

    public SupplierDAO7() {
        super();
    }

    /**
     * Tim kiem danh sach nha cung cap co ten chua tu khoa.
     */
    public Supplier7[] searchSupplierByName(String keyword) {
        List<Supplier7> results = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty() || !ensureConnection()) {
            return new Supplier7[0];
        }

        String sql = "SELECT id, supplierCode, name, address, phone, email, contactPerson, note "
                   + "FROM tblSupplier7 WHERE name LIKE ? ORDER BY id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapSupplier(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results.toArray(new Supplier7[0]);
    }

    /**
     * Lay thong tin nha cung cap theo id.
     */
    public Supplier7 getSupplierById(int idSupplier) {
        if (idSupplier <= 0 || !ensureConnection()) {
            return null;
        }
        String sql = "SELECT id, supplierCode, name, address, phone, email, contactPerson, note "
                   + "FROM tblSupplier7 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idSupplier);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSupplier(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Them moi mot nha cung cap vao tblSupplier7 va gan id tu sinh cho doi tuong supplier.
     */
    public boolean addSupplier(Supplier7 supplier) {
        if (supplier == null || !ensureConnection()) {
            return false;
        }

        String sql = "INSERT INTO tblSupplier7(supplierCode, name, address, phone, email, contactPerson, note) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, supplier.getSupplierCode());
            ps.setString(2, supplier.getName());
            ps.setString(3, supplier.getAddress());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getEmail());
            ps.setString(6, supplier.getContactPerson());
            ps.setString(7, supplier.getNote());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        supplier.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Supplier7 mapSupplier(ResultSet rs) throws SQLException {
        Supplier7 supplier = new Supplier7();
        supplier.setId(rs.getInt("id"));
        supplier.setSupplierCode(rs.getString("supplierCode"));
        supplier.setName(rs.getString("name"));
        supplier.setAddress(rs.getString("address"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setEmail(rs.getString("email"));
        supplier.setContactPerson(rs.getString("contactPerson"));
        supplier.setNote(rs.getString("note"));
        return supplier;
    }
}
