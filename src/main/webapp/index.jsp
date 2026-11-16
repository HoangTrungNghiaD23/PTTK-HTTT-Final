<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hệ thống Quản lý Gara Ô tô</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
    <div class="header-bar">
        <div>
            <h2>HỆ THỐNG QUẢN LÝ GARA Ô TÔ</h2>
            <div class="subtitle">Garage Management System</div>
        </div>
        <span class="badge"></span>
    </div>

    <div class="card-grid">
        <div class="card">
            <h3>Dành cho Khách hàng</h3>
            <p class="subtitle">Tra cứu thông tin dịch vụ bảo dưỡng, sửa chữa và phụ tùng ô tô của gara không cần đăng nhập.</p>
            <a class="btn" href="customer/gdCustomerHome7.jsp">Trang chủ Khách hàng</a>
        </div>

        <div class="card">
            <h3>Dành cho Nhân viên Gara</h3>
            <p class="subtitle">Đăng nhập tài khoản nội bộ để thực hiện nghiệp vụ Nhập phụ tùng từ nhà cung cấp (Nhân viên kho).</p>
            <a class="btn btn-success" href="staff/gdLogin7.jsp">Đăng nhập Nhân viên</a>
        </div>
    </div>
</div>
</body>
</html>
