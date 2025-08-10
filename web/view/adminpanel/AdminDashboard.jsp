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
<html>
<head>
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Hide scrollbar for Chrome, Safari and Opera */
#dashboardSection div::-webkit-scrollbar {
  height: 8px;
}
#dashboardSection div::-webkit-scrollbar-track {
  background: transparent;
}
#dashboardSection div::-webkit-scrollbar-thumb {
  background-color: rgba(37, 99, 235, 0.5);
  border-radius: 10px;
}

/* Hide scrollbar for Firefox */
#dashboardSection div {
  scrollbar-width: thin;
  scrollbar-color: rgba(37, 99, 235, 0.5) transparent;
}
    </style>
</head>
<body style="margin:0; font-family: Arial, sans-serif; background:#f4f4f4;">

<!-- Container -->
<div style="display:flex; height:100vh;">

    <!-- Sidebar -->
   <nav 
  id="sidebar" 
  role="navigation" 
  aria-label="Primary Sidebar Navigation" 
  style="
    width: 280px; 
    background: linear-gradient(180deg, #212a3e, #141c2a); 
    color: #cbd5e1; 
    display: flex; 
    flex-direction: column; 
    padding: 3rem 0; 
    font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    box-shadow: 5px 0 25px rgba(0, 0, 0, 0.8);
    user-select: none;
  "
>
  <!-- Header / Branding -->
  <div style="
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 1.5rem;
    margin-bottom: 2rem;
  ">
    <div style="font-size: 1.75rem;">📘</div>
    <h1 style="
      font-size: 1.25rem;
      font-weight: 700;
      margin-left: 0.5rem;
      color: #4f8cff;
      flex-grow: 1;
    ">Admin Panel</h1>
    
  </div>

  
  
  
  
  <!-- Navigation Links -->
  <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column;">

    <!-- Dashboard -->
    <li tabindex="0"
        onclick="showSection('dashboardSection', this)"
        onkeypress="if(event.key==='Enter'){showSection('dashboardSection', this)}"
        style="
          display: flex;
          align-items: center;
          padding: 1.2rem 2rem;
          margin: 0 1.5rem 1rem 1.5rem;
          border-radius: 12px;
          font-weight: 700;
          font-size: 1.125rem;
          color: #4f8cff;
          background-color: #1c2b54;
          box-shadow: 0 0 12px 3px rgba(79, 140, 255, 0.6);
          cursor: pointer;
          transition: all 0.3s ease;
          transform: scale(1.02);
          position: relative;
        ">
      <span style="margin-right: 1.2rem; font-size: 22px;">📊</span>
      <span>Dashboard</span>
    </li>

    <!-- Customers -->
    <li tabindex="0"
        onclick="showSection('customersSection', this)"
        onkeypress="if(event.key==='Enter'){showSection('customersSection', this)}"
        onmouseover="this.style.backgroundColor='rgba(79,140,255,0.1)'; this.style.color='#4f8cff'; this.style.boxShadow='0 0 10px rgba(79,140,255,0.3)'; this.style.transform='scale(1.03)'"
        onmouseout="if(!this.classList.contains('active')){this.style.backgroundColor='transparent'; this.style.color='#a0aec0'; this.style.boxShadow='none'; this.style.transform='scale(1)'}"
        style="
          display: flex;
          align-items: center;
          padding: 1.2rem 2rem;
          margin: 0 1.5rem 1rem 1.5rem;
          border-radius: 12px;
          font-weight: 600;
          font-size: 1.125rem;
          color: #a0aec0;
          cursor: pointer;
          transition: all 0.3s ease;
          transform: scale(1);
        ">
      <span style="margin-right: 1.2rem; font-size: 22px;">👥</span>
      <span>Customers</span>
    </li>

    <!-- Users -->
    <li tabindex="0"
        onclick="showSection('usersSection', this)"
        onkeypress="if(event.key==='Enter'){showSection('usersSection', this)}"
        onmouseover="this.style.backgroundColor='rgba(79,140,255,0.1)'; this.style.color='#4f8cff'; this.style.boxShadow='0 0 10px rgba(79,140,255,0.3)'; this.style.transform='scale(1.03)'"
        onmouseout="if(!this.classList.contains('active')){this.style.backgroundColor='transparent'; this.style.color='#a0aec0'; this.style.boxShadow='none'; this.style.transform='scale(1)'}"
        style="
          display: flex;
          align-items: center;
          padding: 1.2rem 2rem;
          margin: 0 1.5rem 1rem 1.5rem;
          border-radius: 12px;
          font-weight: 600;
          font-size: 1.125rem;
          color: #a0aec0;
          cursor: pointer;
          transition: all 0.3s ease;
          transform: scale(1);
        ">
      <span style="margin-right: 1.2rem; font-size: 22px;">🧑</span>
      <span>Users</span>
    </li>

    <!-- Books -->
    <li tabindex="0"
        onclick="showSection('booksSection', this)"
        onkeypress="if(event.key==='Enter'){showSection('booksSection', this)}"
        onmouseover="this.style.backgroundColor='rgba(79,140,255,0.1)'; this.style.color='#4f8cff'; this.style.boxShadow='0 0 10px rgba(79,140,255,0.3)'; this.style.transform='scale(1.03)'"
        onmouseout="if(!this.classList.contains('active')){this.style.backgroundColor='transparent'; this.style.color='#a0aec0'; this.style.boxShadow='none'; this.style.transform='scale(1)'}"
        style="
          display: flex;
          align-items: center;
          padding: 1.2rem 2rem;
          margin: 0 1.5rem 1rem 1.5rem;
          border-radius: 12px;
          font-weight: 600;
          font-size: 1.125rem;
          color: #a0aec0;
          cursor: pointer;
          transition: all 0.3s ease;
          transform: scale(1);
        ">
      <span style="margin-right: 1.2rem; font-size: 22px;">📚</span>
      <span>Books</span>
    </li>

  </ul>
  
    <!-- Sidebar Footer -->
  <div style="
    margin-top: auto;
    padding: 1.5rem;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    font-size: 0.875rem;
    color: #94a3b8;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  ">
    <!-- Clock -->
    <div style="display: flex; align-items: center; gap: 0.5rem;">
      <span style="font-size: 1.2rem;">🕒</span>
      <span id="sidebarClock">--:--:--</span>
    </div>

    <!-- Important Note -->
    <div style="
      background-color: rgba(255, 255, 255, 0.05);
      padding: 0.75rem;
      border-radius: 8px;
      color: #fbbf24;
      font-weight: 500;
    ">
      ⚠️ Backup your data daily!
    </div>
  </div>

</nav>



    <!-- Main content -->
    <main style="flex-grow:1; overflow-y: auto; padding: 25px 40px;">


   <section id="dashboardSection" style="
  padding: 2rem 1.5rem; 
  font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
  color: #1f2937; 
  background: #f9fafb;
  min-height: 80vh;
  max-width: 1100px;
  margin: 0 auto;
">

  <h2 style="
    font-size: 1.9rem; 
    font-weight: 700; 
    color: #2563eb; 
    margin-bottom: 1.8rem; 
    border-bottom: 2.5px solid #2563eb; 
    padding-bottom: 0.4rem; 
    letter-spacing: 0.12em;
    text-transform: uppercase;
    user-select: none;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  ">
    Dashboard Overview
  </h2>

  <!-- Summary Cards Grid -->
  <div style="
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 1.25rem;
    margin-bottom: 3rem;
  ">

    <!-- Card Base Style -->
    <%-- Reusable style string for cards --%>
    <%
      String cardStyle = "background: #fff; border-radius: 12px; box-shadow: 0 2px 6px rgba(0,0,0,0.07); padding: 1.5rem 1.25rem; text-align: center; user-select: none; transition: box-shadow 0.3s ease, transform 0.3s ease; cursor: default;";
      String cardHover = "this.style.boxShadow='0 6px 15px rgba(0,0,0,0.12)'; this.style.transform='translateY(-4px)';";
      String cardHoverOut = "this.style.boxShadow='0 2px 6px rgba(0,0,0,0.07)'; this.style.transform='translateY(0)';";
    %>

    <!-- Total Customers -->
    <div style="<%=cardStyle%>" onmouseover="<%=cardHover%>" onmouseout="<%=cardHoverOut%>">
      <h3 style="
        font-size: 1.1rem;
        font-weight: 600;
        color: #1e3a8a;
        margin-bottom: 0.4rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        Total Customers
      </h3>
      <p style="
        font-size: 2.5rem; 
        font-weight: 700; 
        color: #2563eb;
        margin: 0;
        line-height: 1;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        <%= customers != null ? customers.size() : 0 %>
      </p>
      <small style="
        color: #64748b;
        font-weight: 500;
        letter-spacing: 0.04em;
        display: block;
        margin-top: 0.3rem;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        Registered customers
      </small>
    </div>

    <!-- Total Users -->
    <div style="
      <%=cardStyle%>
      background: #0f766e;
      color: #d1fae5;
    " onmouseover="<%=cardHover%>" onmouseout="<%=cardHoverOut%>">
      <h3 style="
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 0.4rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        Total Users
      </h3>
      <p style="
        font-size: 2.5rem; 
        font-weight: 700; 
        margin: 0;
        line-height: 1;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        <%= users != null ? users.size() : 0 %>
      </p>
      <small style="
        font-weight: 500;
        letter-spacing: 0.04em;
        display: block;
        margin-top: 0.3rem;
        opacity: 0.9;
      ">
        System users
      </small>
    </div>

    <!-- Total Books -->
    <div style="
      <%=cardStyle%>
      background: #fbbf24;
      color: #78350f;
    " onmouseover="<%=cardHover%>" onmouseout="<%=cardHoverOut%>">
      <h3 style="
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 0.4rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        Total Books
      </h3>
      <p style="
        font-size: 2.5rem; 
        font-weight: 700; 
        margin: 0;
        line-height: 1;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        <%= books != null ? books.size() : 0 %>
      </p>
      <small style="
        font-weight: 500;
        letter-spacing: 0.04em;
        display: block;
        margin-top: 0.3rem;
        opacity: 0.9;
      ">
        Books in inventory
      </small>
    </div>

    <!-- Active Users -->
    <div style="
      <%=cardStyle%>
      background: #dc2626;
      color: #fee2e2;
    " onmouseover="<%=cardHover%>" onmouseout="<%=cardHoverOut%>">
      <h3 style="
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 0.4rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        Active Users
      </h3>
      <p style="
        font-size: 2.5rem; 
        font-weight: 700; 
        margin: 0;
        line-height: 1;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      ">
        <%= users != null ? users.stream().filter(u -> "active".equals(u.getStatus())).count() : 0 %>
      </p>
      <small style="
        font-weight: 500;
        letter-spacing: 0.04em;
        display: block;
        margin-top: 0.3rem;
        opacity: 0.9;
      ">
        Users currently active
      </small>
    </div>

  </div>

 <!-- Book Inventory Title -->
<h2 style="
  font-size: 1.6rem; 
  font-weight: 700; 
  color: #1e40af; 
  margin-bottom: 1.2rem; 
  letter-spacing: 0.07em;
  user-select: none;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
">
  Book Inventory
</h2>

<!-- Books Horizontal Scroll Container -->
<div style="
  display: flex;
  gap: 1.5rem;
  overflow-x: auto;
  padding-bottom: 5rem;
  max-width: 100%;
  scroll-behavior: smooth;
">
  <% if (books != null && !books.isEmpty()) {
      for (Book b : books) { %>
    <div style="
      flex: 0 0 180px;  /* fixed width so they don't shrink */
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      overflow: hidden;
      transition: box-shadow 0.3s ease, transform 0.3s ease;
      cursor: pointer;
      display: flex;
      flex-direction: column;
      user-select: none;
    "
    onmouseover="this.style.boxShadow='0 8px 20px rgba(0,0,0,0.15)'; this.style.transform='translateY(-3px)';"
    onmouseout="this.style.boxShadow='0 2px 8px rgba(0,0,0,0.08)'; this.style.transform='translateY(0)';"
    >

      <!-- Image container with fixed height -->
      <div style="width: 100%; height: 240px; overflow: hidden; border-top-left-radius: 12px; border-top-right-radius: 12px; background: #f0f4f8;">
        <%
          String imgUrl = (b.getImageUrl() != null && !b.getImageUrl().isEmpty())
                          ? b.getImageUrl()
                          : "https://via.placeholder.com/280x350?text=No+Image";
        %>
        <img src="<%= imgUrl %>" alt="<%= b.getTitle() %>" style="width: 100%; height: 100%; object-fit: cover; object-position: center; display: block;">
      </div>

      <!-- Book Info -->
      <div style="padding: 0.9rem 1rem; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between;">
        <div>
          <h3 style="
            font-size: 1.15rem;
            font-weight: 600;
            color: #1e40af;
            margin: 0 0 0.3rem 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          ">
            <%= b.getTitle() %>
          </h3>
          <p style="
            margin: 0;
            color: #475569;
            font-weight: 500;
            font-size: 0.85rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          ">
            <%= b.getAuthor() %>
          </p>
        </div>
        <div style="margin-top: 0.7rem; display: flex; justify-content: space-between; font-weight: 600; font-size: 0.9rem; color: #334155;">
          <span>Stock: <%= b.getStock() %></span>
          <span><%= String.format("%.2f", b.getPrice()) %>LKR</span>
        </div>
      </div>
    </div>
  <%  }
     } else { %>
    <p style="grid-column: 1 / -1; text-align:center; color:#6b7280; font-weight: 500;">No books found.</p>
  <% } %>
</div>




<!--  Header -->
<div style="
  text-align: center;
  padding: 1rem 1rem 1rem;
  background: linear-gradient(135deg, #4f46e5, #6366f1);
  color: white;
  border-radius: 1rem 1rem 0 0;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
">
  <h2 style="margin: 0; font-size: 2rem; font-weight: 600;">📊 Data Insights </h2>
  <p style="margin-top: 0.5rem; font-size: 1rem; color: #e0e7ff;">
    A clear view of your latest performance metrics and trends.
  </p>
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
<section id="customersSection" style="display:none; padding: 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f9fafb; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); max-width: 1000px; margin: auto;">
  <div style="position: relative; max-width: 400px; margin-bottom: 20px;">
    <input 
      type="text" 
      id="customerSearch" 
      placeholder="Search customers..." 
      oninput="filterCustomers()" 
      style="width: 100%; padding: 12px 40px 12px 14px; border-radius: 8px; border: 1.8px solid #ccc; font-size: 16px; transition: border-color 0.3s ease;"
      onfocus="this.style.borderColor='#2563eb'"
      onblur="this.style.borderColor='#ccc'"
    />
    <svg style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%);" width="20" height="20" fill="#888" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M21 21l-6-6m2.5-5.5a6 6 0 11-12 0 6 6 0 0112 0z" stroke="#888" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
  </div>

  <table id="customersTable" style="width:100%; border-collapse: separate; border-spacing: 0 10px; background: white; box-shadow: 0 2px 8px rgb(0 0 0 / 0.1); border-radius: 12px; overflow: hidden;">
    <thead style="background: #2563eb; color: white; font-weight: 600; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.3);">
      <tr>
        <th style="padding: 14px 20px; text-align: left;">ID</th>
        <th style="padding: 14px 20px; text-align: left;">Name</th>
        <th style="padding: 14px 20px; text-align: left;">Phone</th>
        <th style="padding: 14px 20px; text-align: left;">Email</th>
        <th style="padding: 14px 20px; text-align: left;">Address</th>
        <th style="padding: 14px 20px; text-align: center;">Actions</th>
      </tr>
    </thead>
    <tbody>
      <% if (customers != null) {
           for (Customer c : customers) { %>
          <tr 
            data-customer-id="<%= c.getId() %>" 
            data-name="<%= c.getName() %>" 
            data-phone="<%= c.getPhone() %>" 
            data-email="<%= c.getEmail() %>" 
            data-address="<%= c.getAddress() %>"
            style="background: #fff; transition: background-color 0.3s ease; cursor: default;"
            onmouseover="this.style.backgroundColor='#f3f4f6'"
            onmouseout="this.style.backgroundColor='#fff'"
          >
            <td style="padding: 14px 20px; border-left: 6px solid transparent;"><%= c.getId() %></td>
            <td style="padding: 14px 20px;"><%= c.getName() %></td>
            <td style="padding: 14px 20px;"><%= c.getPhone() %></td>
            <td style="padding: 14px 20px;"><%= c.getEmail() %></td>
            <td style="padding: 14px 20px;"><%= c.getAddress() %></td>
            <td style="padding: 14px 20px; text-align: center;">
              <button 
                aria-label="Edit Customer <%= c.getName() %>" 
                style="background: #2563eb; color: white; border: none; border-radius: 6px; padding: 8px 16px; margin-right: 8px; cursor: pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 2px 6px rgb(37 99 235 / 0.3); transition: background-color 0.3s ease;"
                onmouseover="this.style.backgroundColor='#1e40af'"
                onmouseout="this.style.backgroundColor='#2563eb'"
                onclick="openEditCustomerModal(this)"
              >
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M12 20h9"/></svg>
                Edit
              </button>
              <button 
                aria-label="Delete Customer <%= c.getName() %>" 
                style="background: #dc2626; color: white; border: none; border-radius: 6px; padding: 8px 16px; cursor: pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 2px 6px rgb(220 38 38 / 0.3); transition: background-color 0.3s ease;"
                onmouseover="this.style.backgroundColor='#991b1b'"
                onmouseout="this.style.backgroundColor='#dc2626'"
                onclick="confirmDelete('customer', <%= c.getId() %>)"
              >
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                Delete
              </button>
            </td>
          </tr>
      <% } } else { %>
          <tr><td colspan="6" style="text-align:center; padding:20px; font-style: italic; color: #666;">No customers found.</td></tr>
      <% } %>
    </tbody>
  </table>
</section>


        <!-- Users Section -->
<section id="usersSection" style="display:none; padding: 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 1000px; margin: auto; background: #f9fafb; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
  <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
    <h2 style="margin: 0; border-bottom: 3px solid #2563eb; padding-bottom: 8px; color: #1e40af; font-weight: 700; font-size: 1.8rem;">
      Manage Users
    </h2>
    <button 
      onclick="openModal('userModal')" 
      style="background:#16a34a; color:#fff; border:none; border-radius: 8px; padding: 10px 20px; cursor:pointer; font-weight: 600; font-size: 1rem; box-shadow: 0 4px 8px rgb(22 163 74 / 0.3); transition: background-color 0.3s ease; display: flex; align-items: center; gap: 8px;"
      onmouseover="this.style.backgroundColor='#15803d'"
      onmouseout="this.style.backgroundColor='#16a34a'"
      aria-label="Add New User"
    >
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" width="20" height="20"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      Add User
    </button>
  </div>

  <table style="width: 100%; border-collapse: separate; border-spacing: 0 12px; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgb(0 0 0 / 0.1); overflow: hidden;">
    <thead style="background:#2563eb; color:#fff; font-weight: 600; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.3);">
      <tr>
        <th style="padding: 16px 20px; text-align: left;">ID</th>
        <th style="padding: 16px 20px; text-align: left;">Username</th>
        <th style="padding: 16px 20px; text-align: left;">Role</th>
        <th style="padding: 16px 20px; text-align: left;">Status</th>
        <th style="padding: 16px 20px; text-align: left;">Created Date</th>
        <th style="padding: 16px 20px; text-align: center;">Actions</th>
      </tr>
    </thead>
    <tbody>
      <% if (users != null) {
          for (User u : users) { %>
          <tr
            data-user-id="<%= u.getId() %>"
            data-username="<%= u.getUsername() %>"
            data-role="<%= u.getRole() %>"
            data-status="<%= u.getStatus() %>"
            style="background: #fff; transition: background-color 0.3s ease; cursor: default;"
            onmouseover="this.style.backgroundColor='#f3f4f6'"
            onmouseout="this.style.backgroundColor='#fff'"
          >
            <td style="padding: 14px 20px; border-left: 6px solid transparent;"><%= u.getId() %></td>
            <td style="padding: 14px 20px;"><%= u.getUsername() %></td>
            <td style="padding: 14px 20px;"><%= u.getRole() %></td>
            <td style="padding: 14px 20px;"><%= u.getStatus() %></td>
            <td style="padding: 14px 20px;"><%= u.getCreatedDate() %></td>
            <td style="padding: 14px 20px; text-align: center;">
              <button
                aria-label="Edit User <%= u.getUsername() %>"
                style="background:#2563eb; color:#fff; border:none; border-radius: 8px; padding: 8px 16px; margin-right: 8px; cursor:pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 2px 6px rgb(37 99 235 / 0.3); transition: background-color 0.3s ease;"
                onmouseover="this.style.backgroundColor='#1e40af'"
                onmouseout="this.style.backgroundColor='#2563eb'"
                onclick="openEditUserModal(this)"
              >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" viewBox="0 0 24 24"><path d="M12 20h9"/></svg>
                Edit
              </button>
              <button
                aria-label="Delete User <%= u.getUsername() %>"
                style="background:#dc2626; color:#fff; border:none; border-radius: 8px; padding: 8px 16px; cursor:pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 2px 6px rgb(220 38 38 / 0.3); transition: background-color 0.3s ease;"
                onmouseover="this.style.backgroundColor='#991b1b'"
                onmouseout="this.style.backgroundColor='#dc2626'"
                onclick="confirmDelete('user', '<%= u.getId() %>')"
              >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                Delete
              </button>
            </td>
          </tr>
      <% } } else { %>
        <tr><td colspan="6" style="text-align:center; padding: 20px; font-style: italic; color: #666;">No users found.</td></tr>
      <% } %>
    </tbody>
  </table>
</section>


        <!-- Books Section -->
<section id="booksSection" style="display:none; padding: 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 1100px; margin: auto; background: #f9fafb; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
  <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
    <h2 style="margin: 0; border-bottom: 3px solid #2563eb; padding-bottom: 8px; color: #1e40af; font-weight: 700; font-size: 1.8rem;">
      Manage Books
    </h2>
    <button 
      onclick="openModal('bookModal')" 
      style="background:#16a34a; color:#fff; border:none; border-radius: 8px; padding: 10px 20px; cursor:pointer; font-weight: 600; font-size: 1rem; box-shadow: 0 4px 8px rgb(22 163 74 / 0.3); transition: background-color 0.3s ease; display: flex; align-items: center; gap: 8px;"
      onmouseover="this.style.backgroundColor='#15803d'"
      onmouseout="this.style.backgroundColor='#16a34a'"
      aria-label="Add New Book"
    >
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" width="20" height="20"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      Add Book
    </button>
  </div>

  <table style="width: 100%; border-collapse: separate; border-spacing: 0 12px; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgb(0 0 0 / 0.1); overflow: hidden;">
    <thead style="background:#2563eb; color:#fff; font-weight: 600; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.3);">
      <tr>
        <th style="padding: 16px 20px; text-align: left;">ID</th>
        <th style="padding: 16px 20px; text-align: left;">Title</th>
        <th style="padding: 16px 20px; text-align: left;">Author</th>
        <th style="padding: 16px 20px; text-align: left;">Category</th>
        <th style="padding: 16px 20px; text-align: left;">Stock</th>
        <th style="padding: 16px 20px; text-align: left;">Publisher</th>
        <th style="padding: 16px 20px; text-align: left;">Year</th>
        <th style="padding: 16px 20px; text-align: left;">Price</th>
        <th style="padding: 16px 20px; text-align: center;">Actions</th>
      </tr>
    </thead>
    <tbody>
      <% if (books != null) {
          for (Book b : books) { %>
          <tr
            data-book-id="<%= b.getId() %>"
            data-title="<%= b.getTitle() %>"
            data-author="<%= b.getAuthor() %>"
            data-category="<%= b.getCategory() %>"
            data-stock="<%= b.getStock() %>"
            data-publisher="<%= b.getPublisher() %>"
            data-year="<%= b.getYear() %>"
            data-price="<%= b.getPrice() %>"
            style="background: #fff; transition: background-color 0.3s ease; cursor: default;"
            onmouseover="this.style.backgroundColor='#f3f4f6'"
            onmouseout="this.style.backgroundColor='#fff'"
          >
            <td style="padding: 14px 20px; border-left: 6px solid transparent;"><%= b.getId() %></td>
            <td style="padding: 14px 20px;"><%= b.getTitle() %></td>
            <td style="padding: 14px 20px;"><%= b.getAuthor() %></td>
            <td style="padding: 14px 20px;"><%= b.getCategory() %></td>
            <td style="padding: 14px 20px;"><%= b.getStock() %></td>
            <td style="padding: 14px 20px;"><%= b.getPublisher() %></td>
            <td style="padding: 14px 20px;"><%= b.getYear() %></td>
            <td style="padding: 14px 20px;">$<%= b.getPrice() %></td>
            <td style="padding: 14px 20px; text-align: center;">
              <button
                aria-label="Edit Book <%= b.getTitle() %>"
                style="background:#2563eb; color:#fff; border:none; border-radius: 8px; padding: 8px 16px; margin-right: 8px; cursor:pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 2px 6px rgb(37 99 235 / 0.3); transition: background-color 0.3s ease;"
                onmouseover="this.style.backgroundColor='#1e40af'"
                onmouseout="this.style.backgroundColor='#2563eb'"
                onclick="openEditBookModal(this)"
              >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" viewBox="0 0 24 24"><path d="M12 20h9"/></svg>
                Edit
              </button>
              <button
                aria-label="Delete Book <%= b.getTitle() %>"
                style="background:#dc2626; color:#fff; border:none; border-radius: 8px; padding: 8px 16px; cursor:pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 2px 6px rgb(220 38 38 / 0.3); transition: background-color 0.3s ease;"
                onmouseover="this.style.backgroundColor='#991b1b'"
                onmouseout="this.style.backgroundColor='#dc2626'"
                onclick="confirmDelete('book', <%= b.getId() %>)"
              >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                Delete
              </button>
            </td>
          </tr>
      <% } } else { %>
        <tr><td colspan="9" style="text-align:center; padding: 20px; font-style: italic; color: #666;">No books found.</td></tr>
      <% } %>
    </tbody>
  </table>
</section>


    </main>

</div>

<!-- MODALS -->

<!-- Add/Edit Customer Modal -->
<div id="customerModal" class="modal" style="display:none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4);">
    <div class="modal-content" style="background-color: #fff; margin: 10% auto; padding: 20px; border-radius: 8px; width: 400px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); position: relative;">
        <span class="close" onclick="closeModal('customerModal')" style="color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
        <h2 id="customerModalTitle" style="margin-bottom: 20px; color:#2563eb;">Add Customer</h2>
        <form id="customerForm">
            <input type="hidden" id="customerId" name="id" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Name</label>
            <input type="text" id="customerName" name="name" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Phone</label>
            <input type="text" id="customerPhone" name="phone" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Email</label>
            <input type="email" id="customerEmail" name="email" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Address</label>
            <textarea id="customerAddress" name="address" rows="3" style="width:100%; padding:8px; margin-bottom: 20px; border:1px solid #ccc; border-radius:4px;"></textarea>
            <button type="submit" style="background:#2563eb; color:#fff; border:none; padding:10px 20px; border-radius: 5px; cursor:pointer; font-weight:700;">Save</button>
        </form>
    </div>
</div>

<!-- Add/Edit User Modal -->
<div id="userModal" class="modal" style="display:none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4);">
    <div class="modal-content" style="background-color: #fff; margin: 10% auto; padding: 20px; border-radius: 8px; width: 400px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); position: relative;">
        <span class="close" onclick="closeModal('userModal')" style="color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
        <h2 id="userModalTitle" style="margin-bottom: 20px; color:#2563eb;">Add User</h2>
        <form id="userForm">
            <input type="hidden" id="userId" name="id" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Username</label>
            <input type="text" id="userUsername" name="username" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Role</label>
            <select id="userRole" name="role" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;">
                <option value="">Select Role</option>
                <option value="admin">Admin</option>
                <option value="stock_keeper">Stock Keeper</option>
                <option value="cashier">Cashier</option>
            </select>
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Status</label>
            <select id="userStatus" name="status" required style="width:100%; padding:8px; margin-bottom: 20px; border:1px solid #ccc; border-radius:4px;">
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>
            <button type="submit" style="background:#2563eb; color:#fff; border:none; padding:10px 20px; border-radius: 5px; cursor:pointer; font-weight:700;">Save</button>
        </form>
    </div>
</div>

<!-- Add/Edit Book Modal -->
<div id="bookModal" class="modal" style="display:none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4);">
    <div class="modal-content" style="background-color: #fff; margin: 5% auto; padding: 20px; border-radius: 8px; width: 500px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); position: relative;">
        <span class="close" onclick="closeModal('bookModal')" style="color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
        <h2 id="bookModalTitle" style="margin-bottom: 20px; color:#2563eb;">Add Book</h2>
        <form id="bookForm">
            <input type="hidden" id="bookId" name="id" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Title</label>
            <input type="text" id="bookTitle" name="title" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Author</label>
            <input type="text" id="bookAuthor" name="author" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Category</label>
            <input type="text" id="bookCategory" name="category" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Stock</label>
            <input type="number" id="bookStock" name="stock" min="0" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Publisher</label>
            <input type="text" id="bookPublisher" name="publisher" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Year</label>
            <input type="number" id="bookYear" name="year" min="1900" max="2100" required style="width:100%; padding:8px; margin-bottom: 15px; border:1px solid #ccc; border-radius:4px;" />
            <label style="display:block; margin-bottom: 8px; font-weight:600;">Price</label>
            <input type="number" id="bookPrice" name="price" min="0" step="0.01" required style="width:100%; padding:8px; margin-bottom: 20px; border:1px solid #ccc; border-radius:4px;" />
            <button type="submit" style="background:#2563eb; color:#fff; border:none; padding:10px 20px; border-radius: 5px; cursor:pointer; font-weight:700;">Save</button>
        </form>
    </div>
</div>
<script>
// Section toggle
function showSection(sectionId, clickedElement) {
    // Hide all sections
    ['dashboardSection', 'customersSection', 'usersSection', 'booksSection'].forEach(function(id) {
        document.getElementById(id).style.display = 'none';
    });
    // Show selected section
    document.getElementById(sectionId).style.display = 'block';

    // Remove active from all nav links
    document.querySelectorAll('#sidebar .nav-link').forEach(function(el) {
        el.style.backgroundColor = '';
        el.style.color = '#d1d5db';
        el.style.fontWeight = '600';
    });

    // Set active styles on clicked link
    clickedElement.style.backgroundColor = '#2563eb';
    clickedElement.style.color = '#fff';
    clickedElement.style.fontWeight = '700';
}

// Modals open/close
function openModal(modalId) {
    document.getElementById(modalId).style.display = 'block';
}
function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// Edit modals data fill
function openEditCustomerModal(button) {
    var tr = button.closest('tr');
    document.getElementById('customerModalTitle').innerText = 'Edit Customer';
    document.getElementById('customerId').value = tr.getAttribute('data-customer-id');
    document.getElementById('customerName').value = tr.getAttribute('data-name');
    document.getElementById('customerPhone').value = tr.getAttribute('data-phone');
    document.getElementById('customerEmail').value = tr.getAttribute('data-email');
    document.getElementById('customerAddress').value = tr.getAttribute('data-address');
    openModal('customerModal');
}

function openEditUserModal(button) {
    var tr = button.closest('tr');
    document.getElementById('userModalTitle').innerText = 'Edit User';
    document.getElementById('userId').value = tr.getAttribute('data-user-id');
    document.getElementById('userUsername').value = tr.getAttribute('data-username');
    document.getElementById('userRole').value = tr.getAttribute('data-role');
    document.getElementById('userStatus').value = tr.getAttribute('data-status');
    openModal('userModal');
}

function openEditBookModal(button) {
    var tr = button.closest('tr');
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
    if(confirm('Are you sure you want to delete this '+type+'?')) {
        // Here you would submit form or call server API to delete
        alert(type + ' with ID ' + id + ' will be deleted (implement server logic)');
    }
}

// Clear modals on open add new
document.querySelectorAll('button[onclick^="openModal"]').forEach(btn => {
    btn.addEventListener('click', () => {
        if(btn.getAttribute('onclick').includes('customerModal')) {
            document.getElementById('customerModalTitle').innerText = 'Add Customer';
            document.getElementById('customerForm').reset();
            document.getElementById('customerId').value = '';
        }
        if(btn.getAttribute('onclick').includes('userModal')) {
            document.getElementById('userModalTitle').innerText = 'Add User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
        }
        if(btn.getAttribute('onclick').includes('bookModal')) {
            document.getElementById('bookModalTitle').innerText = 'Add Book';
            document.getElementById('bookForm').reset();
            document.getElementById('bookId').value = '';
        }
    });
});

// Handle customer form submit (edit or add)
document.getElementById('customerForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const id = document.getElementById('customerId').value;
    const name = document.getElementById('customerName').value.trim();
    const phone = document.getElementById('customerPhone').value.trim();
    const email = document.getElementById('customerEmail').value.trim();
    const address = document.getElementById('customerAddress').value.trim();

    if(id) {
        // Edit existing row
        let row = document.querySelector(`tr[data-customer-id="${id}"]`);
        if(row) {
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
        // Add new row (simple append, no ID generation here)
        const tbody = document.querySelector('#customersSection tbody');
        const newId = Date.now(); // temporary unique ID
        const tr = document.createElement('tr');
        tr.setAttribute('data-customer-id', newId);
        tr.setAttribute('data-name', name);
        tr.setAttribute('data-phone', phone);
        tr.setAttribute('data-email', email);
        tr.setAttribute('data-address', address);

        tr.innerHTML = `
            <td style="padding: 10px; border: 1px solid #ddd;">${newId}</td>
            <td style="padding: 10px; border: 1px solid #ddd;">${name}</td>
            <td style="padding: 10px; border: 1px solid #ddd;">${phone}</td>
            <td style="padding: 10px; border: 1px solid #ddd;">${email}</td>
            <td style="padding: 10px; border: 1px solid #ddd;">${address}</td>
            <td style="padding: 10px; border: 1px solid #ddd;">
                <button style="background:#2563eb; color:#fff; border:none; border-radius:4px; padding:6px 12px; cursor:pointer; margin-right:5px;" onclick="openEditCustomerModal(this)">Edit</button>
                <button style="background:#dc2626; color:#fff; border:none; border-radius:4px; padding:6px 12px; cursor:pointer;" onclick="confirmDelete('customer', ${newId})">Delete</button>
            </td>
        `;
        tbody.appendChild(tr);
    }

    closeModal('customerModal');
    this.reset();
});


</script>

<script>
  function showSection(sectionId, element) {
    // Hide all sections
    const allSections = document.querySelectorAll('section');
    allSections.forEach(section => section.style.display = 'none');

    // Remove 'active' class from all nav items
    const navItems = document.querySelectorAll('#sidebar ul li');
    navItems.forEach(item => {
      item.classList.remove('active');
      item.style.backgroundColor = 'transparent';
      item.style.color = '#a0aec0';
      item.style.boxShadow = 'none';
      item.style.transform = 'scale(1)';
    });

    // Show the selected section
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
      targetSection.style.display = 'block';
    }

    // Add active styling to the clicked item
    element.classList.add('active');
    element.style.backgroundColor = '#1c2b54';
    element.style.color = '#4f8cff';
    element.style.boxShadow = '0 0 12px 3px rgba(79, 140, 255, 0.6)';
    element.style.transform = 'scale(1.02)';
  }
</script>
<script>
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
    const query = document.getElementById('customerSearch').value.toLowerCase();
    const rows = document.querySelectorAll('#customersTable tbody tr');
    rows.forEach(row => {
      const name = row.dataset.name || '';
      const phone = row.dataset.phone || '';
      const email = row.dataset.email || '';
      const address = row.dataset.address || '';
      const visible = name.includes(query) || phone.includes(query) || email.includes(query) || address.includes(query);
      row.style.display = visible ? '' : 'none';
    });
  }

</script>

<script>
window.onload = () => {
  // Get data safely from JSP variables
  const dataCounts = {
    customers: <%= customers != null ? customers.size() : 0 %>,
    users: <%= users != null ? users.size() : 0 %>,
    books: <%= books != null ? books.size() : 0 %>,
    activeUsers: <%= users != null ? users.stream().filter(u -> "active".equals(u.getStatus())).count() : 0 %>
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
        legend: { display: false },
        tooltip: {
          backgroundColor: '#2563eb',
          titleFont: { weight: '700', size: 14 },
          bodyFont: { weight: '500', size: 12 },
          cornerRadius: 6,
          padding: 10
        }
      }
    }
  });
};
</script>


</body>
</html>
