<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*,model.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    WarehouseStaff7 wh = (WarehouseStaff7) session.getAttribute("warehouseStaff");
    if (wh == null) {
        response.sendRedirect("../staff/gdLogin7.jsp?err=timeout");
        return;
    }

    ImportInvoice7 importInvoice = (ImportInvoice7) session.getAttribute("importInvoice");
    if (importInvoice == null
            || importInvoice.getSupplier() == null
            || importInvoice.getListImportPart() == null
            || importInvoice.getListImportPart().length == 0) {
        response.sendRedirect("gdImportSparePart7.jsp?err=empty_list");
        return;
    }

    String paymentStatus = request.getParameter("paymentStatus");
    if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
        importInvoice.setPaymentStatus(paymentStatus.trim());
    }
    String note = request.getParameter("note");
    if (note != null) {
        importInvoice.setNote(note.trim());
    }
    importInvoice.setWarehouseStaff(wh);

    ImportInvoiceDAO7 invoiceDAO = new ImportInvoiceDAO7();
    boolean saved = invoiceDAO.saveImportInvoice(importInvoice);
    invoiceDAO.close();

    if (saved) {
        session.setAttribute("printedInvoice", importInvoice);
        session.removeAttribute("importInvoice");
        session.removeAttribute("listSupplier");
        session.removeAttribute("listSparePart");
        session.removeAttribute("supplierKeyword");
        session.removeAttribute("partKeyword");
        session.removeAttribute("newlyAddedPart");
        response.sendRedirect("gdImportInvoicePrint7.jsp");
    } else {
        response.sendRedirect("gdImportSparePart7.jsp?err=save_fail");
    }
%>
