package controller;

import Dao.BookDAO;
import Dao.CustomerDAO;
import Dao.BillDAO;
import Dao.BillDAO.BillData;
import model.Book;
import model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/cashier")
public class CashierServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // load books for selection
        List<Book> books = BookDAO.getAllBooks();
        req.setAttribute("books", books);

         // Load all customers
    List<Customer> customers = CustomerDAO.getAllCustomers();
    req.setAttribute("customers", customers);
    
    List<BillData> bills = BillDAO.getAllBillsSummary(); // <-- create this method in BillDAO
    req.setAttribute("bills", bills);
    
        // optionally pre-fill customer if param
        String cid = req.getParameter("customerId");
        if (cid != null) {
            try {
                int id = Integer.parseInt(cid);
                Customer c = CustomerDAO.getCustomerById(id);
                req.setAttribute("customer", c);
            } catch (Exception ignored) {}
        }

        req.getRequestDispatcher("view/cashier/CashierDashboard.jsp").forward(req, resp);
    }

    // handle customer add and bill creation
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("addCustomer".equals(action)) {
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String address = req.getParameter("address");

            int customerId = CustomerDAO.insertCustomer(new Customer(0, name, phone, email, address));
            resp.sendRedirect(req.getContextPath() + "/cashier?customerId=" + customerId);
            return;
        } else if ("createBill".equals(action)) {
            String customerIdStr = req.getParameter("customerId");
            if (customerIdStr == null || customerIdStr.isEmpty()) {
                req.setAttribute("error", "Select or add a customer first.");
                doGet(req, resp);
                return;
            }
            int customerId = Integer.parseInt(customerIdStr);

            // get arrays - note if using checkboxes, ensure arrays line up
            String[] selected = req.getParameterValues("selected"); // checkbox values are bookId
            String[] qtys = req.getParameterValues("quantity");

            if (selected == null || selected.length == 0) {
                req.setAttribute("error", "Select at least one book.");
                doGet(req, resp);
                return;
            }

            // Map quantities: we'll collect only those selected
            // Build arrays for selected book ids and their quantities
            java.util.List<String> bookIdsList = new java.util.ArrayList<>();
            java.util.List<String> quantitiesList = new java.util.ArrayList<>();

            for (int i = 0; i < selected.length; i++) {
                String bookId = selected[i];
                // find corresponding qty by naming convention: quantity_<bookId>
                String qtyParam = req.getParameter("quantity_" + bookId);
                if (qtyParam == null || qtyParam.isEmpty()) qtyParam = "1";
                bookIdsList.add(bookId);
                quantitiesList.add(qtyParam);
            }

            String[] bookIds = bookIdsList.toArray(new String[0]);
            String[] quantities = quantitiesList.toArray(new String[0]);

            int billId = BillDAO.createBill(customerId, bookIds, quantities);
            if (billId > 0) {
                resp.sendRedirect(req.getContextPath() + "/view/cashier/printBill.jsp?billId=" + billId);
            } else if (billId == -2) {
                req.setAttribute("error", "Insufficient stock for a selected book.");
                doGet(req, resp);
            } else {
                req.setAttribute("error", "Failed to create bill.");
                doGet(req, resp);
            }
        }
    }
}
