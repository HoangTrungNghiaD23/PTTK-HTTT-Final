package model;

import java.io.Serializable;

/**
 * Thuc the Dich vu sua chua / bao duong (tuong ung bang tblService7).
 */
public class Service7 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String serviceCode;
    private String name;
    private float unitPrice;
    private int estimatedDuration;
    private String description;

    public Service7() {
    }

    public Service7(int id, String serviceCode, String name,
                    float unitPrice, int estimatedDuration, String description) {
        this.id = id;
        this.serviceCode = serviceCode;
        this.name = name;
        this.unitPrice = unitPrice;
        this.estimatedDuration = estimatedDuration;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(float unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(int estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
