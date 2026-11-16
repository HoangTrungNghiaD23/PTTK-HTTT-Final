package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Service7;

/**
 * Lop truy xuat du lieu dich vu (tblService7).
 */
public class ServiceDAO7 extends DAO7 {

    public ServiceDAO7() {
        super();
    }

    /**
     * Tim kiem danh sach dich vu co ten chua tu khoa.
     */
    public Service7[] searchServiceByName(String keyword) {
        List<Service7> results = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty() || !ensureConnection()) {
            return new Service7[0];
        }

        String sql = "SELECT id, serviceCode, name, unitPrice, estimatedDuration, description "
                   + "FROM tblService7 WHERE name LIKE ? ORDER BY id ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapService(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results.toArray(new Service7[0]);
    }

    /**
     * Lay thong tin chi tiet cua mot dich vu theo id.
     */
    public Service7 getServiceDetail(int idService) {
        if (idService <= 0 || !ensureConnection()) {
            return null;
        }

        String sql = "SELECT id, serviceCode, name, unitPrice, estimatedDuration, description "
                   + "FROM tblService7 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idService);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapService(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Service7 mapService(ResultSet rs) throws SQLException {
        Service7 service = new Service7();
        service.setId(rs.getInt("id"));
        service.setServiceCode(rs.getString("serviceCode"));
        service.setName(rs.getString("name"));
        service.setUnitPrice(rs.getFloat("unitPrice"));
        service.setEstimatedDuration(rs.getInt("estimatedDuration"));
        service.setDescription(rs.getString("description"));
        return service;
    }
}
