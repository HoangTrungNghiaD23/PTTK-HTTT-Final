package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Thuc the Hoa don nhap phu tung (tuong ung bang tblImportInvoice7).
 * Tu dong cap nhat totalAmount khi danh sach listImportPart thay doi.
 */
public class ImportInvoice7 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String invoiceCode;
    private Timestamp importTime;
    private float totalAmount;
    private String paymentStatus;
    private String note;
    private Supplier7 supplier;
    private WarehouseStaff7 warehouseStaff;
    private ImportSparePart7[] listImportPart;

    public ImportInvoice7() {
        this.listImportPart = new ImportSparePart7[0];
        this.totalAmount = 0f;
    }

    public ImportInvoice7(int id, String invoiceCode, Timestamp importTime,
                          String paymentStatus, String note, Supplier7 supplier,
                          WarehouseStaff7 warehouseStaff, ImportSparePart7[] listImportPart) {
        this.id = id;
        this.invoiceCode = invoiceCode;
        this.importTime = importTime;
        this.paymentStatus = paymentStatus;
        this.note = note;
        this.supplier = supplier;
        this.warehouseStaff = warehouseStaff;
        this.listImportPart = (listImportPart != null) ? listImportPart : new ImportSparePart7[0];
        this.totalAmount = computeTotalAmount(this.listImportPart);
    }

    private static float computeTotalAmount(ImportSparePart7[] parts) {
        float sum = 0f;
        if (parts != null) {
            for (ImportSparePart7 item : parts) {
                if (item != null) {
                    sum += item.getSubTotal();
                }
            }
        }
        return sum;
    }

    /**
     * Tinh lai tong thanh tien hoa don tu danh sach chi tiet phu tung nhap.
     */
    public void recalculateTotalAmount() {
        this.totalAmount = computeTotalAmount(this.listImportPart);
    }

    /**
     * Them moi hoac cap nhat chi tiet phu tung nhap vao hoa don va tinh lai totalAmount.
     */
    public void addImportPart(ImportSparePart7 newItem) {
        if (newItem == null || newItem.getSparePart() == null) {
            return;
        }
        List<ImportSparePart7> items = new ArrayList<>();
        if (this.listImportPart != null) {
            items.addAll(Arrays.asList(this.listImportPart));
        }
        boolean updated = false;
        int targetPartId = newItem.getSparePart().getId();
        for (ImportSparePart7 existing : items) {
            if (existing.getSparePart() != null && existing.getSparePart().getId() == targetPartId) {
                existing.setQuantity(newItem.getQuantity());
                existing.setUnitPrice(newItem.getUnitPrice());
                updated = true;
                break;
            }
        }
        if (!updated) {
            items.add(newItem);
        }
        setListImportPart(items.toArray(new ImportSparePart7[0]));
    }

    /**
     * Xoa mot phu tung khoi danh sach nhap tam thoi theo id phu tung va cap nhat totalAmount.
     */
    public void removeImportPart(int sparePartId) {
        if (this.listImportPart == null || this.listImportPart.length == 0) {
            return;
        }
        List<ImportSparePart7> items = new ArrayList<>();
        for (ImportSparePart7 item : this.listImportPart) {
            if (item != null && (item.getSparePart() == null || item.getSparePart().getId() != sparePartId)) {
                items.add(item);
            }
        }
        setListImportPart(items.toArray(new ImportSparePart7[0]));
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public Timestamp getImportTime() {
        return importTime;
    }

    public void setImportTime(Timestamp importTime) {
        this.importTime = importTime;
    }

    public float getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(float totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Supplier7 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier7 supplier) {
        this.supplier = supplier;
    }

    public WarehouseStaff7 getWarehouseStaff() {
        return warehouseStaff;
    }

    public void setWarehouseStaff(WarehouseStaff7 warehouseStaff) {
        this.warehouseStaff = warehouseStaff;
    }

    public ImportSparePart7[] getListImportPart() {
        return listImportPart;
    }

    public void setListImportPart(ImportSparePart7[] listImportPart) {
        this.listImportPart = (listImportPart != null) ? listImportPart : new ImportSparePart7[0];
        recalculateTotalAmount();
    }
}
