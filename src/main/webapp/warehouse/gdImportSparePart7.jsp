<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*,model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    WarehouseStaff7 wh = (WarehouseStaff7) session.getAttribute("warehouseStaff");
    if (wh == null) {
        response.sendRedirect("../staff/gdLogin7.jsp?err=timeout");
        return;
    }

    if ("1".equals(request.getParameter("reset"))) {
        session.removeAttribute("importInvoice");
        session.removeAttribute("listSupplier");
        session.removeAttribute("listSparePart");
        session.removeAttribute("supplierKeyword");
        session.removeAttribute("partKeyword");
        session.removeAttribute("newlyAddedPart");
    }

    ImportInvoice7 importInvoice = (ImportInvoice7) session.getAttribute("importInvoice");
    if (importInvoice == null) {
        importInvoice = new ImportInvoice7();
        importInvoice.setWarehouseStaff(wh);
        session.setAttribute("importInvoice", importInvoice);
    } else if (importInvoice.getWarehouseStaff() == null) {
        importInvoice.setWarehouseStaff(wh);
    }

    String action = request.getParameter("action");
    String infoMessage = null;
    String errorMessage = null;

    if ("searchSupplier".equals(action)) {
        String supKw = request.getParameter("supplierKeyword");
        supKw = (supKw != null) ? supKw.trim() : "";
        session.setAttribute("supplierKeyword", supKw);
        if (supKw.isEmpty()) {
            errorMessage = "Vui lòng nhập từ khóa tên nhà cung cấp để tìm kiếm.";
            session.removeAttribute("listSupplier");
        } else {
            SupplierDAO7 supDAO = new SupplierDAO7();
            Supplier7[] foundSuppliers = supDAO.searchSupplierByName(supKw);
            supDAO.close();
            session.setAttribute("listSupplier", foundSuppliers);
        }
    } else if ("selectSupplier".equals(action)) {
        int supId = -1;
        try {
            supId = Integer.parseInt(request.getParameter("supplierId"));
        } catch (Exception ignored) {
        }
        Supplier7 selectedSup = null;
        Supplier7[] cachedSuppliers = (Supplier7[]) session.getAttribute("listSupplier");
        if (cachedSuppliers != null) {
            for (Supplier7 s : cachedSuppliers) {
                if (s.getId() == supId) {
                    selectedSup = s;
                    break;
                }
            }
        }
        if (selectedSup == null && supId > 0) {
            SupplierDAO7 supDAO = new SupplierDAO7();
            selectedSup = supDAO.getSupplierById(supId);
            supDAO.close();
        }
        if (selectedSup != null) {
            importInvoice.setSupplier(selectedSup);
            session.setAttribute("importInvoice", importInvoice);
            infoMessage = "Đã chọn nhà cung cấp: " + selectedSup.getName();
        } else {
            errorMessage = "Không tìm thấy nhà cung cấp đã chọn.";
        }
    } else if ("searchPart".equals(action)) {
        if (importInvoice.getSupplier() == null) {
            errorMessage = "Vui lòng chọn nhà cung cấp trước khi tìm kiếm phụ tùng.";
        } else {
            String partKw = request.getParameter("partKeyword");
            partKw = (partKw != null) ? partKw.trim() : "";
            session.setAttribute("partKeyword", partKw);
            if (partKw.isEmpty()) {
                errorMessage = "Vui lòng nhập từ khóa tên phụ tùng để tìm kiếm.";
                session.removeAttribute("listSparePart");
            } else {
                SparePartDAO7 partDAO = new SparePartDAO7();
                SparePart7[] foundParts = partDAO.searchSparePartByName(partKw);
                partDAO.close();
                session.setAttribute("listSparePart", foundParts);
            }
        }
    } else if ("removePart".equals(action)) {
        int partId = -1;
        try {
            partId = Integer.parseInt(request.getParameter("partId"));
        } catch (Exception ignored) {
        }
        if (partId > 0) {
            importInvoice.removeImportPart(partId);
            session.setAttribute("importInvoice", importInvoice);
            infoMessage = "Đã xóa phụ tùng khỏi danh sách nhập tạm thời.";
        }
    }

    String msg = request.getParameter("msg");
    if ("supplier_added".equals(msg)) {
        infoMessage = "Đã thêm mới và tự động chọn nhà cung cấp thành công.";
    } else if ("part_added".equals(msg)) {
        infoMessage = "Đã thêm phụ tùng vào danh sách nhập tạm thời.";
    }

    String err = request.getParameter("err");
    if ("save_fail".equals(err)) {
        errorMessage = "Lưu hóa đơn nhập kho thất bại. Vui lòng kiểm tra kết nối CSDL và thử lại.";
    } else if ("empty_list".equals(err)) {
        errorMessage = "Vui lòng chọn nhà cung cấp và thêm ít nhất một phụ tùng trước khi xác nhận.";
    }

    String supplierKeyword = (String) session.getAttribute("supplierKeyword");
    if (supplierKeyword == null) supplierKeyword = "";
    Supplier7[] listSupplier = (Supplier7[]) session.getAttribute("listSupplier");

    String partKeyword = (String) session.getAttribute("partKeyword");
    if (partKeyword == null) partKeyword = "";
    SparePart7[] listSparePart = (SparePart7[]) session.getAttribute("listSparePart");

    Supplier7 selectedSupplier = importInvoice.getSupplier();
    ImportSparePart7[] importItems = importInvoice.getListImportPart();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập phụ tùng từ nhà cung cấp</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container">
    <div class="header-bar">
        <div>
            <h2>NHẬP PHỤ TÙNG TỪ NHÀ CUNG CẤP</h2>
            <div class="subtitle">
                Nhân viên kho: <strong><%= esc(wh.getFullName()) %></strong> (<code><%= esc(wh.getStaffCode()) %></code>)
            </div>
        </div>
        <a class="btn btn-secondary" href="gdWarehouseHome7.jsp">Quay lại</a>
    </div>

    <% if (infoMessage != null) { %>
        <div class="alert alert-success"><%= esc(infoMessage) %></div>
    <% } %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= esc(errorMessage) %></div>
    <% } %>

    <!-- Buoc 1: Tim & Chon Nha cung cap -->
    <div class="section-box">
        <h3 style="margin-top: 0;">1. Nhà cung cấp</h3>
        <form action="gdImportSparePart7.jsp" method="get" class="form-inline">
            <input type="hidden" name="action" value="searchSupplier">
            <label for="supplierKeyword">Tên nhà cung cấp:</label>
            <input type="text" id="supplierKeyword" name="supplierKeyword"
                   value="<%= esc(supplierKeyword) %>" placeholder="Ví dụ: AutoParts, Bosch...">
            <input type="submit" value="Tìm NCC">
            <a class="btn btn-success" href="gdAddSupplier7.jsp">+ Thêm mới NCC</a>
        </form>

        <% if (listSupplier != null) { %>
            <% if (listSupplier.length == 0) { %>
                <div class="alert alert-warning">
                    Không tìm thấy nhà cung cấp nào chứa từ khóa "<%= esc(supplierKeyword) %>".
                    Bạn có thể nhấn <strong>+ Thêm mới NCC</strong> để tạo mới.
                </div>
            <% } else { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 50px;">TT</th>
                            <th style="width: 90px;">Mã NCC</th>
                            <th>Tên nhà cung cấp</th>
                            <th style="width: 115px;">Số điện thoại</th>
                            <th>Địa chỉ</th>
                            <th>Người liên hệ</th>
                            <th class="text-center" style="width: 90px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < listSupplier.length; i++) {
                               Supplier7 s = listSupplier[i]; %>
                        <tr>
                            <td class="text-center"><%= i + 1 %></td>
                            <td><%= esc(s.getSupplierCode()) %></td>
                            <td><%= esc(s.getName()) %></td>
                            <td><%= esc(s.getPhone()) %></td>
                            <td><%= esc(s.getAddress()) %></td>
                            <td><%= esc(s.getContactPerson()) %></td>
                            <td class="text-center">
                                <a href="gdImportSparePart7.jsp?action=selectSupplier&amp;supplierId=<%= s.getId() %>">Chọn</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        <% } %>

        <% if (selectedSupplier != null) { %>
            <div class="selected-banner">
                <strong>Nhà cung cấp đã chọn:</strong>
                <code><%= esc(selectedSupplier.getSupplierCode()) %></code> -
                <strong><%= esc(selectedSupplier.getName()) %></strong>
                (SĐT: <%= esc(selectedSupplier.getPhone()) %> | Đ/c: <%= esc(selectedSupplier.getAddress()) %>)
            </div>
        <% } else { %>
            <div class="alert alert-info" style="margin-top: 10px; margin-bottom: 0;">
                Chưa chọn nhà cung cấp. Vui lòng tìm và chọn nhà cung cấp trước khi tìm phụ tùng nhập.
            </div>
        <% } %>
    </div>

    <!-- Buoc 2: Tim & Chon Phu tung nhap -->
    <div class="section-box">
        <h3 style="margin-top: 0;">2. Phụ tùng nhập</h3>
        <% if (selectedSupplier == null) { %>
            <div class="alert alert-warning" style="margin-bottom: 0;">
                Vui lòng chọn nhà cung cấp
            </div>
        <% } else { %>
            <form action="gdImportSparePart7.jsp" method="get" class="form-inline">
                <input type="hidden" name="action" value="searchPart">
                <label for="partKeyword">Tên phụ tùng:</label>
                <input type="text" id="partKeyword" name="partKeyword"
                       value="<%= esc(partKeyword) %>" placeholder="Ví dụ: Filter, Brake...">
                <input type="submit" value="Tìm phụ tùng">
                <a class="btn btn-success" href="gdAddSparePart7.jsp">+ Thêm mới phụ tùng</a>
            </form>

            <% if (listSparePart != null) { %>
                <% if (listSparePart.length == 0) { %>
                    <div class="alert alert-warning">
                        Không tìm thấy phụ tùng nào chứa từ khóa "<%= esc(partKeyword) %>".
                        Bạn có thể nhấn <strong>+ Thêm mới phụ tùng</strong> để khai báo mới.
                    </div>
                <% } else { %>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th class="text-center" style="width: 50px;">TT</th>
                                <th style="width: 85px;">Mã PT</th>
                                <th>Tên phụ tùng</th>
                                <th style="width: 110px;">Hãng SX</th>
                                <th class="text-center" style="width: 75px;">ĐVT</th>
                                <th class="text-right" style="width: 130px;">Đơn giá bán (VNĐ)</th>
                                <th class="text-right" style="width: 95px;">Tồn kho</th>
                                <th class="text-center" style="width: 90px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < listSparePart.length; i++) {
                                   SparePart7 p = listSparePart[i]; %>
                            <tr>
                                <td class="text-center"><%= i + 1 %></td>
                                <td><%= esc(p.getPartCode()) %></td>
                                <td><%= esc(p.getName()) %></td>
                                <td><%= esc(p.getManufacturer()) %></td>
                                <td class="text-center"><%= esc(p.getUnit()) %></td>
                                <td class="text-right"><%= fmtMoney(p.getUnitPrice()) %></td>
                                <td class="text-right"><%= p.getStockQuantity() %></td>
                                <td class="text-center">
                                    <a href="gdEnterImportQtyPrice7.jsp?partId=<%= p.getId() %>">Chọn</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            <% } %>
        <% } %>
    </div>

    <!-- Buoc 3: Danh sach phu tung nhap tam thoi & Xac nhan -->
    <div class="section-box">
        <h3 style="margin-top: 0;">3. Danh sách phụ tùng nhập tạm thời</h3>
        <% if (importItems == null || importItems.length == 0) { %>
            <div class="alert alert-info">Chưa có phụ tùng nào trong danh sách nhập tạm thời.</div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th class="text-center" style="width: 50px;">TT</th>
                        <th style="width: 85px;">Mã PT</th>
                        <th>Tên phụ tùng</th>
                        <th class="text-center" style="width: 75px;">ĐVT</th>
                        <th class="text-right" style="width: 110px;">Số lượng nhập</th>
                        <th class="text-right" style="width: 135px;">Đơn giá nhập (VNĐ)</th>
                        <th class="text-right" style="width: 140px;">Thành tiền (VNĐ)</th>
                        <th class="text-center" style="width: 80px;">Xóa</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int totalQty = 0;
                        for (int i = 0; i < importItems.length; i++) {
                            ImportSparePart7 item = importItems[i];
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
                        <td class="text-center">
                            <a class="btn btn-danger"
                               href="gdImportSparePart7.jsp?action=removePart&amp;partId=<%= sp.getId() %>"
                               onclick="return confirm('Xóa phụ tùng này khỏi danh sách nhập?');">Xóa</a>
                        </td>
                    </tr>
                    <% } %>
                    <tr>
                        <td colspan="4" class="text-right"><strong>Tổng cộng</strong></td>
                        <td class="text-right"><strong><%= totalQty %></strong></td>
                        <td></td>
                        <td class="text-right"><strong><%= fmtMoney(importInvoice.getTotalAmount()) %> VNĐ</strong></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

            <form action="doConfirmImport7.jsp" method="post" style="margin-top: 16px;">
                <table class="form-table">
                    <tr>
                        <td class="label-col"><label for="paymentStatus">Trạng thái thanh toán:</label></td>
                        <td>
                            <select id="paymentStatus" name="paymentStatus">
                                <option value="Đã thanh toán cho NCC">Đã thanh toán cho NCC</option>
                                <option value="Đã xác nhận nhập / Chờ thanh toán NCC">Đã xác nhận nhập / Chờ thanh toán NCC</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="label-col"><label for="note">Ghi chú phiếu nhập:</label></td>
                        <td><input type="text" id="note" name="note" value="<%= esc(importInvoice.getNote()) %>"
                                   placeholder="Ghi chú thêm (nếu có)"></td>
                    </tr>
                </table>
                <div class="actions-row">
                    <a class="btn btn-secondary" href="gdWarehouseHome7.jsp">Quay lại</a>
                    <input type="submit" class="btn-success" value="Xác nhận nhập kho"
                           onclick="return confirm('Xác nhận lưu hóa đơn nhập phụ tùng và cập nhật tồn kho?');">
                </div>
            </form>
        <% } %>

        <% if (importItems == null || importItems.length == 0) { %>
            <div class="actions-row">
                <a class="btn btn-secondary" href="gdWarehouseHome7.jsp">Quay lại</a>
                <button type="button" class="btn btn-disabled" disabled>Xác nhận nhập kho</button>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
