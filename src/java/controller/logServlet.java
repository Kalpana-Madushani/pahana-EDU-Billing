package controller;

import model.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/logServlet")
public class logServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action"); // login or register

        if ("register".equalsIgnoreCase(action)) {
            handleRegistration(request, response);
        } else {
            handleLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("un");
        String password = request.getParameter("pw");

        try (Connection con = DBConnection.getInstance()) {
            String sql = "SELECT role FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                // Redirect based on role
                switch (role.toLowerCase()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/admin");
                        break;
                    case "stock_keeper":
                        response.sendRedirect(request.getContextPath() + "/books");
                        break;
                    case "cashier":
                        response.sendRedirect(request.getContextPath() + "/cashier");
                        break;
                    default:
                        response.sendRedirect("login.jsp?error=InvalidCredentials");
                }

            } else {
                response.sendRedirect("login.jsp?error=InvalidCredentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=ServerError");
        }
    }
    
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    if (!password.equals(confirmPassword)) {
        response.sendRedirect("register.jsp?error=PasswordMismatch");
        return;
    }

    try (Connection con = DBConnection.getInstance()) {
        // Check if username already exists
        String checkSql = "SELECT id FROM users WHERE username = ?";
        PreparedStatement checkStmt = con.prepareStatement(checkSql);
        checkStmt.setString(1, username);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            response.sendRedirect("register.jsp?error=UserExists");
            return;
        }

        // Insert user without specifying id (let AUTO_INCREMENT handle it)
        String sql = "INSERT INTO users (username, password, role, status, created_date) VALUES (?, ?, ?, ?, NOW())";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);  // TODO: hash the password
        ps.setString(3, "admin");
        ps.setString(4, "ACTIVE");

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("login.jsp?message=RegisteredSuccessfully");
        } else {
            response.sendRedirect("register.jsp?error=InsertFailed");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?error=ServerError");
    }
}


    


}
