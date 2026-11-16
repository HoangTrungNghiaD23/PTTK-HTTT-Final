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

    String errorMsg = null;
    String partCode = request.getParameter("partCode");
    String name = request.getParameter("name");
    String manufacturer = request.getParameter("manufacturer");
    String unit = request.getParameter("unit");
    String unitPriceStr = request.getParameter("unitPrice");
    String description = request.getParameter("description");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        partCode = (partCode != null) ? partCode.trim() : "";
        name = (name != null) ? name.trim() : "";
        manufacturer = (manufacturer != null) ? manufacturer.trim() : "";
        unit = (unit != null) ? unit.trim() : "";
        unitPriceStr = (unitPriceStr != null) ? unitPriceStr.trim() : "";
        description = (description != null) ? description.trim() : "";

        float unitPrice = -1f;
        try {
            unitPrice = Float.parseFloat(unitPriceStr);
        } catch (Exception ignored) {
        }

        if (partCode.isEmpty() || name.isEmpty() || manufacturer.isEmpty() || unit.isEmpty() || unitPrice < 0) {
            errorMsg = "Vui lòng nhập đầy đủ thông tin bắt buộc và đơn giá bán niêm yết (>= 0).";
        } else {
            SparePart7 part = new SparePart7();
            part.setPartCode(partCode);
            part.setName(name);
            part.setManufacturer(manufacturer);
            part.setUnit(unit);
            part.setUnitPrice(unitPrice);
            part.setStockQuantity(0);
            part.setDescription(description.isEmpty() ? null : description);

            SparePartDAO7 partDAO = new SparePartDAO7();
            boolean saved = partDAO.addSparePart(part);
            partDAO.close();

            if (saved) {
                session.setAttribute("newlyAddedPart", part);
                response.sendRedirect("gdEnterImportQtyPrice7.jsp?partId=" + part.getId());
                return;
            } else {
                errorMsg = "Không thể lưu phụ tùng mới (Mã phụ tùng có thể đã tồn tại hoặc lỗi kết nối CSDL).";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới phụ tùng</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>THÊM MỚI PHỤ TÙNG</h2>
        <a class="btn btn-secondary" href="gdImportSparePart7.jsp">Quay lại</a>
    </div>

    <% if (errorMsg != null) { %>
        <div class="alert alert-error"><%= esc(errorMsg) %></div>
    <% } %>

    <form action="gdAddSparePart7.jsp" method="post">
        <table class="form-table">
            <tr>
                <td class="label-col"><label for="partCode">Mã phụ tùng (*):</label></td>
                <td><input type="text" id="partCode" name="partCode" value="<%= esc(partCode) %>"
                           placeholder="Ví dụ: SP020" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="name">Tên phụ tùng (*):</label></td>
                <td><input type="text" id="name" name="name" value="<%= esc(name) %>" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="manufacturer">Hãng sản xuất (*):</label></td>
                <td><input type="text" id="manufacturer" name="manufacturer" value="<%= esc(manufacturer) %>" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="unit">Đơn vị tính (*):</label></td>
                <td><input type="text" id="unit" name="unit" value="<%= esc(unit) %>"
                           placeholder="Cái, Bộ, Bình..." required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="unitPrice">Đơn giá bán niêm yết (*):</label></td>
                <td><input type="number" id="unitPrice" name="unitPrice" min="0" step="1000"
                           value="<%= esc(unitPriceStr) %>" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="description">Mô tả chi tiết:</label></td>
                <td><textarea id="description" name="description" rows="2"><%= esc(description) %></textarea></td>
            </tr>
        </table>
        <div class="actions-row">
            <a class="btn btn-secondary" href="gdImportSparePart7.jsp">Quay lại</a>
            <input type="submit" class="btn-success" value="Lưu phụ tùng">
        </div>
    </form>
</div>
</body>
</html>
