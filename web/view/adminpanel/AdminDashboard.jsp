<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Customer" %>
<%@ page import="model.User" %>
<%@ page import="model.Book" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<User> users = (List<User>) request.getAttribute("users");
    List<Book> books = (List<Book>) request.getAttribute("books");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Admin Dashboard</title>
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
                        <p class="count" style="color: inherit;"><%= users != null ? users.stream().filter(u -> "active".equals(u.getStatus())).count() : 0%></p>
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
<!--                            <th>Actions</th>-->
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
<!--                            <td>
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
                            </td>-->
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
                        <tr data-username="<%= u.getUsername()%>"
                            data-role="<%= u.getRole()%>">
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
                        <tr data-title="<%= b.getTitle()%>"
                            data-author="<%= b.getAuthor()%>"
                            data-category="<%= b.getCategory()%>"
                            data-publisher="<%= b.getPublisher()%>"
                            data-year="<%= b.getYear()%>"
                            data-price="<%= b.getPrice()%>">
                            <td><%= b.getId()%></td>
                            <td><%= b.getTitle()%></td>
                            <td><%= b.getAuthor()%></td>
                            <td><%= b.getCategory()%></td>
                            <td><%= b.getStock()%></td>
                            <td><%= b.getPublisher()%></td>
                            <td><%= b.getYear()%></td>
                            <td>$<%= b.getPrice()%></td>
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
                <form id="bookForm">
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
                document.getElementById('bookModalTitle').innerText = 'Edit Book';
                document.getElementById('bookId').value = tr.getAttribute('data-book-id');
                document.getElementById('bookTitle').value = tr.getAttribute('data-title');
                document.getElementById('bookAuthor').value = tr.getAttribute('data-author');
                document.getElementById('bookCategory').value = tr.getAttribute('data-category');
                document.getElementById('bookStock').value = tr.getAttribute('data-stock');
                document.getElementById('bookPublisher').value = tr.getAttribute('data-publisher');
                document.getElementById('bookYear').value = tr.getAttribute('data-year');
                document.getElementById('bookPrice').value = tr.getAttribute('data-price');
                openModal('bookModal');
            }

            // Delete confirmation
            function confirmDelete(type, id) {
                if (confirm('Are you sure you want to delete this ' + type + '?')) {
                    // Here you would submit form or call server API to delete
                    /// alert(type + ' with ID ' + id + ' will be deleted (implement server logic)');
                    switch (type) {
                        case 'user':
                            const form = document.getElementById('deleteForm');
                            document.getElementById('deleteAction').value = 'deleteUser';
                            document.getElementById('deleteId').value = id;
                            form.submit(); // submit the form to AdminServlet
                        default:
                            return;
                    }

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

        </script>

    </body>
</html>