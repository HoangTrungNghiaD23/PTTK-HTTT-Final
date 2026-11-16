<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*,model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    WarehouseStaff7 wh = (WarehouseStaff7) session.getAttribute("warehouseStaff");
    if (wh == null) {
        response.sendRedirect("../staff/gdLogin7.jsp?err=timeout");
        return;
    }

    String errorMsg = null;
    String supplierCode = request.getParameter("supplierCode");
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String contactPerson = request.getParameter("contactPerson");
    String note = request.getParameter("note");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        supplierCode = (supplierCode != null) ? supplierCode.trim() : "";
        name = (name != null) ? name.trim() : "";
        address = (address != null) ? address.trim() : "";
        phone = (phone != null) ? phone.trim() : "";
        email = (email != null) ? email.trim() : "";
        contactPerson = (contactPerson != null) ? contactPerson.trim() : "";
        note = (note != null) ? note.trim() : "";

        if (supplierCode.isEmpty() || name.isEmpty() || address.isEmpty() || phone.isEmpty()) {
            errorMsg = "Vui lòng nhập đầy đủ các trường bắt buộc (Mã NCC, Tên NCC, Địa chỉ, Số điện thoại).";
        } else {
            Supplier7 supplier = new Supplier7();
            supplier.setSupplierCode(supplierCode);
            supplier.setName(name);
            supplier.setAddress(address);
            supplier.setPhone(phone);
            supplier.setEmail(email.isEmpty() ? null : email);
            supplier.setContactPerson(contactPerson.isEmpty() ? null : contactPerson);
            supplier.setNote(note.isEmpty() ? null : note);

            SupplierDAO7 supDAO = new SupplierDAO7();
            boolean saved = supDAO.addSupplier(supplier);
            supDAO.close();

            if (saved) {
                ImportInvoice7 importInvoice = (ImportInvoice7) session.getAttribute("importInvoice");
                if (importInvoice == null) {
                    importInvoice = new ImportInvoice7();
                    importInvoice.setWarehouseStaff(wh);
                }
                importInvoice.setSupplier(supplier);
                session.setAttribute("importInvoice", importInvoice);
                response.sendRedirect("gdImportSparePart7.jsp?msg=supplier_added");
                return;
            } else {
                errorMsg = "Không thể lưu nhà cung cấp mới (Mã NCC có thể đã tồn tại hoặc lỗi kết nối CSDL).";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới nhà cung cấp</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container container-narrow">
    <div class="header-bar">
        <h2>THÊM MỚI NHÀ CUNG CẤP</h2>
        <a class="btn btn-secondary" href="gdImportSparePart7.jsp">Quay lại</a>
    </div>

    <% if (errorMsg != null) { %>
        <div class="alert alert-error"><%= esc(errorMsg) %></div>
    <% } %>

    <form action="gdAddSupplier7.jsp" method="post">
        <table class="form-table">
            <tr>
                <td class="label-col"><label for="supplierCode">Mã NCC (*):</label></td>
                <td><input type="text" id="supplierCode" name="supplierCode" value="<%= esc(supplierCode) %>"
                           placeholder="Ví dụ: SUP05" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="name">Tên nhà cung cấp (*):</label></td>
                <td><input type="text" id="name" name="name" value="<%= esc(name) %>"
                           placeholder="Tên công ty / đại lý" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="address">Địa chỉ (*):</label></td>
                <td><input type="text" id="address" name="address" value="<%= esc(address) %>" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="phone">Số điện thoại (*):</label></td>
                <td><input type="text" id="phone" name="phone" value="<%= esc(phone) %>" required></td>
            </tr>
            <tr>
                <td class="label-col"><label for="email">Email:</label></td>
                <td><input type="email" id="email" name="email" value="<%= esc(email) %>"></td>
            </tr>
            <tr>
                <td class="label-col"><label for="contactPerson">Người liên hệ:</label></td>
                <td><input type="text" id="contactPerson" name="contactPerson" value="<%= esc(contactPerson) %>"></td>
            </tr>
            <tr>
                <td class="label-col"><label for="note">Ghi chú:</label></td>
                <td><textarea id="note" name="note" rows="2"><%= esc(note) %></textarea></td>
            </tr>
        </table>
        <div class="actions-row">
            <a class="btn btn-secondary" href="gdImportSparePart7.jsp">Quay lại</a>
            <input type="submit" class="btn-success" value="Lưu nhà cung cấp">
        </div>
    </form>
</div>
</body>
</html>
