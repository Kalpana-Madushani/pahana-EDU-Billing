<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PAHANA Book Shop - Loginqsq</title>
    <link rel="stylesheet" type="text/css" href="css/login-styles.css">
    <link rel="stylesheet" type="text/css" href="css/footer-styles.css">
</head>
<body>
    <div class="login-container hide-inside-footer">
        <h1 class="system-title">PAHANA Book Store Management System</h1>
        <p class="login-title">Smart Billing. Better Bookshop.</p>
        
       <% 
    String error = request.getParameter("error");
    if ("InvalidCredentials".equals(error)) {
%>
    <p style="color:red; text-align:center;">Invalid username or password.</p>
<% 
    } else if ("ServerError".equals(error)) {
%>
    <p style="color:red; text-align:center;">A server error occurred. Please try again later.</p>
<%
    }
%>

        <form action="<%=request.getContextPath()%>/logServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="un" placeholder="Enter your username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="pw" placeholder="Enter your password" required>
            </div>
            
            <div class="button-group">
<!--                <a href="register.jsp" class="btn btn-secondary">Register</a>-->
                <input type="submit" value="Login" class="btn btn-primary">
            </div>
        </form>
    </div>

    <div class="footer-outside">
        <p>© 2024 PAHANA Book Shop Management System | All Rights Reserved | Version 1.0</p>
    </div>
</body>
</html>
