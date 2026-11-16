<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*,model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Staff7 staff = new Staff7();
    staff.setUsername(username);
    staff.setPassword(password);

    StaffDAO7 staffDAO = new StaffDAO7();
    boolean kq = staffDAO.checkLogin(staff);
    staffDAO.close();

    if (kq) {
        session.setAttribute("staff", staff);
        if ("WAREHOUSE".equalsIgnoreCase(staff.getRole())) {
            WarehouseStaff7 warehouseStaff = new WarehouseStaff7(staff);
            session.setAttribute("warehouseStaff", warehouseStaff);
            response.sendRedirect("../warehouse/gdWarehouseHome7.jsp");
            return;
        }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông tin đăng nhập</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>ĐĂNG NHẬP THÀNH CÔNG</h2>
    </div>
    <div class="alert alert-info">
        Xin chào <strong><%= esc(staff.getFullName()) %></strong> (<%= esc(staff.getStaffCode()) %> - Vai trò: <strong><%= esc(staff.getRole()) %></strong>).<br>
        Trong giai đoạn cài đặt này, hệ thống cài đặt trọng tâm Module 1 (Khách hàng tìm kiếm dịch vụ/phụ tùng) và Module 2 (Nhân viên kho nhập phụ tùng).
    </div>
    <a class="btn btn-secondary" href="doLogout7.jsp">Đăng xuất &amp; Đăng nhập tài khoản Kho</a>
    <a class="btn" href="../index.jsp">Về trang chủ</a>
</div>
</body>
</html>
<%
    } else {
        response.sendRedirect("gdLogin7.jsp?err=fail");
    }
%>
