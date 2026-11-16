package model;

import java.io.Serializable;

/**
 * Thuc the Phu tung o to (tuong ung bang tblSparePart7).
 */
public class SparePart7 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String partCode;
    private String name;
    private String manufacturer;
    private String unit;
    private float unitPrice;
    private int stockQuantity;
    private String description;

    public SparePart7() {
    }

    public SparePart7(int id, String partCode, String name, String manufacturer,
                      String unit, float unitPrice, int stockQuantity, String description) {
        this.id = id;
        this.partCode = partCode;
        this.name = name;
        this.manufacturer = manufacturer;
        this.unit = unit;
        this.unitPrice = unitPrice;
        this.stockQuantity = stockQuantity;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(float unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
