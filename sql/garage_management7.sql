-- =============================================================================
-- He thong Quan ly Gara O to (Garage Management System - Subject No. 26)
-- Ma SV: B23DCDT177 (Chu so cuoi: 7)
-- Database: garage_management7 (13 bang tbl...7 theo 04_database_schema.puml)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS garage_management7
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE garage_management7;

-- Xoa bang cu neu ton tai (theo thu tu phu thuoc khoa ngoai)
DROP TABLE IF EXISTS tblImportSparePart7;
DROP TABLE IF EXISTS tblImportInvoice7;
DROP TABLE IF EXISTS tblServiceAssignment7;
DROP TABLE IF EXISTS tblUsedSparePart7;
DROP TABLE IF EXISTS tblUsedService7;
DROP TABLE IF EXISTS tblServiceOrder7;
DROP TABLE IF EXISTS tblAppointment7;
DROP TABLE IF EXISTS tblTechnicalStaff7;
DROP TABLE IF EXISTS tblSparePart7;
DROP TABLE IF EXISTS tblService7;
DROP TABLE IF EXISTS tblSupplier7;
DROP TABLE IF EXISTS tblCustomer7;
DROP TABLE IF EXISTS tblStaff7;

-- 1. Bang Nhan vien (tblStaff7)
CREATE TABLE tblStaff7 (
    id          INT          NOT NULL AUTO_INCREMENT,
    staffCode   VARCHAR(50)  NOT NULL,
    username    VARCHAR(50)  NOT NULL,
    password    VARCHAR(255) NOT NULL,
    fullName    VARCHAR(255) NOT NULL,
    dateOfBirth DATE         NULL,
    address     VARCHAR(255) NULL,
    phone       VARCHAR(20)  NOT NULL,
    email       VARCHAR(100) NULL,
    position    VARCHAR(100) NOT NULL,
    role        VARCHAR(50)  NOT NULL COMMENT 'MANAGEMENT, WAREHOUSE, SALE, TECHNICAL',
    note        VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_staff_code (staffCode),
    UNIQUE KEY uq_staff_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bang Nhan vien ky thuat (tblTechnicalStaff7) - quan he 1-1 voi tblStaff7
CREATE TABLE tblTechnicalStaff7 (
    tblStaff7id        INT          NOT NULL,
    specialty          VARCHAR(255) NOT NULL,
    availabilityStatus VARCHAR(50)  NOT NULL,
    PRIMARY KEY (tblStaff7id),
    CONSTRAINT fk_tech_staff7 FOREIGN KEY (tblStaff7id) REFERENCES tblStaff7(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bang Khach hang (tblCustomer7)
CREATE TABLE tblCustomer7 (
    id           INT          NOT NULL AUTO_INCREMENT,
    customerCode VARCHAR(50)  NOT NULL,
    fullName     VARCHAR(255) NOT NULL,
    phone        VARCHAR(20)  NOT NULL,
    address      VARCHAR(255) NULL,
    email        VARCHAR(100) NULL,
    note         VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_customer_code (customerCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bang Nha cung cap (tblSupplier7)
CREATE TABLE tblSupplier7 (
    id            INT          NOT NULL AUTO_INCREMENT,
    supplierCode  VARCHAR(50)  NOT NULL,
    name          VARCHAR(255) NOT NULL,
    address       VARCHAR(255) NOT NULL,
    phone         VARCHAR(20)  NOT NULL,
    email         VARCHAR(100) NULL,
    contactPerson VARCHAR(255) NULL,
    note          VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_supplier_code (supplierCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bang Dich vu (tblService7)
CREATE TABLE tblService7 (
    id                INT          NOT NULL AUTO_INCREMENT,
    serviceCode       VARCHAR(50)  NOT NULL,
    name              VARCHAR(255) NOT NULL,
    unitPrice         FLOAT        NOT NULL,
    estimatedDuration INT          NOT NULL COMMENT 'Thoi gian du kien (phut)',
    description       VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_service_code (serviceCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bang Phu tung (tblSparePart7)
CREATE TABLE tblSparePart7 (
    id            INT          NOT NULL AUTO_INCREMENT,
    partCode      VARCHAR(50)  NOT NULL,
    name          VARCHAR(255) NOT NULL,
    manufacturer  VARCHAR(255) NOT NULL,
    unit          VARCHAR(50)  NOT NULL,
    unitPrice     FLOAT        NOT NULL,
    stockQuantity INT          NOT NULL DEFAULT 0,
    description   VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_part_code (partCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Bang Lich hen truc tuyen (tblAppointment7)
CREATE TABLE tblAppointment7 (
    id              INT          NOT NULL AUTO_INCREMENT,
    appointmentCode VARCHAR(50)  NOT NULL,
    appointmentDate DATE         NOT NULL,
    appointmentTime VARCHAR(20)  NOT NULL,
    vehicleName     VARCHAR(255) NOT NULL,
    licensePlate    VARCHAR(50)  NOT NULL,
    requestNote     VARCHAR(255) NULL,
    status          VARCHAR(50)  NOT NULL,
    tblCustomer7id  INT          NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_appointment_code (appointmentCode),
    CONSTRAINT fk_appt_customer7 FOREIGN KEY (tblCustomer7id) REFERENCES tblCustomer7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Bang Phieu dich vu / Hoa don khach hang (tblServiceOrder7)
CREATE TABLE tblServiceOrder7 (
    id             INT          NOT NULL AUTO_INCREMENT,
    orderCode      VARCHAR(50)  NOT NULL,
    orderTime      DATETIME     NOT NULL,
    vehicleName    VARCHAR(255) NOT NULL,
    licensePlate   VARCHAR(50)  NOT NULL,
    paymentStatus  VARCHAR(50)  NOT NULL,
    paymentTime    DATETIME     NULL,
    note           VARCHAR(255) NULL,
    tblCustomer7id INT          NOT NULL,
    tblSaleStaff7id INT         NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_order_code (orderCode),
    CONSTRAINT fk_order_customer7 FOREIGN KEY (tblCustomer7id) REFERENCES tblCustomer7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_order_salestaff7 FOREIGN KEY (tblSaleStaff7id) REFERENCES tblStaff7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Bang Chi tiet dich vu su dung (tblUsedService7)
CREATE TABLE tblUsedService7 (
    id                 INT         NOT NULL AUTO_INCREMENT,
    unitPrice          FLOAT       NOT NULL,
    quantity           INT         NOT NULL,
    executionStatus    VARCHAR(50) NOT NULL,
    tblServiceOrder7id INT         NOT NULL,
    tblService7id      INT         NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_usedsvc_order7 FOREIGN KEY (tblServiceOrder7id) REFERENCES tblServiceOrder7(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usedsvc_service7 FOREIGN KEY (tblService7id) REFERENCES tblService7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. Bang Chi tiet phu tung su dung (tblUsedSparePart7)
CREATE TABLE tblUsedSparePart7 (
    id                 INT   NOT NULL AUTO_INCREMENT,
    quantity           INT   NOT NULL,
    unitPrice          FLOAT NOT NULL,
    tblServiceOrder7id INT   NOT NULL,
    tblSparePart7id    INT   NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_usedpart_order7 FOREIGN KEY (tblServiceOrder7id) REFERENCES tblServiceOrder7(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_usedpart_part7 FOREIGN KEY (tblSparePart7id) REFERENCES tblSparePart7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. Bang Phan cong nhan vien ky thuat (tblServiceAssignment7)
CREATE TABLE tblServiceAssignment7 (
    id                   INT          NOT NULL AUTO_INCREMENT,
    assignedTime         DATETIME     NOT NULL,
    status               VARCHAR(50)  NOT NULL,
    note                 VARCHAR(255) NULL,
    tblUsedService7id    INT          NOT NULL,
    tblTechnicalStaff7id INT          NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_assign_usedsvc7 FOREIGN KEY (tblUsedService7id) REFERENCES tblUsedService7(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_assign_tech7 FOREIGN KEY (tblTechnicalStaff7id) REFERENCES tblTechnicalStaff7(tblStaff7id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. Bang Hoa don nhap phu tung (tblImportInvoice7)
CREATE TABLE tblImportInvoice7 (
    id                   INT          NOT NULL AUTO_INCREMENT,
    invoiceCode          VARCHAR(50)  NOT NULL,
    importTime           DATETIME     NOT NULL,
    paymentStatus        VARCHAR(50)  NOT NULL,
    note                 VARCHAR(255) NULL,
    tblSupplier7id       INT          NOT NULL,
    tblWarehouseStaff7id INT          NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_invoice_code (invoiceCode),
    CONSTRAINT fk_imp_supplier7 FOREIGN KEY (tblSupplier7id) REFERENCES tblSupplier7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_imp_staff7 FOREIGN KEY (tblWarehouseStaff7id) REFERENCES tblStaff7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. Bang Chi tiet phu tung nhap (tblImportSparePart7)
CREATE TABLE tblImportSparePart7 (
    id                  INT   NOT NULL AUTO_INCREMENT,
    quantity            INT   NOT NULL,
    unitPrice           FLOAT NOT NULL,
    tblImportInvoice7id INT   NOT NULL,
    tblSparePart7id     INT   NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_imppart_invoice7 FOREIGN KEY (tblImportInvoice7id) REFERENCES tblImportInvoice7(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_imppart_part7 FOREIGN KEY (tblSparePart7id) REFERENCES tblSparePart7(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- DU LIEU MAU (SAMPLE DATA) - KHOP VOI KICH BAN MINH HOA TRONG BAO CAO
-- =============================================================================

-- Nhan vien (4 vai tro: WAREHOUSE, MANAGEMENT, SALE, TECHNICAL)
INSERT INTO tblStaff7 (staffCode, username, password, fullName, dateOfBirth, address, phone, email, position, role, note) VALUES
('WH01', 'cuonglv', '123456', 'Lê Văn Cường', '1994-05-12', 'Thanh Xuân, Hà Nội', '0912345678', 'cuonglv@garage7.vn', 'Nhân viên kho', 'WAREHOUSE', 'Phụ trách nhập xuất kho phụ tùng'),
('MG01', 'anhnt',   '123456', 'Nguyễn Tuấn Anh', '1988-09-20', 'Cầu Giấy, Hà Nội', '0987654321', 'anhnt@garage7.vn', 'Quản lý Gara', 'MANAGEMENT', 'Quản lý chung và xem thống kê'),
('SL01', 'hoapt',   '123456', 'Phạm Thị Hoa', '1996-03-08', 'Đống Đa, Hà Nội', '0934567890', 'hoapt@garage7.vn', 'Nhân viên bán hàng', 'SALE', 'Tiếp nhận khách hàng và thanh toán'),
('TC01', 'minhdq',  '123456', 'Đỗ Quang Minh', '1992-11-18', 'Hoàng Mai, Hà Nội', '0978112233', 'minhdq@garage7.vn', 'Kỹ thuật viên trưởng', 'TECHNICAL', 'Chuyên hệ thống phanh và động cơ');

INSERT INTO tblTechnicalStaff7 (tblStaff7id, specialty, availabilityStatus) VALUES
(4, 'Hệ thống phanh, gầm và động cơ', 'AVAILABLE');

-- Khach hang
INSERT INTO tblCustomer7 (customerCode, fullName, phone, address, email, note) VALUES
('CUS01', 'Trần Quốc Bảo', '0904111222', '15 Trần Duy Hưng, Hà Nội', 'baotq@gmail.com', 'Khách hàng thân thiết'),
('CUS02', 'Nguyễn Minh Hằng', '0915222333', '88 Láng Hạ, Hà Nội', 'hangnm@gmail.com', 'Bảo dưỡng định kỳ 6 tháng'),
('CUS03', 'Lê Hoàng Nam', '0988333444', '210 Nguyễn Trãi, Hà Nội', 'namlh@gmail.com', NULL);

-- Nha cung cap
INSERT INTO tblSupplier7 (supplierCode, name, address, phone, email, contactPerson, note) VALUES
('SUP01', 'AutoParts Vietnam Co., Ltd', '120 Giải Phóng, Hà Nội', '0901234567', 'sales@autopartsvn.com', 'Nguyễn Văn An', 'Nhà cung cấp chính thức lọc dầu, má phanh'),
('SUP02', 'Bosch Authorized Distributor VN', '25 Phạm Hùng, Nam Từ Liêm, Hà Nội', '0912888999', 'contact@boschparts.vn', 'Phạm Đức Mạnh', 'Phụ tùng Bosch chính hãng'),
('SUP03', 'Denso Parts Hanoi', '78 Minh Khai, Hai Bà Trưng, Hà Nội', '0966555444', 'info@densohn.vn', 'Vũ Thu Trang', 'Chuyên bugi, lọc gió Denso'),
('SUP04', 'Saigon AutoParts Supply', '45 Điện Biên Phủ, TP.HCM', '0907654321', 'order@sgautoparts.vn', 'Trần Minh Bình', 'Cung ứng phụ tùng gầm, phanh');

-- Dich vu
INSERT INTO tblService7 (serviceCode, name, unitPrice, estimatedDuration, description) VALUES
('SV001', 'Engine Oil Change', 250000, 30, 'Thay nhớt động cơ tổng hợp, kiểm tra rò rỉ và vệ sinh cốc lọc.'),
('SV002', 'Air Filter & AC Cleaning', 350000, 40, 'Vệ sinh hệ thống điều hòa, kiểm tra và làm sạch lọc gió động cơ.'),
('SV003', 'Brake System Inspection', 300000, 45, 'Kiểm tra tổng thể đĩa phanh, má phanh, đường ống dẫn dầu và mức dầu phanh.'),
('SV004', 'Brake Fluid Replacement', 450000, 60, 'Xả gió và thay mới toàn bộ dầu phanh chuẩn DOT4 cho hệ thống phanh.'),
('SV005', 'Wheel Alignment & Balancing', 500000, 60, 'Cân chỉnh thước lái, độ chụm bánh xe và cân bằng động 4 bánh.'),
('SV006', 'Battery & Electrical Check', 200000, 25, 'Kiểm tra điện áp ắc quy, máy phát điện và hệ thống đèn tín hiệu.');

-- Phu tung
INSERT INTO tblSparePart7 (partCode, name, manufacturer, unit, unitPrice, stockQuantity, description) VALUES
('SP001', 'Engine Oil Filter Bosch', 'Bosch', 'Cái', 180000, 12, 'Lọc nhớt động cơ Bosch chính hãng, dùng cho xe sedan và hatchback.'),
('SP002', 'Iridium Spark Plug NGK', 'NGK', 'Cái', 220000, 30, 'Bugi Iridium hiệu suất cao, đánh lửa ổn định và tiết kiệm nhiên liệu.'),
('SP005', 'Air Filter Toyota', 'Denso', 'Cái', 250000, 8, 'Lọc gió động cơ Denso tiêu chuẩn OEM cho dòng xe Toyota.'),
('SP008', 'Synthetic Engine Oil 5W-30', 'Castrol', 'Bình 4L', 890000, 18, 'Dầu nhớt tổng hợp toàn phần Castrol EDGE 5W-30 bảo vệ động cơ tối ưu.'),
('SP012', 'Front Brake Pad Set', 'Brembo', 'Bộ', 1250000, 24, 'Má phanh trước hiệu năng cao, tương thích các dòng xe sedan và SUV phổ thông.'),
('SP015', 'Rear Brake Disc', 'Brembo', 'Cái', 1850000, 10, 'Đĩa phanh sau tản nhiệt Brembo chịu nhiệt cao, chống cong vênh.');

-- Lich hen truc tuyen
INSERT INTO tblAppointment7 (appointmentCode, appointmentDate, appointmentTime, vehicleName, licensePlate, requestNote, status, tblCustomer7id) VALUES
('APT20261115-01', '2026-11-16', '09:00', 'Toyota Camry 2.5Q', '30G-123.45', 'Kiểm tra phanh trước và thay dầu định kỳ', 'CONFIRMED', 1),
('APT20261115-02', '2026-11-17', '14:30', 'Honda CR-V', '30H-678.90', 'Vệ sinh điều hòa và cân bằng lốp', 'PENDING', 2);

-- Phieu dich vu & chi tiet
INSERT INTO tblServiceOrder7 (orderCode, orderTime, vehicleName, licensePlate, paymentStatus, paymentTime, note, tblCustomer7id, tblSaleStaff7id) VALUES
('ORD20261110-01', '2026-11-10 09:30:00', 'Toyota Camry 2.5Q', '30G-123.45', 'PAID', '2026-11-10 11:15:00', 'Khách đã kiểm tra nghiệm thu', 1, 3);

INSERT INTO tblUsedService7 (unitPrice, quantity, executionStatus, tblServiceOrder7id, tblService7id) VALUES
(300000, 1, 'COMPLETED', 1, 3),
(250000, 1, 'COMPLETED', 1, 1);

INSERT INTO tblUsedSparePart7 (quantity, unitPrice, tblServiceOrder7id, tblSparePart7id) VALUES
(1, 1250000, 1, 5),
(1, 180000, 1, 1);

INSERT INTO tblServiceAssignment7 (assignedTime, status, note, tblUsedService7id, tblTechnicalStaff7id) VALUES
('2026-11-10 09:35:00', 'COMPLETED', 'Đã thay má phanh trước và kiểm tra dầu phanh', 1, 4),
('2026-11-10 09:35:00', 'COMPLETED', 'Đã thay dầu và lọc nhớt', 2, 4);

-- Hoa don nhap phu tung mau
INSERT INTO tblImportInvoice7 (invoiceCode, importTime, paymentStatus, note, tblSupplier7id, tblWarehouseStaff7id) VALUES
('IMP20261101-01', '2026-11-01 10:15:00', 'Đã thanh toán cho NCC', 'Nhập bổ sung hàng tồn kho đầu tháng', 1, 1);

INSERT INTO tblImportSparePart7 (quantity, unitPrice, tblImportInvoice7id, tblSparePart7id) VALUES
(10, 120000, 1, 1),
(10, 950000, 1, 5);
