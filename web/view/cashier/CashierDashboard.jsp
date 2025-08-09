<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Dao.BillDAO.BillData"%>
<%@ page import="model.Book" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Customer> customers = (List<Customer>) request.getAttribute("customers"); 
    String error = (String) request.getAttribute("error");
     List<BillData> bills = (List<BillData>) request.getAttribute("bills");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Cashier Panel</title>
<style>
    /* Reset */
    *, *::before, *::after {
        box-sizing: border-box;
    }
    body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
            Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
        background-color: #f9fafb;
        color: #111827;
        display: flex;
        height: 100vh;
    }

    /* Sidebar */
    .sidebar {
        width: 250px;
        background-color: #ffffff;
        border-right: 1px solid #e5e7eb;
        display: flex;
        flex-direction: column;
        padding: 24px 20px;
    }
    .sidebar h2 {
        font-weight: 700;
        font-size: 1.75rem;
        margin-bottom: 40px;
        color: #111827;
        text-align: center;
        letter-spacing: 1px;
    }
    .sidebar nav a {
        font-weight: 600;
        font-size: 1rem;
        color: #374151;
        padding: 12px 16px;
        margin-bottom: 12px;
        border-radius: 6px;
        text-decoration: none;
        display: block;
        transition: background-color 0.15s ease, color 0.15s ease;
        cursor: pointer;
    }
    .sidebar nav a:hover,
    .sidebar nav a.active {
        background-color: #e0e7ff;
        color: #3730a3;
    }
    .sidebar nav a.logout {
        margin-top: auto;
        background-color: #ef4444;
        color: #ffffff;
        font-weight: 700;
        text-align: center;
        border-radius: 6px;
        padding: 12px 16px;
        transition: background-color 0.15s ease;
    }
    .sidebar nav a.logout:hover {
        background-color: #b91c1c;
    }

    /* Main Content */
    .main {
        flex-grow: 1;
        background-color: #ffffff;
        padding: 40px 50px;
        overflow-y: auto;
        border-radius: 0 8px 8px 0;
        box-shadow: inset 0 0 10px rgba(0,0,0,0.05);
    }

    h2.page-title {
        font-weight: 800;
        font-size: 2.25rem;
        margin-bottom: 32px;
        border-left: 4px solid #6366f1; /* subtle blue */
        padding-left: 16px;
        color: #1f2937;
    }

    .card {
        background-color: #f3f4f6;
        border-radius: 8px;
        padding: 32px 36px;
        margin-bottom: 32px;
        box-shadow: none;
    }

    h3 {
        font-weight: 600;
        font-size: 1.25rem;
        margin-bottom: 24px;
        color: #374151;
    }

    /* Form styling */
    form label {
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
        color: #4b5563;
        font-size: 14px;
    }

    form input[type="text"],
    form input[type="email"],
    form input[type="number"],
    form select {
        width: 100%;
        padding: 10px 14px;
        margin-bottom: 20px;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        font-size: 15px;
        color: #374151;
        background-color: #ffffff;
        transition: border-color 0.2s ease;
    }
    form input[type="text"]:focus,
    form input[type="email"]:focus,
    form input[type="number"]:focus,
    form select:focus {
        border-color: #6366f1;
        outline: none;
        background-color: #eff6ff;
    }

    form button {
        background-color: #6366f1;
        border: none;
        color: #ffffff;
        padding: 12px 28px;
        border-radius: 6px;
        font-weight: 700;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    form button:hover {
        background-color: #4f46e5;
    }

    /* Table styling */
    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 6px;
        overflow: hidden;
        box-shadow: 0 0 0 1px #e5e7eb;
    }
    th, td {
        padding: 14px 18px;
        font-size: 14px;
        color: #374151;
        text-align: left;
        border-bottom: 1px solid #e5e7eb;
    }
    th {
        background-color: #f9fafb;
        font-weight: 600;
        user-select: none;
    }
    tbody tr:nth-child(odd) {
        background-color: #ffffff;
    }
    tbody tr:nth-child(even) {
        background-color: #f9fafb;
    }
    tbody tr:hover {
        background-color: #e0e7ff;
        cursor: pointer;
    }

    /* Quantity inputs in table */
    input[type="number"] {
        width: 70px;
        padding: 8px 10px;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        font-size: 14px;
        color: #374151;
        background-color: #ffffff;
        transition: border-color 0.2s ease;
    }
    input[type="number"]:focus {
        border-color: #6366f1;
        outline: none;
        background-color: #eff6ff;
    }

    /* Error message */
    .error {
        background-color: #fee2e2;
        border-left: 4px solid #dc2626;
        color: #b91c1c;
        padding: 14px 20px;
        margin-bottom: 30px;
        font-weight: 600;
        border-radius: 6px;
        user-select: none;
    }

    /* Responsive */
    @media (max-width: 768px) {
        body {
            flex-direction: column;
        }
        .sidebar {
            width: 100%;
            border-right: none;
            border-bottom: 1px solid #e5e7eb;
            flex-direction: row;
            padding: 16px 12px;
            overflow-x: auto;
            border-radius: 0 0 8px 8px;
        }
        .sidebar h2 {
            font-size: 1.25rem;
            margin-bottom: 0;
            margin-right: 24px;
            flex: none;
        }
        .sidebar nav a {
            margin: 0 12px 0 0;
            padding: 10px 14px;
            font-size: 14px;
            border-radius: 6px;
            white-space: nowrap;
        }
        .sidebar nav a.logout {
            margin-left: auto;
            margin-right: 0;
        }
        .main {
            padding: 24px 20px;
            border-radius: 0;
            height: auto;
            box-shadow: none;
        }
        table th, table td {
            padding: 12px 10px;
            font-size: 13px;
        }
    }
