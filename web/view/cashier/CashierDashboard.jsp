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
    .sidebar nav a {
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
    .sidebar nav a:not(.logout):hover,
    .sidebar nav a.active {
        background: linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8);
        color: #374151;
    }
    .sidebar nav a.logout {
        margin-top: auto;
        background-color: #ef4444;
        color: #ffffff;
        font-weight: 700;
        text-align: left;
        border-radius: 6px;
        padding: 20px 16px;
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
    <h2 class="logo">🏠 Pahana Bookshop</h2>
    <nav>
        <a href="#" class="active" data-target="addCustomerSection">➕ Add Customer</a>
        <a href="#" data-target="customerListSection">👥 View Customers</a>
        <a href="#" data-target="generateBillSection">📜 Generate Bill</a> 
         <a href="#" data-target="pastBillsSection">📋 Bill History</a>
        <a href="#" class="logout">🔓 Logout</a>
    </nav>
</aside>

<!-- Main Content -->
<main class="main">
    <h2 class="page-title">Cashier Dashboard</h2>

    <!-- Add Customer Section -->
    <section id="addCustomerSection" class="card active-section">
        <h3>1. Add Customer</h3>
        <div class="error"></div>
        <form action="${pageContext.request.contextPath}/cashier" method="post" novalidate>
            <input type="hidden" name="action" value="addCustomer"/>
            <label for="name">Name *</label>
            <input id="name" name="name" type="text" pattern="[A-Za-z\s\-']{2,50}" required placeholder="Customer Full Name" />

            <label for="phone">Phone</label>
            <input id="phone" name="phone" type="text" pattern="0[0-9]{9}" placeholder="e.g. +94 77 123 4567" />

            <label for="email">Email</label>
            <input id="email" name="email" type="email" placeholder="example@email.com" />

            <label for="address">Address</label>
            <input id="address" name="address" type="text" placeholder="Customer Address" />

            <button type="submit">Save Customer</button>
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
                onfocus="this.style.borderColor='#E8D5F2';"
                onblur="this.style.borderColor='#E8D5F2';"
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
                <% for (Customer c : customers) { %>
                    <tr data-name="<%= c.getName() != null ? c.getName().replace("\"", "&quot;") : "" %>" 
                        data-phone="<%= c.getPhone() != null ? c.getPhone().replace("\"", "&quot;") : "" %>">
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
        <div class="error"></div>
        <form action="${pageContext.request.contextPath}/cashier" method="post">
            <input type="hidden" name="action" value="createBill"/>

            <!-- Select Customer Drop-down -->
            <label for="customerSelect">Select Customer *</label>
            <div style="position: relative; width: 100%; margin-bottom: 20px;">
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
                <div style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); pointer-events: none; color: #000000;">
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
                        for (Customer c : customers) { %>
                        <div class="customer-option" 
                             data-id="<%= c.getId() %>" 
                             data-name="<%= c.getName() != null ? c.getName().replace("\"", "&quot;") : "" %>" 
                             data-phone="<%= c.getPhone() != null ? c.getPhone().replace("\"", "&quot;") : "" %>"
                             onclick="selectCustomer(<%= c.getId() %>, '<%= c.getName() != null ? c.getName().replace("'", "\\'") : "" %>', '<%= c.getPhone() != null ? c.getPhone().replace("'", "\\'") : "" %>')"
                             style="
                                padding: 12px 14px; 
                                cursor: pointer; 
                                border-bottom: 1px solid #f3f4f6; 
                                transition: background-color 0.2s ease;
                             "
                             onmouseover="this.style.backgroundColor='#f3f4f6'" 
                             onmouseout="this.style.backgroundColor='white'">
                            <span style="font-weight: 600; color: #374151;"><%= c.getName() %></span>
                            <span style="color: #6b7280; margin-left: 8px;">- <%= c.getPhone() %></span>
                        </div>
                    <%  }
                    } else { %>
                        <div style="padding: 12px 14px; color: #6b7280; font-style: italic;">No customers available</div>
                    <% } %>
                </div>
            </div>

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
        <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
        <h3>4. Past Bills</h3>
        <div style="position: relative; min-width: 400px;">
            <input 
                type="text" 
                id="billSearch" 
                placeholder="Search bill by customer name or date..." 
                oninput="filterBills()"
                style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                onfocus="this.style.borderColor='#E8D5F2';"
                onblur="this.style.borderColor='#E8D5F2';"
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
                <% for (BillData bill : bills) { %>
                    <tr>
                <td><%= bill.billId %></td>
                <td><%= bill.customerName %></td>
                <td><%= sdf.format(bill.date) %></td>
                <td><%= String.format("%.2f", bill.total) %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/view/cashier/printBill.jsp?billId=<%= bill.billId %>" 
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
                           onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(181, 149, 216, 0.4)'; this.style.background='linear-gradient(135deg, #D1BAE8, #B595D8, #A584C7)';"
                           onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 4px rgba(181, 149, 216, 0.3)'; this.style.background='linear-gradient(135deg, #E8D5F2, #C8A8E0, #B595D8)';">
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
            if (isVisible) hasVisible = true;
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
    document.getElementById('customerSearchInput').addEventListener('input', function() {
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

</body>
</html>
