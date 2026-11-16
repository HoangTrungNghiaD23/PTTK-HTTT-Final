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

    int idPart = -1;
    try {
        idPart = Integer.parseInt(idParam);
    } catch (Exception ignored) {
    }

    SparePart7 sparePart = null;
    if (idPart > 0) {
        SparePartDAO7 partDAO = new SparePartDAO7();
        sparePart = partDAO.getSparePartDetail(idPart);
        partDAO.close();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phụ tùng</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>CHI TIẾT PHỤ TÙNG</h2>
    </div>

    <% if (sparePart == null) { %>
        <div class="alert alert-error">Không tìm thấy thông tin phụ tùng được chọn.</div>
    <% } else { %>
        <table class="data-table">
            <tr>
                <th style="width: 210px;">Thuộc tính</th>
                <th>Thông tin chi tiết</th>
            </tr>
            <tr>
                <td><strong>Mã phụ tùng</strong></td>
                <td><%= esc(sparePart.getPartCode()) %></td>
            </tr>
            <tr>
                <td><strong>Tên phụ tùng</strong></td>
                <td><%= esc(sparePart.getName()) %></td>
            </tr>
            <tr>
                <td><strong>Hãng sản xuất</strong></td>
                <td><%= esc(sparePart.getManufacturer()) %></td>
            </tr>
            <tr>
                <td><strong>Đơn vị tính</strong></td>
                <td><%= esc(sparePart.getUnit()) %></td>
            </tr>
            <tr>
                <td><strong>Đơn giá bán niêm yết</strong></td>
                <td><%= fmtMoney(sparePart.getUnitPrice()) %> VNĐ</td>
            </tr>
            <tr>
                <td><strong>Số lượng tồn kho</strong></td>
                <td><%= sparePart.getStockQuantity() %></td>
            </tr>
            <tr>
                <td><strong>Mô tả chi tiết</strong></td>
                <td><%= esc(sparePart.getDescription()) %></td>
            </tr>
        </table>
    <% } %>

    <div class="actions-row">
        <a class="btn btn-secondary" href="<%= backUrl %>">Quay lại</a>
    </div>
</div>
</body>
</html>
