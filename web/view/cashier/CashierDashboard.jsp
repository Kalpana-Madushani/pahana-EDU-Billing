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
        <link rel="icon" href="https://img.icons8.com/color/32/000000/cash-register.png" type="image/png">
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
                min-width: 250px;
                max-width: 250px;
                flex-shrink: 0;
            }

            .sidebar .logo {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 2rem;
                font-weight: bold;
                color: #B595D8;
            }

            .sidebar h2 {
                font-weight: 700;
                font-size: 1.75rem;
                margin-bottom: 40px;
                color: #111827;
                text-align: center;
                letter-spacing: 1px;
            }

            .sidebar a {
                font-weight: 600;
                font-size: 1rem;
                color: #374151;
                padding: 20px 16px;
                margin-bottom: 20px;
                border-radius: 6px;
                text-decoration: none;
                display: block;
                transition: background-color 0.15s ease, color 0.15s ease;
                cursor: pointer;
            }

            .sidebar a:not(.logout):hover,
            .sidebar a.active {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: #374151;
            }

            .sidebar a.logout {
                background-color: #ef4444;
                color: #ffffff;
                font-weight: 700;
                text-align: left;
                border-radius: 6px;
                padding: 20px 16px;
                transition: background-color 0.15s ease;
            }
            .sidebar a.logout:hover {
                background-color: #b91c1c;
            }

            .sidebar .sidebar-footer {
                margin-top: auto;
                padding-top: 1.5rem;
                border-top: 1px solid #e5e7eb;
                font-size: 0.875rem;
                color: #6b7280;
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
            }
            .sidebar .sidebar-footer .clock {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
            .sidebar .sidebar-footer .note {
                background-color: #fee2e2;
                padding: 0.75rem;
                border-radius: 8px;
                color: #dc2626;
                font-weight: 500;
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
                border-left: 4px solid #E8D5F2;
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

            /* Modal styling */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.4);
            }
            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 32px 36px;
                border-radius: 12px;
                width: 500px;
                box-shadow: 0 25px 50px rgba(0,0,0,0.25);
                position: relative;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
                transition: color 0.3s ease;
            }
            .close:hover {
                color: #000;
            }

            /* Action buttons */
            .action-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                border: none;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                margin-right: 8px;
            }
            .action-btn.edit {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: #ffffff;
                box-shadow: 0 2px 4px rgba(181, 149, 216, 0.3);
            }
            .action-btn.edit:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(181, 149, 216, 0.4);
                background: linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7);
            }
            .action-btn.delete {
                background: #ef4444;
                color: #ffffff;
                box-shadow: 0 2px 4px rgba(239, 68, 68, 0.3);
            }
            .action-btn.delete:hover {
                background: #dc2626;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
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
            form input[type="phone"],
            form input[type="number"],
            form select {
                width: 100%;
                padding: 10px 14px;
                margin-bottom: 20px;
                border: 1px solid #E8D5F2;
                border-radius: 8px;
                font-size: 15px;
                color: #374151;
                background-color: #ffffff;
                transition: border-color 0.2s ease;
            }
            form input[type="text"]:focus,
            form input[type="email"]:focus,
            form input[type="phone"]:focus,
            form input[type="number"]:focus,
            form select:focus {
                border-color: #B595D8;
                outline: none;
                background-color: #eff6ff;
            }

            form button {
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
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
                display: none;
            }

            .error.show {
                display: block;
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
            <h2 class="logo">🏠 PAHANA Edu</h2>
            <nav>
                <a href="#" class="active" data-target="addCustomerSection">➕ Add Customer</a>
                <a href="#" data-target="customerListSection">👥 View Customers</a>
                <a href="#" data-target="generateBillSection">📜 Generate Bill</a> 
                <a href="#" data-target="pastBillsSection">📋 Bill History</a>
                <a href="#" data-target="helpSection">❓ Help & Guide</a>
                <a href="login.jsp" class="logout">🔓 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main">
            <h2 class="page-title">Cashier Panel</h2>

            <!-- Add Customer Section -->
            <section id="addCustomerSection" class="card active-section">
                <h3>1. Add Customer</h3>
                <div class="error"></div>
                <form action="${pageContext.request.contextPath}/cashier" method="post" novalidate>
                    <input type="hidden" name="action" value="addCustomer"/>
                    <label for="name">Name *</label>
                    <input id="name" name="name" type="text" pattern="[A-Za-z\s\-']{2,50}" required placeholder="Customer Full Name" />

                    <label for="phone">Phone</label>
                    <input id="phone" name="phone" type="number" pattern="0[0-9]{9}" placeholder="e.g. +94 77 123 4567" />

                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" placeholder="example@email.com" />

                    <label for="address">Address</label>
                    <input id="address" name="address" type="text" placeholder="Customer Address" />

                    <button type="submit" onclick="successFullyAdded('customer', event)">Save Customer</button>
                </form>
            </section>

            <!-- Customer List Section -->
            <section id="customerListSection" class="card" style="display:none;">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>2. Customer List</h3>
                    <div style="position: relative; min-width: 400px;">
                        <input 
                            type="text" 
                            id="customerSearch" 
                            placeholder="Search customers by name or phone..." 
                            oninput="filterCustomers()"
                            style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                            onfocus="this.style.borderColor = '#E8D5F2';"
                            onblur="this.style.borderColor = '#E8D5F2';"
                            />
                    </div>
                </div>

                <% if (customers != null && !customers.isEmpty()) { %>
                <table id="customersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Customer c : customers) {%>
                        <tr data-customer-id="<%= c.getId()%>"
                            data-customer-name="<%= c.getName() != null ? c.getName().replace("\"", "&quot;") : ""%>" 
                            data-customer-phone="<%= c.getPhone() != null ? c.getPhone().replace("\"", "&quot;") : ""%>"
                            data-customer-email="<%= c.getEmail() != null ? c.getEmail().replace("\"", "&quot;") : ""%>"
                            data-customer-address="<%= c.getAddress() != null ? c.getAddress().replace("\"", "&quot;") : ""%>">
                            <td><%= c.getId()%></td>
                            <td><%= c.getName()%></td>
                            <td><%= c.getPhone()%></td>
                            <td><%= c.getEmail()%></td>
                            <td><%= c.getAddress()%></td>
                            <td>
                                <button class="action-btn edit" onclick="openEditCustomerModal(this)">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                    </svg>
                                    Edit
                                </button>
                                <button class="action-btn delete" onclick="confirmDelete('customer', <%= c.getId()%>)">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                    <path d="M3 6h18"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/>
                                    </svg>
                                    Delete
                                </button>
                            </td>
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
                <div class="error"></div>
                <form action="${pageContext.request.contextPath}/cashier" method="post">
                    <input type="hidden" name="action" value="createBill"/>
                    <label for="customerSelect">Select Customer *</label>
                    <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                        <!-- Select Customer Drop-down -->
                        <div style="position: relative; width: 100%;">
                            <!-- Hidden input to store the actual customer ID -->
                            <input type="hidden" id="selectedCustomerId" name="customerId" required />

                            <!-- Searchable input field -->
                            <input 
                                type="text" 
                                id="customerSearchInput" 
                                placeholder="Type to search customer name or phone..." 
                                autocomplete="off"
                                style="width: 100%; padding: 10px 40px 10px 14px; border: 1px solid #E8D5F2; border-radius: 8px; font-size: 15px; color: #374151; background-color: #ffffff; transition: border-color 0.2s ease;"
                                onfocus="showDropdown()" 
                                oninput="filterCustomerOptions()" 
                                onblur="hideDropdownDelayed()"
                                />

                            <!-- Black Drop-down Arrow -->
                            <div style="position: absolute; right: 12px; top: 35%; transform: translateY(-50%); pointer-events: none; color: #000000;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6,9 12,15 18,9"></polyline>
                                </svg>
                            </div>

                            <!-- Drop-down list -->
                            <div id="customerDropdownList" style="
                                 position: absolute;
                                 top: 100%;
                                 left: 0;
                                 right: 0;
                                 background: white;
                                 border: 1px solid #E8D5F2;
                                 border-radius: 8px;
                                 box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                                 max-height: 200px;
                                 overflow-y: auto;
                                 z-index: 1000;
                                 display: none;
                                 ">
                                <% if (customers != null && !customers.isEmpty()) {
                                        for (Customer c : customers) {%>
                                <div class="customer-option" 
                                     data-id="<%= c.getId()%>" 
                                     data-name="<%= c.getName() != null ? c.getName().replace("\"", "&quot;") : ""%>" 
                                     data-phone="<%= c.getPhone() != null ? c.getPhone().replace("\"", "&quot;") : ""%>"
                                     onclick="selectCustomer(<%= c.getId()%>, '<%= c.getName() != null ? c.getName().replace("'", "\\'") : ""%>', '<%= c.getPhone() != null ? c.getPhone().replace("'", "\\'") : ""%>')"
                                     style="
                                     padding: 12px 14px;
                                     cursor: pointer;
                                     border-bottom: 1px solid #f3f4f6;
                                     transition: background-color 0.2s ease;
                                     "
                                     onmouseover="this.style.backgroundColor = '#f3f4f6'" 
                                     onmouseout="this.style.backgroundColor = 'white'">
                                    <span style="font-weight: 600; color: #374151;"><%= c.getName()%></span>
                                    <span style="color: #6b7280; margin-left: 8px;">- <%= c.getPhone()%></span>
                                </div>
                                <%  }
                                } else { %>
                                <div style="padding: 12px 14px; color: #6b7280; font-style: italic;">No customers available</div>
                                <% } %>
                            </div>
                        </div>

                        <div style="position: relative; min-width: 400px;">
                            <input 
                                type="text" 
                                id="bookSearch" 
                                placeholder="Search book by title..." 
                                oninput="filterBooks()"
                                style="width: 100%; padding: 10px 40px 10px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 15px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                                onfocus="this.style.borderColor = '#E8D5F2';"
                                onblur="this.style.borderColor = '#E8D5F2';"
                                />
                        </div>
                    </div>
                    <!-- Books Table -->
                    <table id="booksTable">
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
                                    for (Book b : books) {%>
                            <tr data-title="<%= b.getTitle() != null ? b.getTitle().replace("\"", "&quot;") : ""%>">
                                <td>
                                    <input type="checkbox" name="selected" value="<%= b.getId()%>" />
                                </td>
                                <td><%= b.getTitle()%></td>
                                <td><%= b.getStock()%></td>
                                <td>Rs. <%= b.getPrice()%></td>
                                <td>
                                    <input type="number" 
                                           name="quantity_<%= b.getId()%>" 
                                           value="1" min="1" max="<%= Math.max(b.getStock(), 1)%>" />
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
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>4. Past Bills</h3>
                    <div style="position: relative; min-width: 400px;">
                        <input 
                            type="text" 
                            id="billSearch" 
                            placeholder="Search bill by customer name or date..." 
                            oninput="filterBills()"
                            style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                            onfocus="this.style.borderColor = '#E8D5F2';"
                            onblur="this.style.borderColor = '#E8D5F2';"
                            />
                    </div>
                </div>
                <% if (bills != null && !bills.isEmpty()) { %>
                <table id="billsTable">
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
                        <% for (BillData bill : bills) {%>
                        <tr>
                            <td><%= bill.billId%></td>
                            <td><%= bill.customerName%></td>
                            <td><%= sdf.format(bill.date)%></td>
                            <td><%= String.format("%.2f", bill.total)%></td>
                            <td>
                                <a href="<%= request.getContextPath()%>/view/cashier/printBill.jsp?billId=<%= bill.billId%>" 
                                   target="_blank" 
                                   class="view-btn"
                                   style="
                                   display: inline-flex;
                                   align-items: center;
                                   gap: 6px;
                                   padding: 8px 16px;
                                   background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                                   color: #ffffff;
                                   text-decoration: none;
                                   border-radius: 8px;
                                   font-size: 13px;
                                   font-weight: 600;
                                   transition: all 0.3s ease;
                                   box-shadow: 0 2px 4px rgba(181, 149, 216, 0.3);
                                   border: none;
                                   cursor: pointer;
                                   "
                                   onmouseover="this.style.transform = 'translateY(-2px)'; this.style.boxShadow = '0 4px 12px rgba(181, 149, 216, 0.4)'; this.style.background = 'linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7)';"
                                   onmouseout="this.style.transform = 'translateY(0)'; this.style.boxShadow = '0 2px 4px rgba(181, 149, 216, 0.3)'; this.style.background = 'linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8)';">
                                    <!-- Eye icon SVG -->
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    View
                                </a>
                            </td>
                        </tr>

                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p style="color:#6b7280; font-style: italic;">No past bills found.</p>
                <% }%>
            </section>   

            <!-- Help & Guide Section -->
            <section id="helpSection" class="card" style="display:none;">
                <h3>5. Help & Guide</h3>

                <div style="max-width: 100%;">
                    <!-- Quick Start Guide -->
                    <div style="background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8); color: white; padding: 20px; border-radius: 12px; margin-bottom: 30px;">
                        <h4 style="margin: 0 0 12px 0; font-size: 1.4rem; font-weight: bold;">🚀 Quick Start Guide</h4>
                        <p style="margin: 0; font-size: 1.1rem; line-height: 1.5;">
                            Welcome to Pahana Bookshop Cashier Panel! Follow these simple steps to process your first sale:
                            <strong>Add Customer → Select Books → Generate Bill</strong>
                        </p>
                    </div>

                    <!-- Step-by-Step Instructions -->
                    <div style="margin-bottom: 40px;">
                        <h4 style="color: #374151; font-size: 1.3rem; margin-bottom: 20px; border-bottom: 2px solid #E8D5F2; padding-bottom: 8px;">
                            📋 Step-by-Step Instructions
                        </h4>

                        <!-- Step 1 -->
                        <div style="background: #f8fafc; border-left: 4px solid #B595D8; padding: 20px; margin-bottom: 20px; border-radius: 0 8px 8px 0;">
                            <h5 style="color: #B595D8; font-size: 1.1rem; margin: 0 0 12px 0; font-weight: 600;">
                                Step 1: Add Customer
                            </h5>
                            <ul style="margin: 0; padding-left: 20px; line-height: 1.6;">
                                <li><strong>Name:</strong> Enter customer's full name (2-50 characters, letters only)</li>
                                <li><strong>Phone:</strong> Optional, but must be 10 digits starting with 0 (e.g., 0771234567)</li>
                                <li><strong>Email:</strong> Optional, but must be a valid email format</li>
                                <li><strong>Address:</strong> Optional, 5-100 characters if provided</li>
                            </ul>
                        </div>

                        <!-- Step 2 -->
                        <div style="background: #f8fafc; border-left: 4px solid #B595D8; padding: 20px; margin-bottom: 20px; border-radius: 0 8px 8px 0;">
                            <h5 style="color: #B595D8; font-size: 1.1rem; margin: 0 0 12px 0; font-weight: 600;">
                                Step 2: View & Manage Customers
                            </h5>
                            <ul style="margin: 0; padding-left: 20px; line-height: 1.6;">
                                <li>Search customers by name or phone number</li>
                                <li>Edit customer information using the <span style="background: #B595D8; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;">Edit</span> button</li>
                                <li>Delete customers using the <span style="background: #ef4444; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;">Delete</span> button</li>
                                <li>All changes are saved automatically</li>
                            </ul>
                        </div>

                        <!-- Step 3 -->
                        <div style="background: #f8fafc; border-left: 4px solid #B595D8; padding: 20px; margin-bottom: 20px; border-radius: 0 8px 8px 0;">
                            <h5 style="color: #B595D8; font-size: 1.1rem; margin: 0 0 12px 0; font-weight: 600;">
                                Step 3: Generate Bill
                            </h5>
                            <ul style="margin: 0; padding-left: 20px; line-height: 1.6;">
                                <li>Select a customer from the dropdown (type to search)</li>
                                <li>Search and select books you want to sell</li>
                                <li>Check the boxes next to the books</li>
                                <li>Adjust quantities as needed (cannot exceed stock)</li>
                                <li>Click "Generate Bill" to create the invoice</li>
                            </ul>
                        </div>

                        <!-- Step 4 -->
                        <div style="background: #f8fafc; border-left: 4px solid #B595D8; padding: 20px; margin-bottom: 20px; border-radius: 0 8px 8px 0;">
                            <h5 style="color: #B595D8; font-size: 1.1rem; margin: 0 0 12px 0; font-weight: 600;">
                                Step 4: View Bill History
                            </h5>
                            <ul style="margin: 0; padding-left: 20px; line-height: 1.6;">
                                <li>Search bills by customer name or date</li>
                                <li>Click <span style="background: #B595D8; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px;">View</span> to see bill details and print</li>
                                <li>Bills are automatically saved with timestamp</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Tips & Tricks -->
                    <div style="margin-bottom: 40px;">
                        <h4 style="color: #374151; font-size: 1.3rem; margin-bottom: 20px; border-bottom: 2px solid #E8D5F2; padding-bottom: 8px;">
                            💡 Tips & Tricks
                        </h4>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                            <div style="background: #fff7ed; border: 1px solid #fed7aa; padding: 15px; border-radius: 8px;">
                                <h6 style="color: #ea580c; margin: 0 0 8px 0; font-size: 1rem;">🔍 Search Features</h6>
                                <p style="margin: 0; font-size: 14px; line-height: 1.5;">
                                    Use the search boxes to quickly find customers, books, or bills. 
                                    Search works in real-time as you type.
                                </p>
                            </div>

                            <div style="background: #ecfdf5; border: 1px solid #a7f3d0; padding: 15px; border-radius: 8px;">
                                <h6 style="color: #059669; margin: 0 0 8px 0; font-size: 1rem;">⚡ Quick Actions</h6>
                                <p style="margin: 0; font-size: 14px; line-height: 1.5;">
                                    Use keyboard shortcuts: Enter to submit forms, 
                                    Escape to close modals, Tab to navigate fields.
                                </p>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div style="background: #eff6ff; border: 1px solid #bfdbfe; padding: 15px; border-radius: 8px;">
                                <h6 style="color: #2563eb; margin: 0 0 8px 0; font-size: 1rem;">📊 Data Validation</h6>
                                <p style="margin: 0; font-size: 14px; line-height: 1.5;">
                                    The system automatically validates your input. 
                                    Red error messages will guide you if something needs correction.
                                </p>
                            </div>

                            <div style="background: #fef3c7; border: 1px solid #fcd34d; padding: 15px; border-radius: 8px;">
                                <h6 style="color: #d97706; margin: 0 0 8px 0; font-size: 1rem;">💾 Auto-Save</h6>
                                <p style="margin: 0; font-size: 14px; line-height: 1.5;">
                                    All data is saved automatically. Bills are timestamped 
                                    and stored permanently for future reference.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Common Issues & Solutions -->
                    <div style="margin-bottom: 40px;">
                        <h4 style="color: #374151; font-size: 1.3rem; margin-bottom: 20px; border-bottom: 2px solid #E8D5F2; padding-bottom: 8px;">
                            🔧 Common Issues & Solutions
                        </h4>

                        <div style="background: #fefefe; border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden;">
                            <div style="background: #f9fafb; padding: 15px; border-bottom: 1px solid #e5e7eb;">
                                <h6 style="margin: 0; color: #374151; font-size: 1rem;">❌ "Please select a customer" error</h6>
                            </div>
                            <div style="padding: 15px;">
                                <p style="margin: 0; color: #6b7280; line-height: 1.5;">
                                    <strong>Solution:</strong> Make sure to click on a customer from the dropdown list. 
                                    Just typing the name isn't enough - you must select it from the list.
                                </p>
                            </div>
                        </div>

                        <div style="background: #fefefe; border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; margin-top: 10px;">
                            <div style="background: #f9fafb; padding: 15px; border-bottom: 1px solid #e5e7eb;">
                                <h6 style="margin: 0; color: #374151; font-size: 1rem;">❌ "Invalid quantity" error</h6>
                            </div>
                            <div style="padding: 15px;">
                                <p style="margin: 0; color: #6b7280; line-height: 1.5;">
                                    <strong>Solution:</strong> Check that your quantity is between 1 and the available stock. 
                                    You cannot sell more books than are in stock.
                                </p>
                            </div>
                        </div>

                        <div style="background: #fefefe; border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; margin-top: 10px;">
                            <div style="background: #f9fafb; padding: 15px; border-bottom: 1px solid #e5e7eb;">
                                <h6 style="margin: 0; color: #374151; font-size: 1rem;">❌ Can't find customer or book</h6>
                            </div>
                            <div style="padding: 15px;">
                                <p style="margin: 0; color: #6b7280; line-height: 1.5;">
                                    <strong>Solution:</strong> Try searching with partial names or phone numbers. 
                                    Clear the search box to see all available options.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Contact & Support -->
                    <div style="background: #e5e7eb; padding: 25px; border-radius: 12px; text-align: center;">
                        <h4 style="color: #374151; margin: 0 0 15px 0; font-size: 1.2rem;">📞 Need More Help?</h4>
                        <p style="margin: 0 0 15px 0; color: #6b7280; line-height: 1.6;">
                            If you encounter any issues or need additional support, please contact the system administrator 
                            or refer to your training materials.
                        </p>
                        <div style="display: flex; justify-content: center; gap: 15px; flex-wrap: wrap;">
                            <span style="background: #B595D8; color: white; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 500;">
                                📧 support@pahanabookshop.com
                            </span>
                            <span style="background: #B595D8; color: white; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 500;">
                                📱 +94 11 123 4567
                            </span>
                        </div>
                    </div>

                    <!-- Keyboard Shortcuts -->
                    <div style="margin-top: 30px;">
                        <h4 style="color: #374151; font-size: 1.3rem; margin-bottom: 20px; border-bottom: 2px solid #E8D5F2; padding-bottom: 8px;">
                            ⌨️ Keyboard Shortcuts
                        </h4>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="background: #f8fafc; padding: 12px; border-radius: 6px; border-left: 3px solid #B595D8;">
                                <strong style="color: #374151;">Tab</strong> - Move to next field
                            </div>
                            <div style="background: #f8fafc; padding: 12px; border-radius: 6px; border-left: 3px solid #B595D8;">
                                <strong style="color: #374151;">Enter</strong> - Submit form
                            </div>
                            <div style="background: #f8fafc; padding: 12px; border-radius: 6px; border-left: 3px solid #B595D8;">
                                <strong style="color: #374151;">Escape</strong> - Close modal
                            </div>
                            <div style="background: #f8fafc; padding: 12px; border-radius: 6px; border-left: 3px solid #B595D8;">
                                <strong style="color: #374151;">Ctrl + F</strong> - Find on page
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Edit Customer Modal -->
            <div id="customerModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal('customerModal')">&times;</span>
                    <h3 id="customerModalTitle">Edit Customer</h3>
                    <div class="error"></div>
                    <form id="customerForm" action="${pageContext.request.contextPath}/cashier" method="POST">
                        <input type="hidden" name="action" value="updateCustomer"/>
                        <input type="hidden" id="customerId" name="id" />
                        <label for="customerName">Name *</label>
                        <input type="text" id="customerName" name="name" pattern="[A-Za-z\s\-']{2,50}" required placeholder="Customer Full Name" />
                        <label for="customerPhone">Phone</label>
                        <input type="text" id="customerPhone" name="phone" pattern="0[0-9]{9}" placeholder="e.g. +94 77 123 4567" />
                        <label for="customerEmail">Email</label>
                        <input type="email" id="customerEmail" name="email" placeholder="example@email.com" />
                        <label for="customerAddress">Address</label>
                        <input type="text" id="customerAddress" name="address" placeholder="Customer Address" />
                        <button type="submit">Save Customer</button>
                    </form>
                </div>
            </div>
        </main>

        <form id="deleteForm" method="post" style="display:none;">
            <input type="hidden" name="action" id="deleteAction">
            <input type="hidden" name="id" id="deleteId">
        </form>

        <script>
            const links = document.querySelectorAll('.sidebar nav a[data-target]');
            const sections = document.querySelectorAll('main section');

            function showSection(targetId) {
                let found = false;

                // Remove active class and hide all sections
                links.forEach(link => {
                    if (link.getAttribute('data-target') === targetId) {
                        link.classList.add('active');
                        found = true;
                    } else {
                        link.classList.remove('active');
                    }
                });

                sections.forEach(section => {
                    section.style.display = section.id === targetId ? 'block' : 'none';
                });

                // If targetId not found, fallback to first section
                if (!found && links.length > 0) {
                    const firstId = links[0].getAttribute('data-target');
                    links[0].classList.add('active');
                    sections.forEach(section => {
                        section.style.display = section.id === firstId ? 'block' : 'none';
                    });
                }
            }

            // Click event for sidebar links
            links.forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('data-target');
                    showSection(targetId);

                    // Update URL query parameter without reloading
                    const url = new URL(window.location);
                    url.searchParams.set('activeTab', targetId);
                    window.history.pushState({}, '', url);
                });
            });

            // Handle page load with URL query parameter
            const urlParams = new URLSearchParams(window.location.search);
            const activeTab = urlParams.get('activeTab');
            showSection(activeTab);
        </script>

        <script>

            function filterCustomers() {
                const query = document.getElementById('customerSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#customersTable tbody tr');

                rows.forEach(row => {
                    const name = row.dataset.customerName ? row.dataset.customerName.toLowerCase() : '';
                    const phone = row.dataset.customerPhone ? row.dataset.customerPhone.toLowerCase() : '';

                    const visible = name.includes(query) || phone.includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }

            function filterBooks() {
                const query = document.getElementById('bookSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#booksTable tbody tr');
                rows.forEach(row => {
                    const title = row.dataset.title || '';

                    const visible = title.includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }

            function filterBills() {
                const query = document.getElementById('billSearch').value.trim().toLowerCase();
                const table = document.getElementById('billsTable');
                const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

                for (let i = 0; i < rows.length; i++) {
                    const row = rows[i];
                    const customerName = row.getElementsByTagName('td')[1].textContent.toLowerCase();
                    const dateTime = row.getElementsByTagName('td')[2].textContent;
                    const dateOnly = dateTime.split(' ')[0]; // Get only the date part (e.g., "2025-08-10")

                    if (query === '' || customerName.includes(query) || dateOnly.includes(query)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            }

            function openModal(modalId) {
                document.getElementById(modalId).style.display = 'block';
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
                const form = document.getElementById('customerForm');
                if (form)
                    form.reset();
                const errorDiv = document.querySelector('#customerModal .error');
                if (errorDiv) {
                    errorDiv.classList.remove('show');
                    errorDiv.textContent = '';
                }
            }

            function openEditCustomerModal(button) {
                const tr = button.closest('tr');
                openModal('customerModal');
                console.log(tr.getAttribute('data-customer-id'));
                document.getElementById('customerModalTitle').innerText = 'Edit Customer';
                document.getElementById('customerId').value = tr.getAttribute('data-customer-id');
                document.getElementById('customerName').value = tr.getAttribute('data-customer-name');
                document.getElementById('customerPhone').value = tr.getAttribute('data-customer-phone');
                document.getElementById('customerEmail').value = tr.getAttribute('data-customer-email');
                document.getElementById('customerAddress').value = tr.getAttribute('data-customer-address');
            }

            // Delete confirmation
            function confirmDelete(type, id) {
                if (confirm('Are you sure you want to delete this ' + type + '?')) {
                    const form = document.getElementById('deleteForm');
                    document.getElementById('deleteAction').value = "deleteCustomer";
                    document.getElementById('deleteId').value = id;
                    form.submit();
                }
            }

            // Added Successfully
//            function successFullyAdded(type) {
//                alert('Successfully added ' + type + '.');
//            }

            function successFullyAdded(type, event) {
                event.preventDefault(); // Prevent default form submission
                const form = document.querySelector('#addCustomerSection form'); // Select the add book form
                const inputs = form.querySelectorAll('input[required]');
                let allFilled = true;

                // Check if all required fields are filled
                inputs.forEach(input => {
                    if (!input.value.trim()) {
                        allFilled = false;
                    }
                });

                // If all fields are filled, show alert and submit the form
                if (allFilled) {
                    alert('Successfully added ' + type + '.');
                    form.submit(); // Programmatically submit the form
                } else {
                    alert('Please fill in all required fields.');
                }
            }

            // Close modals when clicking outside
            window.addEventListener('click', function (e) {
                if (e.target.classList.contains('modal')) {
                    e.target.style.display = 'none';
                }
            });

            // Add Customer form validation
            const customerForm = document.querySelector('#addCustomerSection form');
            const nameInput = document.querySelector('#name');
            const phoneInput = document.querySelector('#phone');
            const emailInput = document.querySelector('#email');
            const addressInput = document.querySelector('#address');
            const errorDiv = document.querySelector('#addCustomerSection .error');

            customerForm.addEventListener('submit', (e) => {
                errorDiv.classList.remove('show');
                errorDiv.textContent = '';

                // Name validation: 2-50 characters, letters, spaces, hyphens, apostrophes
                const namePattern = /^[A-Za-z\s\-']{2,50}$/;
                if (!namePattern.test(nameInput.value)) {
                    e.preventDefault();
                    errorDiv.textContent = 'Name must be 2-50 characters, using letters, spaces, hyphens, or apostrophes.';
                    errorDiv.classList.add('show');
                    nameInput.focus();
                    return;
                }

                // Phone validation: Optional, but if provided, must be 10 digits starting with 0
                if (phoneInput.value && !/^0[0-9]{9}$/.test(phoneInput.value)) {
                    e.preventDefault();
                    errorDiv.textContent = 'Phone must be 10 digits starting with 0 (e.g., 0761234567).';
                    errorDiv.classList.add('show');
                    phoneInput.focus();
                    return;
                }

                // Email validation: Optional, but if provided, must be valid
                if (emailInput.value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value)) {
                    e.preventDefault();
                    errorDiv.textContent = 'Please enter a valid email address.';
                    errorDiv.classList.add('show');
                    emailInput.focus();
                    return;
                }

                // Address validation: Optional, but if provided, 5-100 characters
                if (addressInput.value && !/^.{5,100}$/.test(addressInput.value)) {
                    e.preventDefault();
                    errorDiv.textContent = 'Address must be 5-100 characters if provided.';
                    errorDiv.classList.add('show');
                    addressInput.focus();
                    return;
                }
            });

            // Customer dropdown search functionality
            let hideTimeout;

            function showDropdown() {
                clearTimeout(hideTimeout);
                document.getElementById('customerDropdownList').style.display = 'block';
            }

            function hideDropdownDelayed() {
                hideTimeout = setTimeout(() => {
                    document.getElementById('customerDropdownList').style.display = 'none';
                }, 200);
            }

            function filterCustomerOptions() {
                const input = document.getElementById('customerSearchInput');
                const dropdown = document.getElementById('customerDropdownList');
                const query = input.value.toLowerCase();
                const options = dropdown.querySelectorAll('.customer-option');

                let hasVisible = false;

                options.forEach(option => {
                    const name = option.dataset.name.toLowerCase();
                    const phone = option.dataset.phone.toLowerCase();
                    const isVisible = name.includes(query) || phone.includes(query);

                    option.style.display = isVisible ? 'block' : 'none';
                    if (isVisible)
                        hasVisible = true;
                });

                // Clear selection if input doesn't match any customer exactly
                const exactMatch = Array.from(options).find(option =>
                    option.dataset.name.toLowerCase() === query ||
                            option.dataset.phone.toLowerCase() === query
                );

                if (!exactMatch) {
                    document.getElementById('selectedCustomerId').value = '';
                }
            }

            function selectCustomer(id, name, phone) {
                document.getElementById('selectedCustomerId').value = id;
                document.getElementById('customerSearchInput').value = name + ' - ' + phone;
                document.getElementById('customerDropdownList').style.display = 'none';
            }

            // Clear customer selection when input is cleared
            document.getElementById('customerSearchInput').addEventListener('input', function () {
                if (this.value === '') {
                    document.getElementById('selectedCustomerId').value = '';
                }
            });

            // Generate Bill form validation
            const billForm = document.querySelector('#generateBillSection form');
            const billErrorDiv = document.querySelector('#generateBillSection .error');
            billForm.addEventListener('submit', (e) => {
                billErrorDiv.classList.remove('show');
                billErrorDiv.textContent = '';

                // Check if a customer is selected
                const customerId = document.getElementById('selectedCustomerId').value;
                if (!customerId) {
                    e.preventDefault();
                    billErrorDiv.textContent = 'Please select a customer before generating the bill.';
                    billErrorDiv.classList.add('show');
                    document.getElementById('customerSearchInput').focus();
                    return;
                }

                // Check if at least one book is selected
                const selectedBooks = document.querySelectorAll('input[name="selected"]:checked');
                if (selectedBooks.length === 0) {
                    e.preventDefault();
                    billErrorDiv.textContent = 'Please select at least one book before generating the bill.';
                    billErrorDiv.classList.add('show');
                    return;
                }

                // Validate quantities for selected books
                for (let checkbox of selectedBooks) {
                    const bookId = checkbox.value;
                    const quantityInput = document.querySelector(`input[name="quantity_${bookId}"]`);
                    const quantity = parseInt(quantityInput.value);
                    const maxQuantity = parseInt(quantityInput.max);
                    if (isNaN(quantity) || quantity < 1 || quantity > maxQuantity) {
                        e.preventDefault();
                        billErrorDiv.textContent = `Invalid quantity for book ID ${bookId}. Must be between 1 and ${maxQuantity}.`;
                        billErrorDiv.classList.add('show');
                        quantityInput.focus();
                        return;
                    }
                }
            });

            // Disable submit button if no customers or books are available
            document.addEventListener('DOMContentLoaded', () => {
                const customerOptions = document.querySelectorAll('#customerDropdownList .customer-option');
                const bookRows = document.querySelectorAll('#generateBillSection table tbody tr input[name="selected"]');
                const submitButton = document.querySelector('#generateBillSection button[type="submit"]');

                if (customerOptions.length === 0 || bookRows.length === 0) {
                    submitButton.disabled = true;
                    submitButton.style.opacity = '0.5';
                    submitButton.style.cursor = 'not-allowed';
                }
            });

        </script>

        <script>
            const params = new URLSearchParams(window.location.search);
            const error = params.get("error");

            if (error) {
                billErrorDiv.textContent = error;
                billErrorDiv.classList.add('show');
            }
        </script>

    </body>
</html>
