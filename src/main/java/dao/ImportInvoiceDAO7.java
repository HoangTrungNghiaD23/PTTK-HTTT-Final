package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.ImportInvoice7;
import model.ImportSparePart7;

/**
 * Lop truy xuat du lieu hoa don nhap phu tung (tblImportInvoice7 va tblImportSparePart7).
 */
public class ImportInvoiceDAO7 extends DAO7 {

    public ImportInvoiceDAO7() {
        super();
    }

    /**
     * Luu hoa don nhap phu tung, cac dong chi tiet va cap nhat ton kho trong cung mot giao dich (Transaction).
     */
    public boolean saveImportInvoice(ImportInvoice7 invoice) {
        if (invoice == null
                || invoice.getSupplier() == null
                || invoice.getWarehouseStaff() == null
                || invoice.getListImportPart() == null
                || invoice.getListImportPart().length == 0
                || !ensureConnection()) {
            return false;
        }

        if (invoice.getInvoiceCode() == null || invoice.getInvoiceCode().trim().isEmpty()) {
            String code = "IMP" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            invoice.setInvoiceCode(code);
        }
        if (invoice.getImportTime() == null) {
            invoice.setImportTime(new Timestamp(System.currentTimeMillis()));
        }
        if (invoice.getPaymentStatus() == null || invoice.getPaymentStatus().trim().isEmpty()) {
            invoice.setPaymentStatus("Đã thanh toán cho NCC");
        }
        invoice.recalculateTotalAmount();

        String sqlInvoice = "INSERT INTO tblImportInvoice7(invoiceCode, importTime, paymentStatus, note, tblSupplier7id, tblWarehouseStaff7id) "
                          + "VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO tblImportSparePart7(quantity, unitPrice, tblImportInvoice7id, tblSparePart7id) "
                         + "VALUES (?, ?, ?, ?)";

        boolean saved = false;
        try {
            con.setAutoCommit(false);

            try (PreparedStatement psInv = con.prepareStatement(sqlInvoice, Statement.RETURN_GENERATED_KEYS)) {
                psInv.setString(1, invoice.getInvoiceCode());
                psInv.setTimestamp(2, invoice.getImportTime());
                psInv.setString(3, invoice.getPaymentStatus());
                psInv.setString(4, invoice.getNote());
                psInv.setInt(5, invoice.getSupplier().getId());
                psInv.setInt(6, invoice.getWarehouseStaff().getId());

                if (psInv.executeUpdate() <= 0) {
                    throw new SQLException("Khong the luu hoa don nhap.");
                }
                try (ResultSet keys = psInv.getGeneratedKeys()) {
                    if (keys.next()) {
                        invoice.setId(keys.getInt(1));
                    } else {
                        throw new SQLException("Khong lay duoc id hoa don nhap vua tao.");
                    }
                }
            }

            try (PreparedStatement psDetail = con.prepareStatement(sqlDetail, Statement.RETURN_GENERATED_KEYS)) {
                for (ImportSparePart7 item : invoice.getListImportPart()) {
                    if (item == null || item.getSparePart() == null || item.getQuantity() <= 0) {
                        throw new SQLException("Chi tiet phu tung nhap khong hop le.");
                    }

                    psDetail.setInt(1, item.getQuantity());
                    psDetail.setFloat(2, item.getUnitPrice());
                    psDetail.setInt(3, invoice.getId());
                    psDetail.setInt(4, item.getSparePart().getId());
                    if (psDetail.executeUpdate() <= 0) {
                        throw new SQLException("Khong the luu chi tiet phu tung nhap.");
                    }
                    try (ResultSet detailKeys = psDetail.getGeneratedKeys()) {
                        if (detailKeys.next()) {
                            item.setId(detailKeys.getInt(1));
                        }
                    }

                    boolean updatedStock = SparePartDAO7.updateStockQuantity(
                            con, item.getSparePart().getId(), item.getQuantity());
                    if (!updatedStock) {
                        throw new SQLException("Cap nhat ton kho that bai cho phu tung id="
                                + item.getSparePart().getId());
                    }
                }
            }

            con.commit();
            // Cap nhat ton kho tren doi tuong bo nho chi sau khi commit thanh cong
            for (ImportSparePart7 item : invoice.getListImportPart()) {
                item.getSparePart().setStockQuantity(
                        item.getSparePart().getStockQuantity() + item.getQuantity());
            }
            saved = true;
        } catch (Exception e) {
            try {
                con.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            saved = false;
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException autoCommitEx) {
                autoCommitEx.printStackTrace();
            }
        }
        return saved;
    }
}