</style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <h2>🛒 Cashier Panel</h2>
    <nav>
        <a href="#" class="active" data-target="addCustomerSection">Add Customer</a>
        <a href="#" data-target="customerListSection">View Customers</a>
        <a href="#" data-target="generateBillSection">Generate Bill</a> 
         <a href="#" data-target="pastBillsSection">Bill History</a>
        <a href="#" class="logout">Logout</a>
    </nav>
</aside>

<!-- Main Content -->
<main class="main">
    <h2 class="page-title">Cashier Dashboard</h2>

    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <!-- Add Customer Section -->
    <section id="addCustomerSection" class="card active-section">
        <h3>1. Add Customer</h3>
        <form action="${pageContext.request.contextPath}/cashier" method="post" novalidate>
            <input type="hidden" name="action" value="addCustomer"/>
            <label for="name">Name *</label>
            <input id="name" name="name" type="text" required placeholder="Customer Full Name" />

            <label for="phone">Phone</label>
            <input id="phone" name="phone" type="text" placeholder="e.g. +94 77 123 4567" />

            <label for="email">Email</label>
            <input id="email" name="email" type="email" placeholder="example@email.com" />

            <label for="address">Address</label>
            <input id="address" name="address" type="text" placeholder="Customer Address" />

            <button type="submit">Save Customer</button>
        </form>
    </section>

    <!-- Customer List Section -->
    <section id="customerListSection" class="card" style="display:none;">
        <h3>2. Customer List</h3>
        <% if (customers != null && !customers.isEmpty()) { %>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th>Address</th>
                </tr>
                </thead>
                <tbody>
                <% for (Customer c : customers) { %>
                    <tr>
                        <td><%= c.getId() %></td>
                        <td><%= c.getName() %></td>
                        <td><%= c.getPhone() %></td>
                        <td><%= c.getEmail() %></td>
                        <td><%= c.getAddress() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p style="color:#6b7280; font-style: italic;">No customers found.</p>
        <% } %>
    </section>

    <!-- Generate Bill Section -->
    <section id="generateBillSection" class="card" style="display:none;">
        <h3>3. Select Customer & Books to Generate Bill</h3>
        <form action="${pageContext.request.contextPath}/cashier" method="post" novalidate>
            <input type="hidden" name="action" value="createBill"/>

            <!-- Select Customer Dropdown -->
            <label for="customerSelect">Select Customer *</label>
            <select id="customerSelect" name="customerId" required>
                <option value="" disabled selected>-- Select a Customer --</option>
                <% if (customers != null && !customers.isEmpty()) {
                    for (Customer c : customers) { %>
                        <option value="<%= c.getId() %>"><%= c.getName() %> - <%= c.getPhone() %></option>
                <%  }
                } else { %>
                    <option disabled>No customers available</option>
                <% } %>
            </select>

            <!-- Books Table -->
            <table>
                <thead>
                <tr>
                    <th>Select</th>
                    <th>Title</th>
                    <th>Stock</th>
                    <th>Price</th>
                    <th>Qty</th>
                </tr>
                </thead>
                <tbody>
                <% if (books != null && !books.isEmpty()) {
                    for (Book b : books) { %>
                        <tr>
                            <td>
                                <input type="checkbox" name="selected" value="<%= b.getId() %>" />
                            </td>
                            <td><%= b.getTitle() %></td>
                            <td><%= b.getStock() %></td>
                            <td>Rs. <%= b.getPrice() %></td>
                            <td>
                                <input type="number" 
                                       name="quantity_<%= b.getId() %>" 
                                       value="1" min="1" max="<%= Math.max(b.getStock(),1) %>" />
                            </td>
                        </tr>
                <%  }
                } else { %>
                    <tr><td colspan="5" style="text-align:center; color:#6b7280;">No books available</td></tr>
                <% } %>
                </tbody>
            </table>

            <button type="submit" style="margin-top: 24px;">Generate Bill</button>
        </form>
    </section>
                
     <!-- Past Bills Section -->
    <section id="pastBillsSection" class="card" style="display:none;">
        <h3>4. Past Bills</h3>
        <% if (bills != null && !bills.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Customer</th>
                        <th>Date & Time</th>
                        <th>Total Amount (Rs.)</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                <% for (BillData bill : bills) { %>
                    <tr>
                <td><%= bill.billId %></td>
                <td><%= bill.customerName %></td>
                <td><%= sdf.format(bill.date) %></td>
                <td><%= String.format("%.2f", bill.total) %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/view/cashier/printBill.jsp?billId=<%= bill.billId %>" target="_blank">View</a>
                </td>
            </tr>

                <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p style="color:#6b7280; font-style: italic;">No past bills found.</p>
        <% } %>
    </section>            
</main>

<script>
    // Sidebar navigation toggle logic
    const links = document.querySelectorAll('.sidebar nav a[data-target]');
    const sections = document.querySelectorAll('main section');

    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            links.forEach(l => l.classList.remove('active'));
            this.classList.add('active');

            sections.forEach(section => section.style.display = 'none');
            const targetId = this.getAttribute('data-target');
            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                targetSection.style.display = 'block';
            }
        });
    });
</script>

</body>
</html>
