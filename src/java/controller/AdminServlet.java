package controller;

import Dao.BookDAO;
import Dao.CustomerDAO;
import Dao.UserDAO;
import model.Book;
import model.Customer;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

/**
 * AdminServlet - single servlet to serve the admin dashboard and handle CRUD
 * actions URL: /admin
 *
 * Note: This servlet assumes the following DAO methods exist: - CustomerDAO:
 * insertCustomer(Customer) -> int (generated id), updateCustomer(Customer),
 * deleteCustomer(int), getAllCustomers() - UserDAO: insertUser(User),
 * updateUser(User), deleteUser(String id or int), getAllUsers() - BookDAO:
 * insertBook(Book), updateBook(Book), deleteBook(int), getAllBooks()
 *
 * If any method doesn't exist, add it in the corresponding DAO.
 */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    // Show dashboard
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // optional message parameter for feedback
        String msg = req.getParameter("msg");
        if (msg != null && !msg.isEmpty()) {
            req.setAttribute("message", msg);
        }

        // load lists
        List<Customer> customers = CustomerDAO.getAllCustomers();
        List<User> users = UserDAO.getAllUsers();
        List<Book> books = BookDAO.getAllBooks();

        req.setAttribute("customers", customers);
        req.setAttribute("users", users);
        req.setAttribute("books", books);

        // forward to JSP
        req.getRequestDispatcher("view/adminpanel/AdminDashboard.jsp").forward(req, resp);
    }

    // Handle add / edit / delete actions
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use a single "action" parameter naming scheme: entityAction, e.g. customer_add, customer_edit, customer_delete
        // but we will support simpler forms: action (like "addCustomer", "editCustomer", "deleteCustomer", etc.)
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String redirectMsg = null;

        try {
            switch (action) {
                // ----------------- CUSTOMER -----------------
                case "addCustomer": {
                    String name = req.getParameter("name");
                    String phone = req.getParameter("phone");
                    String email = req.getParameter("email");
                    String address = req.getParameter("address");

                    Customer c = new Customer(0, name, phone, email, address); // constructor: id,name,phone,email,address
                    int newId = CustomerDAO.insertCustomer(c); // must return generated id
                    if (newId > 0) {
                        redirectMsg = "Customer added";
                    } else {
                        redirectMsg = "Failed to add customer";
                    }
                    break;
                }
                case "editCustomer": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String name = req.getParameter("name");
                    String phone = req.getParameter("phone");
                    String email = req.getParameter("email");
                    String address = req.getParameter("address");

                    Customer c = new Customer(id, name, phone, email, address);
                    CustomerDAO.updateCustomer(c); // implement updateCustomer in DAO
                    redirectMsg = "Customer updated";
                    break;
                }
                case "deleteCustomer": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    CustomerDAO.deleteCustomer(id); // implement deleteCustomer in DAO
                    redirectMsg = "Customer deleted";
                    break;
                }

                // ----------------- USER -----------------
                case "addUser": {
                    System.out.println("add user");
                    String id = req.getParameter("id");
                    String username = req.getParameter("username");
                    String password = req.getParameter("password");
                    String role = req.getParameter("role");
                    String status = req.getParameter("status");

                    User u = new User();
                    u.setUsername(username);
                    u.setPassword(password);
                    u.setRole(role);
                    u.setStatus(status.toUpperCase());
                    
                     try {
                        if (id.isEmpty()) {
                            u.setId(null);
                            UserDAO.insertUser(u);
                        } else {
                            u.setId(id);
                            UserDAO.updateUser(u);
                        }
                        resp.sendRedirect(req.getContextPath() + "/admin?activeTab=usersSection");
                    } catch (Exception e) {
                        req.setAttribute("error", "Failed to add user: " + e.getMessage());
                    }

                    return;
                }

                case "deleteUser": {
                    String id = req.getParameter("id");
                    System.out.println(id);
                    UserDAO.deleteUser(id); // implement deleteUser(String id) in UserDAO
                    resp.sendRedirect(req.getContextPath() + "/admin?activeTab=usersSection");
                    return;
                }

                // ----------------- BOOK -----------------
                case "addBook": {
                    String title = req.getParameter("title");
                    String author = req.getParameter("author");
                    String category = req.getParameter("category");
                    int stock = Integer.parseInt(req.getParameter("stock"));
                    String publisher = req.getParameter("publisher");
                    int year = Integer.parseInt(req.getParameter("year"));
                    double price = Double.parseDouble(req.getParameter("price"));
                    String imageUrl = req.getParameter("imageUrl");

                    Book b = new Book(0, title, author, category, stock, publisher, year, price, imageUrl);
                    BookDAO.insertBook(b);
                    redirectMsg = "Book added";
                    break;
                }
                case "editBook": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String title = req.getParameter("title");
                    String author = req.getParameter("author");
                    String category = req.getParameter("category");
                    int stock = Integer.parseInt(req.getParameter("stock"));
                    String publisher = req.getParameter("publisher");
                    int year = Integer.parseInt(req.getParameter("year"));
                    double price = Double.parseDouble(req.getParameter("price"));
                    String imageUrl = req.getParameter("imageUrl");

                    Book b = new Book(id, title, author, category, stock, publisher, year, price, imageUrl);
                    BookDAO.updateBook(b);
                    redirectMsg = "Book updated";
                    break;
                }
                case "deleteBook": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    BookDAO.deleteBook(id);
                    redirectMsg = "Book deleted";
                    break;
                }

                default:
                    redirectMsg = "Unknown action";
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectMsg = "Server error: " + e.getMessage();
        }

        // redirect back to admin dashboard with a message (simple feedback)
        String ctx = req.getContextPath();
        resp.sendRedirect(ctx + "/admin?msg=" + java.net.URLEncoder.encode(redirectMsg == null ? "" : redirectMsg, "UTF-8"));
    }
}
