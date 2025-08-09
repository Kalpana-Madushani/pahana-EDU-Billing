<%@ page import="Dao.BillDAO" %>
<%@ page import="Dao.BillDAO.BillData" %>
<%@ page import="Dao.BillDAO.BillItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int billId = Integer.parseInt(request.getParameter("billId"));
    BillData data = BillDAO.getBillDataById(billId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bill #<%= data.billId %></title>
    <style>
        body{ font-family:Arial, sans-serif; padding:20px; }
        .invoice { max-width:700px; margin:0 auto; border:1px solid #eee; padding:20px;}
        table{ width:100%; border-collapse:collapse; }
        th,td{ padding:8px; border-bottom:1px solid #eee; text-align:left; }
        .total { text-align:right; font-weight:bold; font-size:18px;}
        .print-btn{ margin-top:12px; }
    </style>
</head>
<body>
<div class="invoice">
    <h2>Bill #<%= data.billId %></h2>
    <div>Date: <%= data.date %></div>
    <div>Customer: <%= data.customerName %> (<%= data.customerPhone %>)</div>
    <hr/>
    <table>
        <tr><th>Title</th><th>Qty</th><th>Price</th><th>Sub</th></tr>
        <% for (BillItem it : data.items) { %>
            <tr>
                <td><%= it.title %></td>
                <td><%= it.quantity %></td>
                <td>Rs. <%= it.price %></td>
                <td>Rs. <%= String.format("%.2f", it.price * it.quantity) %></td>
            </tr>
        <% } %>
    </table>
    <div class="total">Total: Rs. <%= String.format("%.2f", data.total) %></div>
    <div class="print-btn">
        <button onclick="window.print()">Print Bill</button>
        <a href="<%= request.getContextPath() %>/cashier">Back to Cashier</a>
    </div>
</div>
</body>
</html>
