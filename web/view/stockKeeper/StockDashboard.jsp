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
    <title>Stock Keeper Dashboard</title>
    <link rel="icon" href="https://img.icons8.com/color/48/000000/books.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            display: flex;
            height: 100vh;
            overflow: hidden;
            background: #f2f6fc;
        }

        html {
            scroll-behavior: smooth;
        }

        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #2c3e50, #1a252f);
            color: white;
            padding: 30px 20px;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 40px;
        }

        .sidebar a {
            display: block;
            padding: 12px 18px;
            margin-bottom: 15px;
            border-radius: 8px;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #1abc9c;
        }

        .main {
            flex-grow: 1;
            overflow-y: auto;
            padding: 30px;
        }

        h1 {
            margin-bottom: 20px;
        }
/* Dashboard Container */
.dashboard-wrapper {
  padding: 2rem;
  background: #f4f6f8;
  font-family: 'Segoe UI', sans-serif;
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
  font-size: 1.6rem;
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


        form {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        form input {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        form button {
            padding: 12px 25px;
            background-color: #1abc9c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.3s;
        }

        form button:hover {
            background-color: #16a085;
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

        @media screen and (max-width: 768px) {
            .dashboard-cards {
                flex-direction: column;
            }

            table, thead, tbody, th, td, tr {
                display: block;
            }

            th {
                display: none;
            }

            td {
                position: relative;
                padding-left: 50%;
                border: none;
                border-bottom: 1px solid #eee;
            }

            td::before {
                content: attr(data-label);
                position: absolute;
                left: 10px;
                font-weight: bold;
                color: #999;
            }
            
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>👨🏼‍🔧 Stock Keeper Panel</h2>
    <a href="#" class="active" data-section="dashboard">📊 Dashboard</a>
    <a href="#" data-section="bookForm">➕ Add/Edit Book</a>
    <a href="#" data-section="manageBooks">📘 Manage Books</a>
    <a href="login.jsp">🚪 Logout</a>
</div>

<div class="main">
   <section id="dashboard" class="section active dashboard-wrapper">
  <h1 class="dashboard-title">📊 Dashboard Overview</h1>

  <!-- Top Stats Cards -->
  <div class="dashboard-grid">
    <div class="dashboard-card">
      <div class="card-icon">📚</div>
      <div>
        <p class="card-title">Total Books</p>
        <h2 class="card-value"><%= totalBooks %></h2>
      </div>
    </div>

    <div class="dashboard-card">
      <div class="card-icon">📦</div>
      <div>
        <p class="card-title">Total Stock</p>
        <h2 class="card-value"><%= totalStock %></h2>
      </div>
    </div>

    <div class="dashboard-card">
      <div class="card-icon">💰</div>
      <div>
        <p class="card-title">Inventory Value</p>
        <h2 class="card-value">Rs. <%= String.format("%.2f", totalValue) %></h2>
      </div>
    </div>

    <div class="dashboard-card">
      <div class="card-icon">🖊️</div>
      <div>
        <p class="card-title">Unique Authors</p>
        <h2 class="card-value"><%= uniqueAuthors %></h2>
      </div>
    </div>

    <div class="dashboard-card">
      <div class="card-icon">🏷️</div>
      <div>
        <p class="card-title">Categories</p>
        <h2 class="card-value"><%= uniqueCategories %></h2>
      </div>
    </div>

    <div class="dashboard-card">
      <div class="card-icon">📈</div>
      <div>
        <p class="card-title">Average Price</p>
        <h2 class="card-value">Rs. <%= String.format("%.2f", averagePrice) %></h2>
      </div>
    </div>
  </div>

  <!-- Low Stock Table -->
  <div class="dashboard-section">
    <h2 class="section-title">📉 Low Stock Books (Stock &lt; 5)</h2>
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
        <% for (Book b : lowStockBooks) { %>
        <tr>
          <td><%= b.getTitle() %></td>
          <td><%= b.getStock() %></td>
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
      <% for (Book b : recentBooks) { %>
      <li><span class="recent-book-icon">📘</span> <strong><%= b.getTitle() %></strong> by <em><%= b.getAuthor() %></em></li>
      <% } %>
    </ul>
    <% } else { %>
    <p class="dashboard-empty">📭 No recent books found.</p>
    <% } %>
  </div>
</section>




    <section id="bookForm" class="section">
        <h1><%= (editBook != null) ? "✏️ Edit Book" : "➕ Add New Book" %></h1>
        <form action="${pageContext.request.contextPath}/books" method="post">
            <% if (editBook != null) { %>
                <input type="hidden" name="id" value="<%= editBook.getId() %>" />
            <% } %>
            <input type="text" name="title" placeholder="Book Title" value="<%= (editBook != null) ? editBook.getTitle() : "" %>" required />
            <input type="text" name="author" placeholder="Author" value="<%= (editBook != null) ? editBook.getAuthor() : "" %>" required />
            <input type="text" name="category" placeholder="Category" value="<%= (editBook != null) ? editBook.getCategory() : "" %>" required />
            <input type="number" name="stock" placeholder="Stock Quantity" value="<%= (editBook != null) ? editBook.getStock() : "" %>" required />
            <input type="text" name="publisher" placeholder="Publisher" value="<%= (editBook != null) ? editBook.getPublisher() : "" %>" required />
            <input type="number" name="year" placeholder="Publication Year" value="<%= (editBook != null) ? editBook.getYear() : "" %>" required />
            <input type="number" step="0.01" name="price" placeholder="Price" value="<%= (editBook != null) ? editBook.getPrice() : "" %>" required />
            <input type="text" name="imageUrl" placeholder="Image URL (optional)" value="<%= (editBook != null) ? editBook.getImageUrl() : "" %>" />
            <button type="submit"><%= (editBook != null) ? "💾 Update Book" : "➕ Add Book" %></button>
        </form>
    </section>

    <section id="manageBooks" class="section">
        <h1>📘 Manage Books</h1>
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            if (books != null && !books.isEmpty()) {
        %>
        <table>
            <tr>
                <th>ID</th><th>Title</th><th>Author</th><th>Stock</th><th>Price</th><th>Image</th><th>Actions</th>
            </tr>
            <% for (Book b : books) { %>
            <tr>
                <td data-label="ID"><%= b.getId() %></td>
                <td data-label="Title"><%= b.getTitle() %></td>
                <td data-label="Author"><%= b.getAuthor() %></td>
                <td data-label="Stock"><%= b.getStock() %></td>
                <td data-label="Price">Rs. <%= b.getPrice() %></td>
                <td data-label="Image">
                    <% if (b.getImageUrl() != null && !b.getImageUrl().isEmpty()) { %>
                        <img src="<%= b.getImageUrl() %>" alt="Book Image">
                    <% } else { %>
                        <span>No image</span>
                    <% } %>
                </td>
                <td data-label="Actions" class="action-links">
                    <a href="books?action=edit&id=<%= b.getId() %>">✏️ Edit</a>
                    <a href="books?action=delete&id=<%= b.getId() %>" onclick="return confirm('Are you sure?');">🗑️ Delete</a>
                </td>
            </tr>
            <% } %>
        </table>
        <% } else { %>
            <p>No books found.</p>
        <% } %>
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
</script>

</body>
</html>
