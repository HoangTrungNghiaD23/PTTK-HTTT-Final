<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    WarehouseStaff7 wh = (WarehouseStaff7) session.getAttribute("warehouseStaff");
    if (wh == null) {
        response.sendRedirect("../staff/gdLogin7.jsp?err=timeout");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ Nhân viên kho</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container">
    <div class="header-bar">
        <div>
            <h2>TRANG CHỦ NHÂN VIÊN KHO</h2>
            <div class="subtitle">
                Xin chào: <strong><%= esc(wh.getFullName()) %></strong>
                (Mã NV: <code><%= esc(wh.getStaffCode()) %></code> - <%= esc(wh.getPosition()) %>)
            </div>
        </div>
        <a class="btn btn-secondary" href="../staff/doLogout7.jsp">Đăng xuất</a>
    </div>

    <div class="card-grid">
        <div class="card">
            <h3>Nhập phụ tùng từ nhà cung cấp</h3>
            <p class="subtitle">
                Tìm/chọn hoặc thêm mới nhà cung cấp, chọn danh sách phụ tùng nhập, nhập số lượng &amp; đơn giá nhập,
                xác nhận cập nhật tồn kho và in hóa đơn thanh toán cho nhà cung cấp.
            </p>
            <a class="btn" href="gdImportSparePart7.jsp?reset=1">Nhập phụ tùng từ NCC</a>
        </div>

        <div class="card">
            <h3>Quản lý thông tin nhà cung cấp</h3>
            <p class="subtitle">
                Xem danh sách, cập nhật hoặc xóa hồ sơ nhà cung cấp phụ tùng của gara.
            </p>
            <span class="badge">Ngoài phạm vi 2 module cài đặt</span>
        </div>
    </div>
</div>
</body>
</html>
