<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Book editBook = (Book) request.getAttribute("editBook");
    int totalBooks = (request.getAttribute("totalBooks") != null) ? (int) request.getAttribute("totalBooks") : 0;
    int totalStock = (request.getAttribute("totalStock") != null) ? (int) request.getAttribute("totalStock") : 0;
    double totalValue = (request.getAttribute("totalValue") != null) ? (double) request.getAttribute("totalValue") : 0.0;
    long uniqueAuthors = request.getAttribute("uniqueAuthors") != null ? (long) request.getAttribute("uniqueAuthors") : 0;
    long uniqueCategories = request.getAttribute("uniqueCategories") != null ? (long) request.getAttribute("uniqueCategories") : 0;
    double averagePrice = request.getAttribute("averagePrice") != null ? (double) request.getAttribute("averagePrice") : 0.0;
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Stock Keeper Panel</title>
        <link rel="icon" href="https://img.icons8.com/color/48/000000/books.png" type="image/png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <style>
            * {
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

            html {
                scroll-behavior: smooth;
            }

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

            h1 {
                margin-bottom: 20px;
            }

            h3 {
                font-weight: 600;
                font-size: 1.25rem;
                margin-bottom: 24px;
                color: #374151;
            }
            /* Dashboard Container */
            .dashboard-wrapper {
                background-color: #f3f4f6;
                border-radius: 8px;
                padding: 32px 36px;
                margin-bottom: 32px;
                box-shadow: none;
            }

            /* Title */
            .dashboard-title {
                font-size: 2rem;
                margin-bottom: 1.5rem;
                font-weight: bold;
                color: #2c3e50;
            }

            /* Cards Layout */
            .dashboard-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 3rem;
            }

            .dashboard-card {
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(0,0,0,0.05);
                padding: 1.5rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                transition: all 0.3s ease;
            }

            .dashboard-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 28px rgba(0,0,0,0.08);
            }

            .card-icon {
                font-size: 2rem;
                color: #0984e3;
                background: #e8f0fe;
                padding: 0.75rem;
                border-radius: 12px;
            }

            .card-title {
                font-size: 0.95rem;
                color: #636e72;
                margin-bottom: 0.3rem;
            }

            .card-value {
                font-size: 0.9rem;
                color: #2d3436;
                font-weight: 600;
            }

            /* Section Titles */
            .section-title {
                font-size: 1.4rem;
                color: #2d3436;
                margin-bottom: 1rem;
                border-left: 5px solid #74b9ff;
                padding-left: 10px;
            }

            /* Table */
            .dashboard-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            .dashboard-table thead {
                background-color: #0984e3;
                color: white;
            }

            .dashboard-table th, .dashboard-table td {
                padding: 1rem;
                text-align: left;
            }

            .dashboard-table tbody tr {
                border-top: 1px solid #eee;
            }

            .dashboard-table tbody tr:hover {
                background-color: #f0f4f8;
            }

            /* Empty Messages */
            .dashboard-empty {
                padding: 1rem;
                background: #dfe6e9;
                color: #2d3436;
                border-left: 4px solid #636e72;
                border-radius: 8px;
                margin-bottom: 2rem;
            }

            /* Recently Added List */
            .recent-books-list {
                list-style: none;
                padding: 0;
                background: #fff;
                border-radius: 12px;
                padding: 1rem 1.5rem;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            .recent-books-list li {
                padding: 0.75rem 0;
                border-bottom: 1px solid #eee;
            }

            .recent-books-list li:last-child {
                border-bottom: none;
            }

            .recent-book-icon {
                margin-right: 8px;
                font-size: 1.2rem;
            }


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
            form input[type="file"],
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
            form input[type="file"]:focus,
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

            form select:focus {
                border-color: #B595D8;
                outline: none;
                background-color: #eff6ff;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            th, td {
                padding: 14px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }

            th {
                background-color: #2c3e50;
                color: white;
            }

            td img {
                width: 70px;
                height: auto;
                border-radius: 4px;
            }

            .action-links a {
                margin-right: 10px;
                text-decoration: none;
                color: #2c3e50;
                font-weight: bold;
            }

            .action-links a:hover {
                text-decoration: underline;
            }

            .section {
                display: none;
                transition: opacity 0.3s ease;
            }

            .section.active {
                display: block;
            }

            .action-btn {
                display: inline-block;
                padding: 6px 12px;
                margin: 2px;
                font-size: 14px;
                font-weight: 500;
                color: #fff;
                text-decoration: none;
                border-radius: 6px;
                transition: background 0.3s ease, transform 0.2s ease;
            }

            .edit-btn {
                background-color: #4CAF50;
            }


            .action-btn:hover {
                text-decoration: none;
            }
            .edit-btn:hover {
                background-color: #45a049;
                text-decoration: none;
                transform: scale(1.05);
            }

            .delete-btn {
                background-color: #f44336;
            }

            .delete-btn:hover {
                background-color: #d32f2f;
                text-decoration: none;
                transform: scale(1.05);
            }

            .action-btn i {
                margin-right: 5px;
            }

            @media screen and (max-width: 768px) {
                .dashboard-cards {
                    flex-direction: column;
                }

                table th, table td {
                    padding: 12px 10px;
                    font-size: 13px;
                }
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <h2 class="logo">🏠 Pahana Bookshop</h2>
            <a href="#" class="active" data-section="dashboard">📊 Dashboard</a>
            <a href="#" data-section="bookForm">➕ Add Book</a>
            <a href="#" data-section="manageBooks">📘 Manage Books</a>
            <a href="login.jsp" class="logout">🔓 Logout</a>
        </div>

        <div class="main">
            <h2 class="page-title">Stock Keeper Panel</h2>

            <!--    Dashboard section -->
            <section id="dashboard" class="section active dashboard-wrapper">
                <h3>1. Dashboard</h3>
                <!-- Top Stats Cards -->
                <div class="dashboard-grid">
                    <div class="dashboard-card">
                        <div class="card-icon">📚</div>
                        <div>
                            <p class="card-title">Total Books</p>
                            <h2 class="card-value"><%= totalBooks%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">📦</div>
                        <div>
                            <p class="card-title">Total Stock</p>
                            <h2 class="card-value"><%= totalStock%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">💰</div>
                        <div>
                            <p class="card-title">Inventory Value</p>
                            <h2 class="card-value">Rs. <%= String.format("%.2f", totalValue)%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">🖊️</div>
                        <div>
                            <p class="card-title">Unique Authors</p>
                            <h2 class="card-value"><%= uniqueAuthors%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">🏷️</div>
                        <div>
                            <p class="card-title">Categories</p>
                            <h2 class="card-value"><%= uniqueCategories%></h2>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-icon">📈</div>
                        <div>
                            <p class="card-title">Average Price</p>
                            <h2 class="card-value">Rs. <%= String.format("%.2f", averagePrice)%></h2>
                        </div>
                    </div>
                </div>

                <!-- Low Stock Table -->
                <div class="dashboard-section">
                    <h2 class="section-title"><span class="section-icon">⚠️</span> Low Stock Books (Stock &lt; 5)</h2>
                    <%
                        List<Book> lowStockBooks = (List<Book>) request.getAttribute("lowStockBooks");
                        if (lowStockBooks != null && !lowStockBooks.isEmpty()) {
                    %>
                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Stock</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Book b : lowStockBooks) {%>
                            <tr>
                                <td><%= b.getTitle()%></td>
                                <td><%= b.getStock()%></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p class="dashboard-empty">🎉 No books are low in stock!</p>
                    <% } %>
                </div>

                <!-- Recent Books -->
                <div class="dashboard-section">
                    <h2 class="section-title">🆕 Recently Added Books</h2>
                    <%
                        List<Book> recentBooks = (List<Book>) request.getAttribute("recentBooks");
                        if (recentBooks != null && !recentBooks.isEmpty()) {
                    %>
                    <ul class="recent-books-list">
                        <% for (Book b : recentBooks) {%>
                        <li><span class="recent-book-icon">📘</span> <strong><%= b.getTitle()%></strong> by <em><%= b.getAuthor()%></em></li>
                            <% } %>
                    </ul>
                    <% } else { %>
                    <p class="dashboard-empty">📭 No recent books found.</p>
                    <% }%>
                </div>
            </section>
                

            <!--Add book section-->
            <section id="bookForm" class="section dashboard-wrapper">
                <h3>2. <%= (editBook != null) ? "Edit Book" : "Add New Book"%></h3>
                <form action="${pageContext.request.contextPath}/books" method="post">
                    <% if (editBook != null) {%>
                    <input type="hidden" name="id" value="<%= editBook.getId()%>" />
                    <% }%>
                    <label for="book_title">Book Title *</label>
                    <input type="text" name="title" placeholder="e.g., The Great Gatsby" value="<%= (editBook != null) ? editBook.getTitle() : ""%>" required />
                    <label for="author">Author *</label>
                    <input type="text" name="author" placeholder="e.g., F. Scott Fitzgerald" value="<%= (editBook != null) ? editBook.getAuthor() : ""%>" required />
                    <label for="category">Category *</label>
                    <input type="text" name="category" placeholder="Category" value="<%= (editBook != null) ? editBook.getCategory() : ""%>" required />
                    <label for="stock_quantity">Stock Quantity *</label>
                    <input type="number" name="stock" placeholder="e.g., 25" value="<%= (editBook != null) ? editBook.getStock() : ""%>" required />
                    <label for="publisher">Publisher *</label>
                    <input type="text" name="publisher" placeholder="e.g., Penguin Books" value="<%= (editBook != null) ? editBook.getPublisher() : ""%>" required />
                    <label for="publication_year">Publication Year *</label>
                    <input type="number" name="year" placeholder="e.g., 2024" value="<%= (editBook != null) ? editBook.getYear() : ""%>" required />
                    <label for="price">Price *</label>
                    <input type="number" step="0.01" name="price" placeholder="e.g., 1250.00" value="<%= (editBook != null) ? editBook.getPrice() : ""%>" required />
                    <label for="image">Book Cover Image *</label>
                    <input type="text" name="imageUrl" placeholder="Image URL (optional)" value="<%= (editBook != null) ? editBook.getImageUrl() : ""%>" />

                    <button type="submit"><%= (editBook != null) ? "Update Book" : "Add Book"%></button>
                </form>
            </section>

            <!--        Manage book section-->
            <section id="manageBooks" class="section dashboard-wrapper">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <h3>3. Manage Books</h3>
                    <div style="position: relative; min-width: 400px;">
                        <input 
                            type="text" 
                            id="bookSearch" 
                            placeholder="Search books by title or author..." 
                            oninput="filterBooks()"
                            style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1px solid #E8D5F2; font-size: 16px; transition: border-color 0.3s ease, outline 0.3s ease; outline: none;"
                            onfocus="this.style.borderColor = '#E8D5F2';"
                            onblur="this.style.borderColor = '#E8D5F2';"
                            />
                    </div>
                </div>

                <%
                    List<Book> books = (List<Book>) request.getAttribute("books");
                    if (books != null && !books.isEmpty()) {
                %>

                <table id="booksTable">
                    <thead>
                        <tr>
                            <th>ID</th><th>Title</th><th>Author</th><th>Stock</th><th>Price</th><th>Image</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Book b : books) {%>
                        <tr data-title="<%= b.getTitle() != null ? b.getTitle().replace("\"", "&quot;") : ""%>" 
                            data-author="<%= b.getAuthor() != null ? b.getAuthor().replace("\"", "&quot;") : ""%>">
                            <td data-label="ID"><%= b.getId()%></td>
                            <td data-label="Title"><%= b.getTitle()%></td>
                            <td data-label="Author"><%= b.getAuthor()%></td>
                            <td data-label="Stock"><%= b.getStock()%></td>
                            <td data-label="Price">Rs. <%= b.getPrice()%></td>
                            <td data-label="Image">
                                <% if (b.getImageUrl() != null && !b.getImageUrl().isEmpty()) {%>
                                <img src="<%= b.getImageUrl()%>" alt="Book Image">
                                <% } else { %>
                                <span>No image</span>
                                <% }%>
                            </td>
                            <td data-label="Actions" class="action-links">
                                <a href="books?action=edit&id=<%= b.getId()%>" class="action-btn edit-btn">
                                    ✏️ Edit
                                </a>
                                <a href="books?action=delete&id=<%= b.getId()%>" 
                                   class="action-btn delete-btn" 
                                   onclick="return confirm('Are you sure?');">
                                    🗑️ Delete
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p>No books found.</p>
                <% }%>
            </section>
        </div>

        <script>
            const sidebarLinks = document.querySelectorAll('.sidebar a[data-section]');
            const sections = document.querySelectorAll('.section');

            sidebarLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const targetId = link.getAttribute('data-section');

                    // Remove active class from all
                    sidebarLinks.forEach(l => l.classList.remove('active'));
                    sections.forEach(sec => sec.classList.remove('active'));

                    // Activate current
                    link.classList.add('active');
                    document.getElementById(targetId).classList.add('active');
                });
            });

            function filterBooks() {
                const query = document.getElementById('bookSearch').value.toLowerCase();
                const rows = document.querySelectorAll('#booksTable tbody tr');
                rows.forEach(row => {
                    const title = row.dataset.title || '';
                    const author = row.dataset.author || '';
                    const visible = title.toLowerCase().includes(query) || author.toLowerCase().includes(query);
                    row.style.display = visible ? '' : 'none';
                });
            }
        </script>
    </body>
</html>
