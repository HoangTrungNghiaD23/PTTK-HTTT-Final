<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    WarehouseStaff7 wh = (WarehouseStaff7) session.getAttribute("warehouseStaff");
    if (wh == null) {
        response.sendRedirect("../staff/gdLogin7.jsp?err=timeout");
        return;
    }

    ImportInvoice7 invoice = (ImportInvoice7) session.getAttribute("printedInvoice");
    if (invoice == null) {
        response.sendRedirect("gdWarehouseHome7.jsp");
        return;
    }

    Supplier7 supplier = invoice.getSupplier();
    WarehouseStaff7 staff = invoice.getWarehouseStaff();
    ImportSparePart7[] items = invoice.getListImportPart();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn nhập phụ tùng - <%= esc(invoice.getInvoiceCode()) %></title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container">
    <div class="header-bar">
        <div>
            <h2>HÓA ĐƠN NHẬP PHỤ TÙNG</h2>
            <div class="subtitle">Hệ thống Quản lý Gara Ô tô - GarageManagement7</div>
        </div>
        <span class="badge"><%= esc(invoice.getPaymentStatus()) %></span>
    </div>

    <div class="alert alert-success no-print">
        Đã lưu hóa đơn nhập phụ tùng <strong><%= esc(invoice.getInvoiceCode()) %></strong> và cập nhật tồn kho thành công!
    </div>

    <table class="data-table">
        <tr>
            <th colspan="2">Thông tin chung &amp; Nhà cung cấp</th>
        </tr>
        <tr>
            <td style="width: 230px;"><strong>Mã hóa đơn nhập</strong></td>
            <td><code><%= esc(invoice.getInvoiceCode()) %></code></td>
        </tr>
        <tr>
            <td><strong>Thời gian nhập</strong></td>
            <td><%= fmtTime(invoice.getImportTime()) %></td>
        </tr>
        <tr>
            <td><strong>Nhân viên kho thực hiện</strong></td>
            <td><%= staff != null ? esc(staff.getFullName()) + " (" + esc(staff.getStaffCode()) + ")" : "" %></td>
        </tr>
        <tr>
            <td><strong>Nhà cung cấp</strong></td>
            <td>
                <% if (supplier != null) { %>
                    <strong><%= esc(supplier.getName()) %></strong> (<code><%= esc(supplier.getSupplierCode()) %></code>)
                    - SĐT: <%= esc(supplier.getPhone()) %> - Đ/c: <%= esc(supplier.getAddress()) %>
                <% } %>
            </td>
        </tr>
        <tr>
            <td><strong>Trạng thái thanh toán</strong></td>
            <td><%= esc(invoice.getPaymentStatus()) %></td>
        </tr>
        <% if (invoice.getNote() != null && !invoice.getNote().isEmpty()) { %>
        <tr>
            <td><strong>Ghi chú</strong></td>
            <td><%= esc(invoice.getNote()) %></td>
        </tr>
        <% } %>
    </table>

    <h3>Chi tiết phụ tùng đã nhập kho</h3>
    <table class="data-table">
        <thead>
            <tr>
                <th class="text-center" style="width: 50px;">TT</th>
                <th style="width: 90px;">Mã PT</th>
                <th>Tên phụ tùng</th>
                <th class="text-center" style="width: 75px;">ĐVT</th>
                <th class="text-right" style="width: 95px;">Số lượng</th>
                <th class="text-right" style="width: 145px;">Đơn giá nhập (VNĐ)</th>
                <th class="text-right" style="width: 150px;">Thành tiền (VNĐ)</th>
            </tr>
        </thead>
        <tbody>
            <%
                int totalQty = 0;
                if (items != null) {
                    for (int i = 0; i < items.length; i++) {
                        ImportSparePart7 item = items[i];
                        SparePart7 sp = item.getSparePart();
                        totalQty += item.getQuantity();
            %>
            <tr>
                <td class="text-center"><%= i + 1 %></td>
                <td><%= esc(sp.getPartCode()) %></td>
                <td><%= esc(sp.getName()) %></td>
                <td class="text-center"><%= esc(sp.getUnit()) %></td>
                <td class="text-right"><%= item.getQuantity() %></td>
                <td class="text-right"><%= fmtMoney(item.getUnitPrice()) %></td>
                <td class="text-right"><%= fmtMoney(item.getSubTotal()) %></td>
            </tr>
            <%
                    }
                }
            %>
            <tr>
                <td colspan="4" class="text-right"><strong>Tổng tiền thanh toán cho NCC</strong></td>
                <td class="text-right"><strong><%= totalQty %></strong></td>
                <td></td>
                <td class="text-right"><strong><%= fmtMoney(invoice.getTotalAmount()) %> VNĐ</strong></td>
            </tr>
        </tbody>
    </table>

    <div class="signature-grid">
        <div>
            <strong>Nhân viên kho lập phiếu</strong><br>
            <span class="subtitle">(Ký và ghi rõ họ tên)</span><br><br><br>
            <strong><%= staff != null ? esc(staff.getFullName()) : "" %></strong>
        </div>
        <div>
            <strong>Đại diện Nhà cung cấp</strong><br>
            <span class="subtitle">(Ký xác nhận giao hàng &amp; nhận thanh toán)</span><br><br><br>
            <strong><%= supplier != null && supplier.getContactPerson() != null ? esc(supplier.getContactPerson()) : "" %></strong>
        </div>
    </div>

    <div class="actions-row no-print" style="margin-top: 28px;">
        <a class="btn btn-secondary" href="gdWarehouseHome7.jsp">Đóng</a>
        <button type="button" class="btn btn-success" onclick="window.print()">In hóa đơn</button>
    </div>
</div>
</body>
</html>
