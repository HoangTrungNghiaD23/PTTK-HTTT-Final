<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.net.URLEncoder,dao.*,model.*" %>
<%@ include file="../WEB-INF/jspf/helpers.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    String submitted = request.getParameter("search");

    boolean hasSearched = (submitted != null) || (keyword != null);
    String cleanKeyword = (keyword != null) ? keyword.trim() : "";

    Service7[] listService = new Service7[0];
    SparePart7[] listSparePart = new SparePart7[0];
    String warningMsg = null;

    if (hasSearched) {
        if (cleanKeyword.isEmpty()) {
            warningMsg = "Vui lòng nhập từ khóa tên dịch vụ hoặc phụ tùng để tìm kiếm.";
        } else {
            ServiceDAO7 serviceDAO = new ServiceDAO7();
            SparePartDAO7 partDAO = new SparePartDAO7();
            listService = serviceDAO.searchServiceByName(cleanKeyword);
            listSparePart = partDAO.searchSparePartByName(cleanKeyword);
            serviceDAO.close();
            partDAO.close();
        }
    }
    String encodedKeyword = URLEncoder.encode(cleanKeyword, "UTF-8");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm thông tin dịch vụ / phụ tùng</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container">
    <div class="header-bar">
        <div>
            <h2>TÌM KIẾM THÔNG TIN DỊCH VỤ / PHỤ TÙNG</h2>
            <div class="subtitle"> </div>
        </div>
        <a class="btn btn-secondary" href="gdCustomerHome7.jsp">Quay lại</a>
    </div>

    <form action="gdSearchService7.jsp" method="get" class="form-inline">
        <input type="hidden" name="search" value="1">
        <label for="keyword"><strong>Từ khóa:</strong></label>
        <input type="text" id="keyword" name="keyword" value="<%= esc(cleanKeyword) %>"
               placeholder="Nhập tên dịch vụ hoặc phụ tùng (vd: Brake, Oil, Filter)...">
        <input type="submit" value="Tìm kiếm">
    </form>

    <% if (warningMsg != null) { %>
        <div class="alert alert-warning"><%= esc(warningMsg) %></div>
    <% } else if (hasSearched && !cleanKeyword.isEmpty()) { %>
        <%
            int totalFound = (listService != null ? listService.length : 0)
                           + (listSparePart != null ? listSparePart.length : 0);
            if (totalFound == 0) {
        %>
            <div class="alert alert-warning">Không tìm thấy dịch vụ hoặc phụ tùng nào phù hợp với từ khóa đã nhập ("<%= esc(cleanKeyword) %>").</div>
        <% } else { %>
            <h3>Danh sách kết quả tìm kiếm (<%= totalFound %> mục)</h3>
            <table class="data-table">
                <thead>
                    <tr>
                        <th class="text-center" style="width: 55px;">TT</th>
                        <th style="width: 95px;">Mã</th>
                        <th>Tên dịch vụ / phụ tùng</th>
                        <th style="width: 110px;">Loại</th>
                        <th class="text-right" style="width: 150px;">Đơn giá niêm yết (VNĐ)</th>
                        <th style="width: 140px;">Trạng thái</th>
                        <th class="text-center" style="width: 130px;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int stt = 1;
                        if (listService != null) {
                            for (Service7 sv : listService) {
                    %>
                    <tr>
                        <td class="text-center"><%= stt++ %></td>
                        <td><%= esc(sv.getServiceCode()) %></td>
                        <td><%= esc(sv.getName()) %></td>
                        <td>Dịch vụ</td>
                        <td class="text-right"><%= fmtMoney(sv.getUnitPrice()) %></td>
                        <td>Đang cung cấp</td>
                        <td class="text-center">
                            <a href="gdServiceDetail7.jsp?id=<%= sv.getId() %>&amp;keyword=<%= encodedKeyword %>">Xem chi tiết</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                        if (listSparePart != null) {
                            for (SparePart7 sp : listSparePart) {
                                String statusText = sp.getStockQuantity() > 0
                                        ? "Còn hàng (" + sp.getStockQuantity() + ")"
                                        : "Tạm hết hàng";
                    %>
                    <tr>
                        <td class="text-center"><%= stt++ %></td>
                        <td><%= esc(sp.getPartCode()) %></td>
                        <td><%= esc(sp.getName()) %></td>
                        <td>Phụ tùng</td>
                        <td class="text-right"><%= fmtMoney(sp.getUnitPrice()) %></td>
                        <td><%= esc(statusText) %></td>
                        <td class="text-center">
                            <a href="gdSparePartDetail7.jsp?id=<%= sp.getId() %>&amp;keyword=<%= encodedKeyword %>">Xem chi tiết</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        <% } %>
    <% } else { %>
        <div class="alert alert-info">Nhập tên dịch vụ hoặc phụ tùng cần tra cứu vào ô phía trên và nhấn <strong>Tìm kiếm</strong>.</div>
    <% } %>

    <div class="actions-row">
        <a class="btn btn-secondary" href="gdCustomerHome7.jsp">Quay lại</a>
    </div>
</div>
</body>
</html>
