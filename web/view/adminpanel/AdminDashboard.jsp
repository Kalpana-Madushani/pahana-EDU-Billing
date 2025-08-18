<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Dao.BillDAO.BillData"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Customer" %>
<%@ page import="model.User" %>
<%@ page import="model.Book" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<User> users = (List<User>) request.getAttribute("users");
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<BillData> bills = (List<BillData>) request.getAttribute("bills");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Admin Panel</title>
        <link rel="icon" href="https://img.icons8.com/color/48/000000/control-panel.png" type="image/png">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                overflow: hidden;
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
                height: 100vh; /* Full viewport height */
                position: fixed; /* Fix sidebar */
                top: 0;
                left: 0;
                overflow-y: auto;
            }

            /* Hide scrollbar for WebKit browsers (Chrome, Safari, etc.) */
            .sidebar::-webkit-scrollbar {
                display: none; /* Hides the scrollbar */
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
                overflow-y: auto; /* Enable scrolling for main content */
                border-radius: 0 8px 8px 0;
                box-shadow: inset 0 0 10px rgba(0,0,0,0.05);
                margin-left: 250px; /* Offset to avoid overlapping fixed sidebar */
                height: 100vh; /* Full viewport height */
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
            form input[type="password"],
            form select,
            form textarea {
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
            form input[type="number"]:focus,
            form input[type="password"]:focus,
            form select:focus,
            form textarea:focus {
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

            /* Add button */
            .add-btn {
                background: linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7);
                color: #ffffff;
                border: none;
                border-radius: 8px;
                padding: 12px 24px;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
            }
            .add-btn:hover {
                background: linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7);
                transform: translateY(-2px);
                /*box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4);*/
            }

            /* Summary cards styling */
            .summary-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 32px;
            }
            .summary-card {
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.07);
                padding: 24px 20px;
                text-align: center;
                user-select: none;
                transition: box-shadow 0.3s ease, transform 0.3s ease;
                cursor: default;
            }
            .summary-card:hover {
                box-shadow: 0 6px 15px rgba(0,0,0,0.12);
                transform: translateY(-4px);
            }
            .summary-card h4 {
                font-size: 1.1rem;
                font-weight: 600;
                color: #1e3a8a;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.08em;
            }
            .summary-card .count {
                font-size: 2.5rem;
                font-weight: 700;
                color: #2563eb;
                margin: 0;
                line-height: 1;
            }
            .summary-card small {
                color: #64748b;
                font-weight: 500;
                letter-spacing: 0.04em;
                display: block;
                margin-top: 8px;
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

            /* Book grid styling */
            .books-grid {
                display: flex;
                gap: 20px;
                overflow-x: auto;
                padding-bottom: 20px;
                max-width: 100%;
                scroll-behavior: smooth;
            }
            .book-card {
                flex: 0 0 180px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                transition: box-shadow 0.3s ease, transform 0.3s ease;
                cursor: pointer;
                display: flex;
                flex-direction: column;
                user-select: none;
            }
            .book-card:hover {
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
                transform: translateY(-3px);
            }
            .book-card img {
                width: 100%;
                height: 240px;
                object-fit: cover;
                object-position: center;
                display: block;
            }
            .book-info {
                padding: 16px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            .book-title {
                font-size: 1.15rem;
                font-weight: 600;
                color: #1e40af;
                margin: 0 0 6px 0;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .book-author {
                margin: 0;
                color: #475569;
                font-weight: 500;
                font-size: 0.85rem;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .book-details {
                margin-top: 12px;
                display: flex;
                justify-content: space-between;
                font-weight: 600;
                font-size: 0.9rem;
                color: #334155;
            }

            /* Charts container */
            .chart-container {
                background: white;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                margin-bottom: 32px;
            }
            .chart-header {
                text-align: center;
                padding: 20px;
                background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
                color: white;
                border-radius: 12px 12px 0 0;
                margin: -24px -24px 24px -24px;
            }
            .chart-header h4 {
                margin: 0;
                font-size: 1.5rem;
                font-weight: 600;
            }
            .chart-header p {
                margin-top: 8px;
                font-size: 1rem;
                color: #f3f4f6;
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
                .summary-cards {
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                }
                .modal-content {
                    width: 90%;
                    margin: 5% auto;
                }
            }

            /* Hide scrollbars for books grid */
            .books-grid::-webkit-scrollbar {
                height: 8px;
            }
            .books-grid::-webkit-scrollbar-track {
                background: transparent;
            }
            .books-grid::-webkit-scrollbar-thumb {
                background-color: rgba(181, 149, 216, 0.5);
                border-radius: 10px;
            }
            .books-grid {
                scrollbar-width: thin;
                scrollbar-color: rgba(181, 149, 216, 0.5) transparent;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <aside class="sidebar">
            <h2 class="logo">🏠 Pahana Bookshop</h2>
            <nav>
                <a href="#" class="active" data-target="dashboardSection">📊 Dashboard</a>
                <a href="#" data-target="customersSection">👥 Customers</a>
                <a href="#" data-target="usersSection">🧑 Users</a>
                <a href="#" data-target="booksSection">📚 Books</a>
                <a href="#" data-target="pastBillsSection">📋 Bill History</a>
                <a href="#" data-target="helpSection">❓ Help & Guide</a>
                <a href="login.jsp" class="logout">🔓 Logout</a>

                <div class="sidebar-footer">
                    <div class="clock">
                        <span style="font-size: 1.2rem;">🕒</span>
                        <span id="sidebarClock">--:--:--</span>
                    </div>
                    <div class="note">⚠️ Backup your data daily!</div>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main">
            <h2 class="page-title">Admin Panel</h2>

            <!-- Dashboard Section -->
            <section id="dashboardSection" class="card active-section">
                <h3>Dashboard Overview</h3>

                <!-- Summary Cards -->
                <div class="summary-cards">
                    <div class="summary-card">
                        <h4>Total Customers</h4>
                        <p class="count"><%= customers != null ? customers.size() : 0%></p>
                        <small>Registered customers</small>
                    </div>
                    <div class="summary-card" style="background: #0f766e; color: #d1fae5;">
                        <h4 style="color: inherit;">Total Users</h4>
                        <p class="count" style="color: inherit;"><%= users != null ? users.size() : 0%></p>
                        <small style="opacity: 0.9;">System users</small>
                    </div>
                    <div class="summary-card" style="background: #fbbf24; color: #78350f;">
                        <h4 style="color: inherit;">Total Books</h4>
                        <p class="count" style="color: inherit;"><%= books != null ? books.size() : 0%></p>
                        <small style="opacity: 0.9;">Books in inventory</small>
                    </div>
                    <div class="summary-card" style="background: #dc2626; color: #fee2e2;">
                        <h4 style="color: inherit;">Active Users</h4>
                        <p class="count" style="color: inherit;"><%= users != null ? users.stream().filter(u -> "ACTIVE".equals(u.getStatus())).count() : 0%></p>
                        <small style="opacity: 0.9;">Users currently active</small>
                    </div>
                </div>

                <!-- Book Inventory -->
                <h3>Book Inventory</h3>
                <div class="books-grid">
                    <% if (books != null && !books.isEmpty()) {
                            for (Book b : books) {%>
                    <div class="book-card">
                        <img src="<%= (b.getImageUrl() != null && !b.getImageUrl().isEmpty()) ? b.getImageUrl() : "https://via.placeholder.com/280x350?text=No+Image"%>" 
                             alt="<%= b.getTitle()%>">
                        <div class="book-info">
                            <div>
                                <h5 class="book-title"><%= b.getTitle()%></h5>
                                <p class="book-author"><%= b.getAuthor()%></p>
                            </div>
                            <div class="book-details">
                                <span>Stock: <%= b.getStock()%></span>
                                <span>Rs.<%= String.format("%.2f", b.getPrice())%></span>
                            </div>
                        </div>
                    </div>
                    <%  }
                    } else { %>
                    <p style="color:#6b7280; font-style: italic;">No books found.</p>
                    <% } %>
                </div>

                <!-- Charts Container -->
                <div style="
                     padding-top: 20px;
                     display: flex;
                     flex-wrap: wrap;
                     justify-content: center;
                     gap: 2rem;
                     background: white;
                     padding: 1.25rem;
                     border-radius: 0 0 1rem 1rem;
                     box-shadow: 0 8px 20px rgb(0 0 0 / 0.07);
                     max-width: 100%;
                     margin-bottom: 3rem;
                     ">
                    <canvas 
                        id="barChart" 
                        width="320" 
                        height="160" 
                        style="
                        border-radius: 1rem;
                        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                        flex-grow: 1;
                        max-width: 90%;
                        background: #f9fafb;
                        user-select: none;
                        "
                        ></canvas>
                </div>

            </section>

            <!-- Customers Section -->
            <section id="customersSection" class="card" style="display:none;">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>Manage Customers</h3>
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
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Customer c : customers) {%>
                        <tr data-customer-id="<%= c.getId()%>" 
                            data-name="<%= c.getName() != null ? c.getName().replace("\"", "&quot;") : ""%>" 
                            data-phone="<%= c.getPhone() != null ? c.getPhone().replace("\"", "&quot;") : ""%>">
                            <td><%= c.getId()%></td>
                            <td><%= c.getName()%></td>
                            <td><%= c.getPhone()%></td>
                            <td><%= c.getEmail()%></td>
                            <td><%= c.getAddress()%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p style="color:#6b7280; font-style: italic;">No customers found.</p>
                <% } %>
            </section>

            <!-- Users Section -->
            <section id="usersSection" class="card" style="display:none;">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>Manage Users</h3>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style = "min-width: 400px">
                            <input 
                                type="text" 
                                id="userSearch" 
                                placeholder="Search user by user name or role..." 
                                oninput="filterUsers()"
                                style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                                onfocus="this.style.borderColor = '#E8D5F2';"
                                onblur="this.style.borderColor = '#E8D5F2';"
                                />
                        </div>

                        <button class="add-btn" onclick="openModal('userModal')">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" width="20" height="20">
                            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                            </svg>
                            Add User
                        </button>
                    </div>
                </div>

                <% if (users != null && !users.isEmpty()) { %>
                <table id="usersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Created Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : users) {%>
                        <tr data-user-id="<%= u.getId()%>"
                            data-username="<%= u.getUsername()%>"
                            data-role="<%= u.getRole()%>"
                            data-status="<%= u.getStatus()%>">
                            <td><%= u.getId()%></td>
                            <td><%= u.getUsername()%></td>
                            <td><%= u.getRole()%></td>
                            <td><%= u.getStatus()%></td>
                            <td><%= u.getCreatedDate()%></td>
                            <td>
                                <button class="action-btn edit" onclick="openEditUserModal(this, '<%= u.getPassword()%>')">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                    </svg>
                                    Edit
                                </button>
                                <button class="action-btn delete" onclick="confirmDelete('user', '<%= u.getId()%>')">
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
                <p style="color:#6b7280; font-style: italic;">No users found.</p>
                <% } %>
            </section>

            <!-- Books Section -->
            <section id="booksSection" class="card" style="display:none;">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>Manage Books</h3>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style = "min-width: 400px">
                            <input 
                                type="text" 
                                id="bookSearch" 
                                placeholder="Search book by title, author or category..." 
                                oninput="filterBooks()"
                                style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                                onfocus="this.style.borderColor = '#E8D5F2';"
                                onblur="this.style.borderColor = '#E8D5F2';"
                                />
                        </div>
                        <button class="add-btn" onclick="openModal('bookModal')">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" width="20" height="20">
                            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                            </svg>
                            Add Book
                        </button>
                    </div>
                </div>

                <% if (books != null && !books.isEmpty()) { %>
                <table id="booksTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Stock</th>
                            <th>Publisher</th>
                            <th>Year</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Book b : books) {%>
                        <tr data-book-id="<%= b.getId()%>"
                            data-title="<%= b.getTitle()%>"
                            data-author="<%= b.getAuthor()%>"
                            data-category="<%= b.getCategory()%>"
                            data-stock="<%= b.getStock()%>"
                            data-publisher="<%= b.getPublisher()%>"
                            data-year="<%= b.getYear()%>"
                            data-price="<%= b.getPrice()%>"
                            data-url="<%= b.getImageUrl()%>"
                            >
                            <td><%= b.getId()%></td>
                            <td><%= b.getTitle()%></td>
                            <td><%= b.getAuthor()%></td>
                            <td><%= b.getCategory()%></td>
                            <td><%= b.getStock()%></td>
                            <td><%= b.getPublisher()%></td>
                            <td><%= b.getYear()%></td>
                            <td>Rs.<%= b.getPrice()%></td>
                            <td>
                                <button class="action-btn edit" onclick="openEditBookModal(this)">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                    </svg>
                                    Edit
                                </button>
                                <button class="action-btn delete" onclick="confirmDelete('book', <%= b.getId()%>)">
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
                <p style="color:#6b7280; font-style: italic;">No books found.</p>
                <% }%>
            </section>
            
              <!-- Past Bills Section -->
            <section id="pastBillsSection" class="card" style="display:none;">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>Past Bills</h3>
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

            <!-- Help Section -->
            <section id="helpSection" class="card" style="display:none;">
                <h3>📖 Help & User Guide</h3>

                <!-- Quick Navigation -->
                <div style="background: #f8fafc; border-radius: 8px; padding: 20px; margin-bottom: 24px; border-left: 4px solid #B595D8;">
                    <h4 style="color: #1e40af; margin-top: 0; margin-bottom: 12px; font-size: 1.1rem;">Quick Navigation</h4>
                    <div style="display: flex; flex-wrap: wrap; gap: 12px;">
                        <button onclick="scrollToSection('getting-started')" style="background: #E8D5F2; border: none; padding: 8px 16px; border-radius: 6px; color: #374151; font-weight: 600; cursor: pointer; transition: background 0.2s;">Getting Started</button>
                        <button onclick="scrollToSection('dashboard-guide')" style="background: #E8D5F2; border: none; padding: 8px 16px; border-radius: 6px; color: #374151; font-weight: 600; cursor: pointer; transition: background 0.2s;">Dashboard Guide</button>
                        <button onclick="scrollToSection('user-management')" style="background: #E8D5F2; border: none; padding: 8px 16px; border-radius: 6px; color: #374151; font-weight: 600; cursor: pointer; transition: background 0.2s;">User Management</button>
                        <button onclick="scrollToSection('book-management')" style="background: #E8D5F2; border: none; padding: 8px 16px; border-radius: 6px; color: #374151; font-weight: 600; cursor: pointer; transition: background 0.2s;">Book Management</button>
                        <button onclick="scrollToSection('troubleshooting')" style="background: #E8D5F2; border: none; padding: 8px 16px; border-radius: 6px; color: #374151; font-weight: 600; cursor: pointer; transition: background 0.2s;">Troubleshooting</button>
                        <button onclick="scrollToSection('shortcuts')" style="background: #E8D5F2; border: none; padding: 8px 16px; border-radius: 6px; color: #374151; font-weight: 600; cursor: pointer; transition: background 0.2s;">Keyboard Shortcuts</button>
                    </div>
                </div>

                <!-- Getting Started Section -->
                <div id="getting-started" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #1e40af; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        🚀 Getting Started
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">
                        <p><strong>Welcome to Pahana Bookshop Admin Panel!</strong> This guide will help you navigate and use all features effectively.</p>

                        <h5 style="color: #374151; margin-top: 20px;">First Steps:</h5>
                        <ol style="padding-left: 20px;">
                            <li><strong>Dashboard Overview:</strong> Start with the Dashboard to get a quick overview of your bookshop's current status</li>
                            <li><strong>Navigation:</strong> Use the sidebar menu to switch between different sections</li>
                            <li><strong>Search & Filter:</strong> Each section has search functionality to quickly find what you're looking for</li>
                            <li><strong>Real-time Clock:</strong> Check the current time displayed in the sidebar footer</li>
                        </ol>

                        <div style="background: #fef3c7; border-left: 4px solid #fbbf24; padding: 12px 16px; border-radius: 4px; margin-top: 16px;">
                            <strong>💡 Pro Tip:</strong> Always backup your data regularly as shown in the sidebar reminder!
                        </div>
                    </div>
                </div>

                <!-- Dashboard Guide -->
                <div id="dashboard-guide" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #1e40af; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        📊 Dashboard Guide
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">
                        <p>The Dashboard provides a comprehensive overview of your bookshop's key metrics and inventory.</p>

                        <h5 style="color: #374151; margin-top: 20px;">Dashboard Components:</h5>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px; margin-top: 12px;">
                            <div style="background: #f1f5f9; padding: 16px; border-radius: 6px;">
                                <strong>📈 Summary Cards</strong>
                                <p style="margin: 8px 0 0 0; font-size: 14px;">View total customers, users, books, and active users at a glance</p>
                            </div>
                            <div style="background: #f1f5f9; padding: 16px; border-radius: 6px;">
                                <strong>📚 Book Inventory</strong>
                                <p style="margin: 8px 0 0 0; font-size: 14px;">Horizontal scrollable gallery showing all books with stock and pricing</p>
                            </div>
                            <div style="background: #f1f5f9; padding: 16px; border-radius: 6px;">
                                <strong>📊 Visual Charts</strong>
                                <p style="margin: 8px 0 0 0; font-size: 14px;">Interactive bar chart displaying system statistics</p>
                            </div>
                        </div>

                        <div style="background: #dbeafe; border-left: 4px solid #2563eb; padding: 12px 16px; border-radius: 4px; margin-top: 16px;">
                            <strong>📌 Remember:</strong> The dashboard auto-updates when you make changes to users, books, or customers.
                        </div>
                    </div>
                </div>

                <!-- User Management Guide -->
                <div id="user-management" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #1e40af; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        👥 User Management Guide
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">
                        <h5 style="color: #374151; margin-top: 16px;">Managing System Users:</h5>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>➕ Adding New Users:</strong>
                            <ol style="margin: 8px 0 0 20px;">
                                <li>Click the "Add User" button in the Users section</li>
                                <li>Fill in the required information: Username, Password, Role, Status</li>
                                <li>Choose from available roles: Admin, Stock Keeper, or Cashier</li>
                                <li>Set status as Active or Inactive</li>
                                <li>Click "Save User" to create the account</li>
                            </ol>
                        </div>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>✏️ Editing Users:</strong>
                            <ul style="margin: 8px 0 0 20px;">
                                <li>Click the "Edit" button next to any user in the table</li>
                                <li>Modify the necessary information</li>
                                <li>Password field will show the current password</li>
                                <li>Save changes to update the user account</li>
                            </ul>
                        </div>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>🔍 Searching Users:</strong>
                            <p style="margin: 8px 0 0 0;">Use the search bar to find users by username or role. The search is real-time and case-insensitive.</p>
                        </div>

                        <div style="background: #fee2e2; border-left: 4px solid #ef4444; padding: 12px 16px; border-radius: 4px; margin-top: 16px;">
                            <strong>⚠️ Warning:</strong> Deleting a user is permanent and cannot be undone. Make sure to backup data before deletion.
                        </div>
                    </div>
                </div>

                <!-- Book Management Guide -->
                <div id="book-management" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #1e40af; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        📚 Book Management Guide
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">
                        <h5 style="color: #374151; margin-top: 16px;">Managing Book Inventory:</h5>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>➕ Adding New Books:</strong>
                            <ol style="margin: 8px 0 0 20px;">
                                <li>Click "Add Book" button in the Books section</li>
                                <li>Fill in all required fields:
                                    <ul style="margin-top: 4px;">
                                        <li>Title, Author, Category</li>
                                        <li>Stock quantity (must be 0 or greater)</li>
                                        <li>Publisher, Publication Year</li>
                                        <li>Price (supports decimals like 29.99)</li>
                                        <li>Image URL for book cover</li>
                                    </ul>
                                </li>
                                <li>Click "Save Book" to add to inventory</li>
                            </ol>
                        </div>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>📝 Book Information Guidelines:</strong>
                            <ul style="margin: 8px 0 0 20px;">
                                <li><strong>Stock:</strong> Enter current available quantity</li>
                                <li><strong>Price:</strong> Use format like 25.00 or 199.50</li>
                                <li><strong>Year:</strong> Publication year between 1900-2100</li>
                                <li><strong>Image URL:</strong> Direct link to book cover image</li>
                                <li><strong>Category:</strong> Use consistent naming (Fiction, Non-Fiction, etc.)</li>
                            </ul>
                        </div>

                        <div style="background: #f0fdf4; border-left: 4px solid #22c55e; padding: 12px 16px; border-radius: 4px; margin-top: 16px;">
                            <strong>✅ Best Practice:</strong> Regularly update stock quantities and use high-quality cover images for better presentation.
                        </div>
                    </div>
                </div>

                <!-- Customer Management Guide -->
                <div id="customer-management" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #1e40af; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        👤 Customer Management Guide
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">
                        <p>View and manage your bookshop's customer database efficiently.</p>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>🔍 Search Functionality:</strong>
                            <ul style="margin: 8px 0 0 20px;">
                                <li>Search by customer name or phone number</li>
                                <li>Real-time filtering as you type</li>
                                <li>Case-insensitive search</li>
                            </ul>
                        </div>

                        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin: 12px 0;">
                            <strong>👁️ Customer Information:</strong>
                            <p style="margin: 8px 0 0 0;">View complete customer details including ID, name, phone, email, and address in an organized table format.</p>
                        </div>
                    </div>
                </div>

                <!-- Troubleshooting Section -->
                <div id="troubleshooting" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #dc2626; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        🔧 Troubleshooting & FAQ
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">

                        <div style="margin-bottom: 20px;">
                            <h5 style="color: #374151;">Common Issues & Solutions:</h5>

                            <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #dc2626;">❌ Problem:</strong> Cannot see newly added books/users
                                <br>
                                <strong style="color: #059669;">✅ Solution:</strong> Refresh the page (F5) or navigate away and back to the section
                            </div>

                            <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #dc2626;">❌ Problem:</strong> Search not working properly
                                <br>
                                <strong style="color: #059669;">✅ Solution:</strong> Clear the search field and try again. Ensure you're typing in the correct search box for each section.
                            </div>

                            <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #dc2626;">❌ Problem:</strong> Modal/popup windows won't close
                                <br>
                                <strong style="color: #059669;">✅ Solution:</strong> Click the "×" button, press Escape key, or click outside the modal window
                            </div>

                            <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #dc2626;">❌ Problem:</strong> Charts not displaying
                                <br>
                                <strong style="color: #059669;">✅ Solution:</strong> Ensure JavaScript is enabled in your browser and refresh the page
                            </div>
                        </div>

                        <div style="margin-bottom: 20px;">
                            <h5 style="color: #374151;">Frequently Asked Questions:</h5>

                            <div style="background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #0369a1;">Q: How do I backup my data?</strong>
                                <br>
                                <span style="color: #374151;">A: Contact your system administrator for database backup procedures. Regular backups should be performed daily as reminded in the sidebar.</span>
                            </div>

                            <div style="background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #0369a1;">Q: Can I undo a delete operation?</strong>
                                <br>
                                <span style="color: #374151;">A: No, deletions are permanent. Always confirm before deleting and ensure you have recent backups.</span>
                            </div>

                            <div style="background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #0369a1;">Q: What image formats are supported for book covers?</strong>
                                <br>
                                <span style="color: #374151;">A: Standard web formats like JPG, PNG, and GIF are supported. Ensure the image URL is publicly accessible.</span>
                            </div>

                            <div style="background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 6px; padding: 16px; margin: 12px 0;">
                                <strong style="color: #0369a1;">Q: How do I change user passwords?</strong>
                                <br>
                                <span style="color: #374151;">A: Edit the user and enter a new password in the password field. The system will update it when you save.</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Keyboard Shortcuts -->
                <div id="shortcuts" style="background: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <h4 style="color: #1e40af; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        ⌨️ Keyboard Shortcuts
                    </h4>
                    <div style="color: #4b5563; line-height: 1.6;">
                        <p>Speed up your workflow with these keyboard shortcuts:</p>

                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 16px; margin-top: 16px;">
                            <div style="background: #f8fafc; padding: 16px; border-radius: 6px;">
                                <h5 style="color: #374151; margin-top: 0;">General Shortcuts:</h5>
                                <div style="font-family: monospace; font-size: 14px;">
                                    <div style="margin: 8px 0;"><kbd style="background: #e2e8f0; padding: 2px 6px; border-radius: 3px;">F5</kbd> - Refresh page</div>
                                    <div style="margin: 8px 0;"><kbd style="background: #e2e8f0; padding: 2px 6px; border-radius: 3px;">Ctrl + F</kbd> - Browser search</div>
                                    <div style="margin: 8px 0;"><kbd style="background: #e2e8f0; padding: 2px 6px; border-radius: 3px;">Escape</kbd> - Close modal</div>
                                </div>
                            </div>

                            <div style="background: #f8fafc; padding: 16px; border-radius: 6px;">
                                <h5 style="color: #374151; margin-top: 0;">Form Shortcuts:</h5>
                                <div style="font-family: monospace; font-size: 14px;">
                                    <div style="margin: 8px 0;"><kbd style="background: #e2e8f0; padding: 2px 6px; border-radius: 3px;">Tab</kbd> - Next field</div>
                                    <div style="margin: 8px 0;"><kbd style="background: #e2e8f0; padding: 2px 6px; border-radius: 3px;">Shift + Tab</kbd> - Previous field</div>
                                    <div style="margin: 8px 0;"><kbd style="background: #e2e8f0; padding: 2px 6px; border-radius: 3px;">Enter</kbd> - Submit form</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- System Information -->
                <div style="background: #1f2937; color: #f9fafb; border-radius: 8px; padding: 24px; margin-bottom: 20px;">
                    <h4 style="color: #60a5fa; display: flex; align-items: center; gap: 8px; margin-top: 0;">
                        ℹ️ System Information
                    </h4>
                    <div style="line-height: 1.6;">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 16px;">
                            <div>
                                <strong>🏢 System:</strong> Pahana Bookshop Admin Panel<br>
                                <strong>⚡ Version:</strong> 1.0.0<br>
                                <strong>🌐 Technology:</strong> Java JSP, HTML5, CSS3, JavaScript
                            </div>
                            <div>
                                <strong>📱 Responsive:</strong> Mobile & Desktop Compatible<br>
                                <strong>🎨 UI Framework:</strong> Custom CSS with Chart.js<br>
                                <strong>🔧 Browser Support:</strong> Chrome, Firefox, Safari, Edge
                            </div>
                        </div>

                        <div style="background: rgba(96, 165, 250, 0.1); border-left: 4px solid #60a5fa; padding: 12px 16px; border-radius: 4px; margin-top: 16px;">
                            <strong>📞 Support:</strong> For technical support or system issues, contact your system administrator or IT department.
                        </div>
                    </div>
                </div>

                <!-- Contact & Support -->
                <div style="background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8); color: #ffffff; border-radius: 8px; padding: 24px; text-align: center;">
                    <h4 style="margin-top: 0; font-size: 1.3rem;">💬 Need More Help?</h4>
                    <p style="margin: 16px 0; font-size: 1.1rem;">If you couldn't find the answer to your question in this guide:</p>
                    <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap; margin-top: 20px;">
                        <div style="background: rgba(255,255,255,0.2); padding: 16px; border-radius: 8px; min-width: 200px;">
                            <strong>📧 Email Support</strong><br>
                            <span style="opacity: 0.9;">admin@pahanabookshop.lk</span>
                        </div>
                        <div style="background: rgba(255,255,255,0.2); padding: 16px; border-radius: 8px; min-width: 200px;">
                            <strong>📞 Phone Support</strong><br>
                            <span style="opacity: 0.9;">+94 11 234 5678</span>
                        </div>
                        <div style="background: rgba(255,255,255,0.2); padding: 16px; border-radius: 8px; min-width: 200px;">
                            <strong>🕒 Business Hours</strong><br>
                            <span style="opacity: 0.9;">Mon-Fri: 8AM - 6PM</span>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <!-- MODALS -->

        <!-- Add/Edit Customer Modal -->
        <div id="customerModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('customerModal')">&times;</span>
                <h3 id="customerModalTitle">Add Customer</h3>
                <div class="error"></div>
                <form id="customerForm">
                    <input type="hidden" id="customerId" name="id" />
                    <label for="customerName">Name</label>
                    <input type="text" id="customerName" name="name" required />
                    <label for="customerPhone">Phone</label>
                    <input type="text" id="customerPhone" name="phone" required />
                    <label for="customerEmail">Email</label>
                    <input type="email" id="customerEmail" name="email" required />
                    <label for="customerAddress">Address</label>
                    <textarea id="customerAddress" name="address" rows="3"></textarea>
                    <button type="submit">Save Customer</button>
                </form>
            </div>
        </div>

        <!-- Add/Edit User Modal -->
        <div id="userModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('userModal')">&times;</span>
                <h3 id="userModalTitle">Add User</h3>
                <div class="error"></div>
                <form id="userForm" action="<%=request.getContextPath()%>/admin" method="post">
                    <input type="hidden" name="action" value="addUser"/>
                    <input type="hidden" id="userId" name="id" />
                    <label for="userUsername">Username</label>
                    <input type="text" id="userUsername" name="username" required />
                    <label for="userPassword">Password</label>
                    <input type="password" id="userPassword" name="password" required />
                    <label for="userRole">Role</label>
                    <select id="userRole" name="role" required>
                        <option value="">Select Role</option>
                        <option value="admin">Admin</option>
                        <option value="stock_keeper">Stock Keeper</option>
                        <option value="cashier">Cashier</option>
                    </select>
                    <label for="userStatus">Status</label>
                    <select id="userStatus" name="status" required>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                    <button type="submit">Save User</button>
                </form>
            </div>
        </div>

        <!-- Add/Edit Book Modal -->
        <div id="bookModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('bookModal')">&times;</span>
                <h3 id="bookModalTitle">Add Book</h3>
                <div class="error"></div>
                <form id="bookForm" action="<%=request.getContextPath()%>/books", method="POST">
                    <input type="hidden" id="bookId" name="id" />
                    <label for="bookTitle">Title</label>
                    <input type="text" id="bookTitle" name="title" required />
                    <label for="bookAuthor">Author</label>
                    <input type="text" id="bookAuthor" name="author" required />
                    <label for="bookCategory">Category</label>
                    <input type="text" id="bookCategory" name="category" required />
                    <label for="bookStock">Stock</label>
                    <input type="number" id="bookStock" name="stock" min="0" required />
                    <label for="bookPublisher">Publisher</label>
                    <input type="text" id="bookPublisher" name="publisher" required />
                    <label for="bookYear">Year</label>
                    <input type="number" id="bookYear" name="year" min="1900" max="2100" required />
                    <label for="bookPrice">Price</label>
                    <input type="number" id="bookPrice" name="price" min="0" step="0.01" required />
                    <label for="bookURL">Image URL</label>
                    <input type="text" id="bookURL" name="url" required />
                    <button type="submit">Save Book</button>
                </form>
            </div>
        </div>

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
            // Search functionality
            function filterCustomers() {
                const query = document.getElementById('customerSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#customersTable tbody tr');
                rows.forEach(row => {
                    const name = row.dataset.name || '';
                    const phone = row.dataset.phone || '';
                    const visible = name.includes(query) || phone.includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }

            function filterUsers() {
                const query = document.getElementById('userSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#usersTable tbody tr');
                rows.forEach(row => {
                    const username = row.dataset.username || '';
                    const role = row.dataset.role || '';
                    const visible = username.includes(query) || role.includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }

            function filterBooks() {
                const query = document.getElementById('bookSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#booksTable tbody tr');
                rows.forEach(row => {
                    const title = row.dataset.title || '';
                    const author = row.dataset.author || '';
                    const category = row.dataset.category || '';
                    const publisher = row.dataset.publisher || '';
                    const year = row.dataset.year || '';
                    const price = row.dataset.price || '';
                    const visible = title.includes(query) || author.includes(query) || category.includes(query) || publisher.includes(query) || year.includes(query) || price.includes(query);
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

            // Modal functions
            function openModal(modalId) {
                document.getElementById(modalId).style.display = 'block';
                // Clear form and reset title for add operations
                if (modalId === 'customerModal') {
                    document.getElementById('customerModalTitle').innerText = 'Add Customer';
                    document.getElementById('customerForm').reset();
                    document.getElementById('customerId').value = '';
                } else if (modalId === 'userModal') {
                    document.getElementById('userModalTitle').innerText = 'Add User';
                    document.getElementById('userForm').reset();
                    document.getElementById('userId').value = '';
                } else if (modalId === 'bookModal') {
                    document.getElementById('bookModalTitle').innerText = 'Add Book';
                    document.getElementById('bookForm').reset();
                    document.getElementById('bookId').value = '';
                }
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            // Edit modal functions
            function openEditCustomerModal(button) {
                const tr = button.closest('tr');
                document.getElementById('customerModalTitle').innerText = 'Edit Customer';
                document.getElementById('customerId').value = tr.getAttribute('data-customer-id');
                document.getElementById('customerName').value = tr.getAttribute('data-name');
                document.getElementById('customerPhone').value = tr.getAttribute('data-phone');
                document.getElementById('customerEmail').value = tr.getAttribute('data-email');
                document.getElementById('customerAddress').value = tr.getAttribute('data-address');
                openModal('customerModal');
            }

            function openEditUserModal(button, password) {
                const tr = button.closest('tr');
                openModal('userModal');
                document.getElementById('userModalTitle').innerText = 'Edit User';
                document.getElementById('userId').value = tr.getAttribute('data-user-id');
                document.getElementById('userUsername').value = tr.getAttribute('data-username');
                document.getElementById('userPassword').value = password;
                document.getElementById('userRole').value = tr.getAttribute('data-role').toLowerCase();
                document.getElementById('userStatus').value = tr.getAttribute('data-status').toLowerCase();

            }

            function openEditBookModal(button) {
                const tr = button.closest('tr');
                openModal('bookModal');
                document.getElementById('bookModalTitle').innerText = 'Edit Book';
                document.getElementById('bookId').value = tr.getAttribute('data-book-id');
                document.getElementById('bookTitle').value = tr.getAttribute('data-title');
                document.getElementById('bookAuthor').value = tr.getAttribute('data-author');
                document.getElementById('bookCategory').value = tr.getAttribute('data-category');
                document.getElementById('bookStock').value = tr.getAttribute('data-stock');
                document.getElementById('bookPublisher').value = tr.getAttribute('data-publisher');
                document.getElementById('bookYear').value = tr.getAttribute('data-year');
                document.getElementById('bookPrice').value = tr.getAttribute('data-price');
                document.getElementById('bookURL').value = tr.getAttribute('data-url');
            }

            // Delete confirmation
            function confirmDelete(type, id) {
                if (confirm('Are you sure you want to delete this ' + type + '?')) {
                    const form = document.getElementById('deleteForm');
                    let capitalizedType = type.charAt(0).toUpperCase() + type.slice(1);
                    document.getElementById('deleteAction').value = "delete" + capitalizedType;
                    document.getElementById('deleteId').value = id;
                    form.submit();
                }
            }

            // Form submissions
            document.getElementById('customerForm').addEventListener('submit', function (e) {
                e.preventDefault();
                const errorDiv = this.querySelector('.error');
                errorDiv.classList.remove('show');
                const id = document.getElementById('customerId').value;
                const name = document.getElementById('customerName').value.trim();
                const phone = document.getElementById('customerPhone').value.trim();
                const email = document.getElementById('customerEmail').value.trim();
                const address = document.getElementById('customerAddress').value.trim();
                // Basic validation
                if (!name) {
                    errorDiv.textContent = 'Name is required.';
                    errorDiv.classList.add('show');
                    return;
                }

                if (id) {
                    // Edit existing row
                    let row = document.querySelector(`tr[data-customer-id="${id}"]`);
                    if (row) {
                        row.setAttribute('data-name', name);
                        row.setAttribute('data-phone', phone);
                        row.setAttribute('data-email', email);
                        row.setAttribute('data-address', address);
                        row.cells[1].innerText = name;
                        row.cells[2].innerText = phone;
                        row.cells[3].innerText = email;
                        row.cells[4].innerText = address;
                    }
                } else {
                    // Add new row (simple demo - in real app this would go to server)
                    const tbody = document.querySelector('#customersTable tbody');
                    if (tbody) {
                        const newId = Date.now();
                        const tr = document.createElement('tr');
                        tr.setAttribute('data-customer-id', newId);
                        tr.setAttribute('data-name', name);
                        tr.setAttribute('data-phone', phone);
                        tr.setAttribute('data-email', email);
                        tr.setAttribute('data-address', address);
                        tr.innerHTML = `
                            <td>${newId}</td>
                            <td>${name}</td>
                            <td>${phone}</td>
                            <td>${email}</td>
                            <td>${address}</td>
                            <td>
                                <button class="action-btn edit" onclick="openEditCustomerModal(this)">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                        <path d="M12 20h9"/>
                                    </svg>
                                    Edit
                                </button>
                                <button class="action-btn delete" onclick="confirmDelete('customer', ${newId})">
                                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                        <path d="M3 6h18"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/>
                                    </svg>
                                    Delete
                                </button>
                            </td>
                        `;
                        tbody.appendChild(tr);
                    }
                }

                closeModal('customerModal');
                this.reset();
            });
            // Close modals when clicking outside
            window.addEventListener('click', function (e) {
                if (e.target.classList.contains('modal')) {
                    e.target.style.display = 'none';
                }
            });
            // Chart initialization
            window.addEventListener('load', () => {
                const dataCounts = {
                    customers: <%= customers != null ? customers.size() : 0%>,
                    users: <%= users != null ? users.size() : 0%>,
                    books: <%= books != null ? books.size() : 0%>,
                    activeUsers: <%= users != null ? users.stream().filter(u -> "active".equals(u.getStatus())).count() : 0%>
                };
                const ctx = document.getElementById('barChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ['Customers', 'Users', 'Books', 'Active Users'],
                        datasets: [{
                                label: 'Count',
                                data: Object.values(dataCounts),
                                backgroundColor: [
                                    '#B595D8', // Purple theme color
                                    '#0f766e', // Teal
                                    '#fbbf24', // Amber
                                    '#dc2626'  // Red
                                ],
                                borderRadius: 8,
                                borderSkipped: false,
                                maxBarThickness: 50,
                                hoverBackgroundColor: [
                                    '#A584C7',
                                    '#115e59',
                                    '#b45309',
                                    '#991b1b'
                                ]
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            duration: 1200,
                            easing: 'easeOutQuart'
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1,
                                    color: '#334155',
                                    font: {
                                        family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
                                        weight: '600',
                                        size: 13
                                    }
                                },
                                grid: {
                                    color: 'rgba(203, 213, 225, 0.3)',
                                    borderDash: [5, 5]
                                }
                            },
                            x: {
                                ticks: {
                                    color: '#475569',
                                    font: {
                                        family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
                                        weight: '600',
                                        size: 13
                                    }
                                },
                                grid: {
                                    display: false
                                }
                            }
                        },
                        plugins: {
                            legend: {display: false},
                            tooltip: {
                                backgroundColor: '#B595D8',
                                titleFont: {weight: '700', size: 14},
                                bodyFont: {weight: '500', size: 12},
                                cornerRadius: 6,
                                padding: 10
                            }
                        }
                    }
                });
            });
        </script>

        <script>
            window.onload = () => {
                // Get data safely from JSP variables
                const dataCounts = {
                    customers: <%= customers != null ? customers.size() : 0%>,
                    users: <%= users != null ? users.size() : 0%>,
                    books: <%= books != null ? books.size() : 0%>,
                    activeUsers: <%= users != null ? users.stream().filter(u -> "active".equals(u.getStatus())).count() : 0%>
                };
                const ctx = document.getElementById('barChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ['Customers', 'Users', 'Books', 'Active Users'],
                        datasets: [{
                                label: 'Count',
                                data: Object.values(dataCounts),
                                backgroundColor: [
                                    '#2563eb', // Blue
                                    '#0f766e', // Teal
                                    '#fbbf24', // Amber
                                    '#dc2626'  // Red
                                ],
                                borderRadius: 8,
                                borderSkipped: false,
                                maxBarThickness: 50,
                                hoverBackgroundColor: [
                                    '#1e40af',
                                    '#115e59',
                                    '#b45309',
                                    '#991b1b'
                                ],
                                // Add shadow to bars
                                segment: {
                                    borderWidth: 1,
                                    borderColor: '#ffffff'
                                }
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            duration: 1200,
                            easing: 'easeOutQuart'
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1,
                                    color: '#334155',
                                    font: {
                                        family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
                                        weight: '600',
                                        size: 13
                                    }
                                },
                                grid: {
                                    color: 'rgba(203, 213, 225, 0.3)',
                                    borderDash: [5, 5]
                                }
                            },
                            x: {
                                ticks: {
                                    color: '#475569',
                                    font: {
                                        family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
                                        weight: '600',
                                        size: 13
                                    }
                                },
                                grid: {
                                    display: false
                                }
                            }
                        },
                        plugins: {
                            legend: {display: false},
                            tooltip: {
                                backgroundColor: '#2563eb',
                                titleFont: {weight: '700', size: 14},
                                bodyFont: {weight: '500', size: 12},
                                cornerRadius: 6,
                                padding: 10
                            }
                        }
                    }
                });
            };
            function updateClock() {
                const now = new Date();
                const formattedTime = now.toLocaleTimeString();
                document.getElementById('sidebarClock').textContent = formattedTime;
            }

            // Initial call
            updateClock();
            // Update every second
            setInterval(updateClock, 1000);
            // Filter customers in table by search input
            function filterCustomers() {
                const query = document.getElementById('customerSearch').value.toLowerCase().trim();
                const rows = document.querySelectorAll('#customersTable tbody tr');
                rows.forEach(row => {
                    const name = (row.dataset.name || '').toLowerCase();
                    const phone = (row.dataset.phone || '').toLowerCase();
                    const visible = name.includes(query) || phone.includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }
        </script>
        <script>
            window.addEventListener('load', () => {
                console.log('Page loaded or reloaded. Current URL:', window.location.href);
            });

            // Smooth scroll function for help section navigation
            function scrollToSection(sectionId) {
                const section = document.getElementById(sectionId);
                if (section) {
                    section.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });

                    // Add a subtle highlight effect
                    section.style.boxShadow = '0 0 20px rgba(181, 149, 216, 0.3)';
                    section.style.transform = 'scale(1.02)';
                    section.style.transition = 'all 0.3s ease';

                    // Remove the highlight after 2 seconds
                    setTimeout(() => {
                        section.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
                        section.style.transform = 'scale(1)';
                    }, 2000);
                }
            }

// Add hover effects to navigation buttons
            document.addEventListener('DOMContentLoaded', function () {
                const navButtons = document.querySelectorAll('#helpSection button[onclick^="scrollToSection"]');
                navButtons.forEach(button => {
                    button.addEventListener('mouseenter', function () {
                        this.style.background = '#B595D8';
                        this.style.color = '#ffffff';
                    });

                    button.addEventListener('mouseleave', function () {
                        this.style.background = '#E8D5F2';
                        this.style.color = '#374151';
                    });
                });
            });

        </script>
    </body>
</html>