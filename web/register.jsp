<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PAHANA Book Shop - Register</title>
    <link rel="stylesheet" type="text/css" href="css/login-styles.css">
    <link rel="stylesheet" type="text/css" href="css/footer-styles.css">
</head>
<body>
    <!-- Wrapper to control content and footer layout -->
    <div class="content-wrapper">
        <div class="login-container">
            <h1 class="system-title">PAHANA Book Store Management System</h1>
            <p class="login-title">Create Your Account. Join Our Community.</p>

            <!-- Show error message if present -->
            <%
                String error = request.getParameter("error");
                if ("PasswordMismatch".equals(error)) {
            %>
                <p style="color:red; text-align:center;">Passwords do not match.</p>
            <%
                } else if ("UserExists".equals(error)) {
            %>
                <p style="color:red; text-align:center;">Username already exists.</p>
            <%
                } else if ("ServerError".equals(error)) {
            %>
                <p style="color:red; text-align:center;">A server error occurred. Please try again later.</p>
            <%
                } else if ("InsertFailed".equals(error)) {
            %>
                <p style="color:red; text-align:center;">Registration failed. Please try again.</p>
            <%
                }
            %>

            <form action="logServlet" method="post">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" name="username" required>
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" name="password" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password:</label>
                    <input type="password" name="confirmPassword" required>
                </div>

                <div class="button-group">
                    <a href="login.jsp" class="btn btn-secondary">Back to Login</a>
                    <input type="submit" value="Register" class="btn btn-primary">
                </div>
            </form>
        </div>
    </div>
    
    <!-- Footer -->
    <div class="footer-outside">
        <p>© 2024 PAHANA Book Shop Management System | All Rights Reserved | Version 1.0</p>
    </div>
</body>
</html>
