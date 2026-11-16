<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>ĐĂNG NHẬP HỆ THỐNG</h2>
        <a class="btn btn-secondary" href="../index.jsp">Trang chủ</a>
    </div>

    <%
        String err = request.getParameter("err");
        if ("timeout".equalsIgnoreCase(err)) {
    %>
        <div class="alert alert-warning">Hết phiên làm việc. Vui lòng đăng nhập lại!</div>
    <%
        } else if ("fail".equalsIgnoreCase(err)) {
    %>
        <div class="alert alert-error">Sai tên đăng nhập hoặc mật khẩu!</div>
    <%
        } else if ("role".equalsIgnoreCase(err)) {
    %>
        <div class="alert alert-warning">Tài khoản không có quyền truy cập chức năng Nhân viên kho!</div>
    <%
        }
    %>

    <form name="dangnhap" action="doLogin7.jsp" method="post">
        <table class="form-table">
            <tr>
                <td class="label-col"><label for="username">Tên đăng nhập:</label></td>
                <td><input type="text" name="username" id="username" placeholder="Ví dụ: cuonglv" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="password">Mật khẩu:</label></td>
                <td><input type="password" name="password" id="password" placeholder="Nhập mật khẩu" required></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input type="submit" value="Đăng nhập">
                    <a class="btn btn-secondary" href="../index.jsp">Quay lại</a>
                </td>
            </tr>
        </table>
    </form>

    
    </div>
</div>
</body>
</html>
