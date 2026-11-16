package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.SparePart7;

/**
 * Lop truy xuat du lieu phu tung (tblSparePart7).
 */
public class SparePartDAO7 extends DAO7 {

    public SparePartDAO7() {
        super();
    }

    /**
     * Tim kiem danh sach phu tung co ten chua tu khoa.
     */
    public SparePart7[] searchSparePartByName(String keyword) {
        List<SparePart7> results = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty() || !ensureConnection()) {
            return new SparePart7[0];
        }

        String sql = "SELECT id, partCode, name, manufacturer, unit, unitPrice, stockQuantity, description "
                   + "FROM tblSparePart7 WHERE name LIKE ? ORDER BY id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapSparePart(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results.toArray(new SparePart7[0]);
    }

    /**
     * Lay thong tin chi tiet cua mot phu tung theo id.
     */
    public SparePart7 getSparePartDetail(int idPart) {
        if (idPart <= 0 || !ensureConnection()) {
            return null;
        }

        String sql = "SELECT id, partCode, name, manufacturer, unit, unitPrice, stockQuantity, description "
                   + "FROM tblSparePart7 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPart);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSparePart(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Them moi mot phu tung vao tblSparePart7 va gan id tu sinh cho doi tuong part.
     */
    public boolean addSparePart(SparePart7 part) {
        if (part == null || !ensureConnection()) {
            return false;
        }

        String sql = "INSERT INTO tblSparePart7(partCode, name, manufacturer, unit, unitPrice, stockQuantity, description) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, part.getPartCode());
            ps.setString(2, part.getName());
            ps.setString(3, part.getManufacturer());
            ps.setString(4, part.getUnit());
            ps.setFloat(5, part.getUnitPrice());
            ps.setInt(6, part.getStockQuantity());
            ps.setString(7, part.getDescription());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        part.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cap nhat cong don so luong ton kho cho phu tung.
     */
    public boolean updateStockQuantity(int idPart, int addedQty) {
        if (idPart <= 0 || addedQty <= 0 || !ensureConnection()) {
            return false;
        }
        try {
            return updateStockQuantity(this.con, idPart, addedQty);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Dung chung logic cap nhat ton kho tren mot Connection cu the (phuc vu giao dich ImportInvoiceDAO7).
     */
    public static boolean updateStockQuantity(Connection conn, int idPart, int addedQty) throws SQLException {
        if (conn == null || idPart <= 0 || addedQty <= 0) {
            return false;
        }
        String sql = "UPDATE tblSparePart7 SET stockQuantity = stockQuantity + ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addedQty);
            ps.setInt(2, idPart);
            return ps.executeUpdate() > 0;
        }
    }

    private SparePart7 mapSparePart(ResultSet rs) throws SQLException {
        SparePart7 part = new SparePart7();
        part.setId(rs.getInt("id"));
        part.setPartCode(rs.getString("partCode"));
        part.setName(rs.getString("name"));
        part.setManufacturer(rs.getString("manufacturer"));
        part.setUnit(rs.getString("unit"));
        part.setUnitPrice(rs.getFloat("unitPrice"));
        part.setStockQuantity(rs.getInt("stockQuantity"));
        part.setDescription(rs.getString("description"));
        return part;
    }
}
