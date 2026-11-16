<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.net.URLEncoder,dao.*,model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String idParam = request.getParameter("id");
    String keyword = request.getParameter("keyword");
    String backUrl = "gdSearchService7.jsp";
    if (keyword != null && !keyword.trim().isEmpty()) {
        backUrl += "?search=1&keyword=" + URLEncoder.encode(keyword.trim(), "UTF-8");
    }

    int idService = -1;
    try {
        idService = Integer.parseInt(idParam);
    } catch (Exception ignored) {
    }

    Service7 service = null;
    if (idService > 0) {
        ServiceDAO7 serviceDAO = new ServiceDAO7();
        service = serviceDAO.getServiceDetail(idService);
        serviceDAO.close();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết dịch vụ</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>CHI TIẾT DỊCH VỤ</h2>
    </div>

    <% if (service == null) { %>
        <div class="alert alert-error">Không tìm thấy thông tin dịch vụ được chọn.</div>
    <% } else { %>
        <table class="data-table">
            <tr>
                <th style="width: 210px;">Thuộc tính</th>
                <th>Thông tin chi tiết</th>
            </tr>
            <tr>
                <td><strong>Mã dịch vụ</strong></td>
                <td><%= esc(service.getServiceCode()) %></td>
            </tr>
            <tr>
                <td><strong>Tên dịch vụ</strong></td>
                <td><%= esc(service.getName()) %></td>
            </tr>
            <tr>
                <td><strong>Đơn giá dịch vụ</strong></td>
                <td><%= fmtMoney(service.getUnitPrice()) %> VNĐ</td>
            </tr>
            <tr>
                <td><strong>Thời gian thực hiện dự kiến</strong></td>
                <td><%= service.getEstimatedDuration() %> phút</td>
            </tr>
            <tr>
                <td><strong>Mô tả chi tiết</strong></td>
                <td><%= esc(service.getDescription()) %></td>
            </tr>
        </table>
    <% } %>

    <div class="actions-row">
        <a class="btn btn-secondary" href="<%= backUrl %>">Quay lại</a>
    </div>
</div>
</body>
</html>
