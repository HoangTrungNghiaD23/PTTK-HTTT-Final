package model;

import java.io.Serializable;

/**
 * Thuc the Chi tiet phu tung nhap (tuong ung bang tblImportSparePart7).
 * Tu dong tinh subTotal = quantity * unitPrice.
 */
public class ImportSparePart7 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int quantity;
    private float unitPrice;
    private float subTotal;
    private SparePart7 sparePart;

    public ImportSparePart7() {
    }

    public ImportSparePart7(SparePart7 sparePart, int quantity, float unitPrice) {
        this.sparePart = sparePart;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        updateSubTotal();
    }

    public ImportSparePart7(int id, int quantity, float unitPrice, SparePart7 sparePart) {
        this.id = id;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.sparePart = sparePart;
        updateSubTotal();
    }

    private void updateSubTotal() {
        this.subTotal = this.quantity * this.unitPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        updateSubTotal();
    }

    public float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(float unitPrice) {
        this.unitPrice = unitPrice;
        updateSubTotal();
    }

    public float getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(float subTotal) {
        this.subTotal = subTotal;
    }

    public SparePart7 getSparePart() {
        return sparePart;
    }

    public void setSparePart(SparePart7 sparePart) {
        this.sparePart = sparePart;
    }
}
