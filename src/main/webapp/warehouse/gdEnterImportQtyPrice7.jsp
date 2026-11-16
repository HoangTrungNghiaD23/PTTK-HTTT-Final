<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*,model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    WarehouseStaff7 wh = (WarehouseStaff7) session.getAttribute("warehouseStaff");
    if (wh == null) {
        response.sendRedirect("../staff/gdLogin7.jsp?err=timeout");
        return;
    }

    ImportInvoice7 importInvoice = (ImportInvoice7) session.getAttribute("importInvoice");
    if (importInvoice == null || importInvoice.getSupplier() == null) {
        response.sendRedirect("gdImportSparePart7.jsp");
        return;
    }

    int partId = -1;
    try {
        partId = Integer.parseInt(request.getParameter("partId"));
    } catch (Exception ignored) {
    }

    SparePart7 sparePart = null;
    if (partId > 0) {
        SparePartDAO7 partDAO = new SparePartDAO7();
        sparePart = partDAO.getSparePartDetail(partId);
        partDAO.close();

        if (sparePart == null) {
            SparePart7 newly = (SparePart7) session.getAttribute("newlyAddedPart");
            if (newly != null && newly.getId() == partId) {
                sparePart = newly;
            }
        }
    }

    if (sparePart == null) {
        response.sendRedirect("gdImportSparePart7.jsp");
        return;
    }

    String errorMsg = null;
    String qtyStr = request.getParameter("quantity");
    String priceStr = request.getParameter("unitPrice");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int quantity = 0;
        float unitPrice = -1f;
        try {
            quantity = Integer.parseInt(qtyStr != null ? qtyStr.trim() : "0");
            unitPrice = Float.parseFloat(priceStr != null ? priceStr.trim() : "-1");
        } catch (Exception ignored) {
        }

        if (quantity <= 0 || unitPrice < 0) {
            errorMsg = "Dữ liệu không hợp lệ: Số lượng nhập phải > 0 và đơn giá nhập phải >= 0.";
        } else {
            ImportSparePart7 importItem = new ImportSparePart7(sparePart, quantity, unitPrice);
            importInvoice.addImportPart(importItem);
            session.setAttribute("importInvoice", importInvoice);
            session.removeAttribute("newlyAddedPart");
            response.sendRedirect("gdImportSparePart7.jsp?msg=part_added");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập số lượng và đơn giá nhập</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>NHẬP SỐ LƯỢNG &amp; ĐƠN GIÁ NHẬP</h2>
        <a class="btn btn-secondary" href="gdImportSparePart7.jsp">Quay lại</a>
    </div>

    <% if (errorMsg != null) { %>
        <div class="alert alert-error"><%= esc(errorMsg) %></div>
    <% } %>

    <div class="selected-banner" style="margin-bottom: 16px;">
        <div><strong>Mã phụ tùng:</strong> <code><%= esc(sparePart.getPartCode()) %></code></div>
        <div><strong>Tên phụ tùng:</strong> <%= esc(sparePart.getName()) %></div>
        <div><strong>Hãng SX / ĐVT:</strong> <%= esc(sparePart.getManufacturer()) %> / <%= esc(sparePart.getUnit()) %></div>
        <div><strong>Tồn kho hiện tại:</strong> <%= sparePart.getStockQuantity() %> |
            <strong>Giá bán niêm yết:</strong> <%= fmtMoney(sparePart.getUnitPrice()) %> VNĐ</div>
    </div>

    <form action="gdEnterImportQtyPrice7.jsp" method="post">
        <input type="hidden" name="partId" value="<%= sparePart.getId() %>">
        <table class="form-table">
            <tr>
                <td class="label-col"><label for="quantity">Số lượng nhập (*):</label></td>
                <td><input type="number" id="quantity" name="quantity" min="1" step="1"
                           value="<%= esc(qtyStr != null ? qtyStr : "1") %>" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="unitPrice">Đơn giá nhập (VNĐ) (*):</label></td>
                <td><input type="number" id="unitPrice" name="unitPrice" min="0" step="1000"
                           value="<%= esc(priceStr != null ? priceStr : String.valueOf((long) sparePart.getUnitPrice())) %>" required></td>
            </tr>
        </table>

        <div class="actions-row">
            <a class="btn btn-secondary" href="gdImportSparePart7.jsp">Quay lại</a>
            <input type="submit" class="btn-success" value="Thêm vào danh sách">
        </div>
    </form>
</div>
</body>
</html>
