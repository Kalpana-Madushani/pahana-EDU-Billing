<%@ page import="Dao.BillDAO" %>
<%@ page import="Dao.BillDAO.BillData" %>
<%@ page import="Dao.BillDAO.BillItem" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int billId = Integer.parseInt(request.getParameter("billId"));
    BillData data = BillDAO.getBillDataById(billId);

    // Format date and time
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
    String formattedDate = sdf.format(data.date); // assuming data.date is a java.util.Date or java.sql.Timestamp
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Invoice #<%= data.billId%></title>
        <link href="https://fonts.googleapis.com/css2?family=Chivo:wght@400;600&display=swap" rel="stylesheet">
        <style>
            body {
                margin: 0;
                padding: 40px;
                background: #f0f4f8;
                font-family: 'Chivo', sans-serif;
                color: #333;
            }

            .invoice {
                max-width: 820px;
                margin: auto;
                background: #ffffff;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 30px 40px;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: #fff;
            }

            .header h1 {
                font-size: 2.4em;
                margin: 0;
            }

            .header .date {
                font-weight: 400;
            }

            .content {
                padding: 30px 40px;
            }

            .customer-info {
                display: flex;
                justify-content: space-between;
                margin-bottom: 30px;
                font-size: 0.95em;
                color: #555;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }

            th, td {
                padding: 14px 12px;
                text-align: left;
            }

            thead {
                background: #f7fafc;
            }

            th {
                font-weight: 600;
                color: #333;
            }

            tbody tr {
                border-bottom: 1px solid #e5e9ef;
            }

            .total-row {
                font-size: 1.3em;
                font-weight: bold;
                color: #2e86de;
            }

            .footer {
                padding: 20px 40px;
                background: #fafbfc;
                display: flex;
                justify-content: flex-end;
                gap: 15px;
            }

            .btn {
                padding: 12px 24px;
                font-size: 0.95em;
                font-weight: 600;
                border-radius: 6px;
                text-decoration: none;
                border: none;
                cursor: pointer;
            }

            .btn-print {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: white;
            }

            .btn-print:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.4);
                background: linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7);
            }

            .btn-back {
                background: #e0e0e0;
                color: #333;
            }

            .btn-back:hover { 
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.4);
                background: #d5d5d5;
            }

            .thank-you {
                text-align: center;
                padding: 40px 20px 30px;
                font-size: 1.2em;
                color: #2e7d32;
                font-weight: 600;
            }

            .note {
                text-align: center;
                color: #777;
                font-size: 0.85em;
                margin-bottom: 20px;
            }

            @media print {
                body, .invoice {
                    margin: 0;
                    background: #fff;
                    box-shadow: none;
                }

                .footer {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <div class="invoice">
            <div class="header">
                <h1>INVOICE #<%= data.billId%></h1>
                <div class="date">Date: <%= formattedDate%></div>
            </div>

            <div class="content">
                <div class="customer-info">
                    <div><strong>Customer:</strong> <%= data.customerName%></div>
                    <div><strong>Phone:</strong> <%= data.customerPhone%></div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Qty</th>
                            <th>Unit Price</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BillItem it : data.items) {%>
                        <tr>
                            <td><%= it.title%></td>
                            <td><%= it.quantity%></td>
                            <td><%= String.format("%.2f", it.price)%> LKR</td>
                            <td><%= String.format("%.2f", it.price * it.quantity)%> LKR</td>
                        </tr>
                        <% }%>
                    </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="3" style="text-align:right;">Total:</td>
                            <td><%= String.format("%.2f", data.total)%> LKR</td>
                        </tr>
                    </tfoot>
                </table>
            </div>

            <div class="thank-you">
                🙏 Thank you for your purchase! Come again soon. 🙌
            </div>

            <div class="note">
                This is a computer-generated bill. For any queries, call support at +94-9876543210 or email: support@pahanaedu.com
            </div>

            <div class="footer">
                <button onclick="window.print()" class="btn btn-print">🖨 Print</button>
                <a href="<%= request.getContextPath()%>/cashier" class="btn btn-back">← Back to Cashier</a>
            </div>
        </div>
    </body>
</html>