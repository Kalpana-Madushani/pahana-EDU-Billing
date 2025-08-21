package controller;

import model.Book;
import Dao.BookDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/books")
public class BookServlet extends HttpServlet {

    // GET method: Load book list and forward to StockDashboard.jsp
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Book book = BookDAO.getBookById(id);
                req.setAttribute("editBook", book);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                BookDAO.deleteBook(id);
            }

            List<Book> books = BookDAO.getAllBooks();
            req.setAttribute("books", books);

// Calculate totals
            int totalBooks = books.size();
            int totalStock = books.stream().mapToInt(Book::getStock).sum();
            double totalValue = books.stream().mapToDouble(b -> b.getStock() * b.getPrice()).sum();

// New metrics:
            long uniqueAuthors = books.stream().map(Book::getAuthor).distinct().count();
            long uniqueCategories = books.stream().map(Book::getCategory).distinct().count();
            double averagePrice = books.stream().mapToDouble(Book::getPrice).average().orElse(0);

// Books low in stock (threshold 5)
            List<Book> lowStockBooks = books.stream().filter(b -> b.getStock() < 5).toList();

// Recently added books (assuming you have a 'createdDate' or 'id' as proxy)
            List<Book> recentBooks = books.stream()
                    .sorted((b1, b2) -> Integer.compare(b2.getId(), b1.getId())) // newest first by id
                    .limit(5)
                    .toList();

            req.setAttribute("totalBooks", totalBooks);
            req.setAttribute("totalStock", totalStock);
            req.setAttribute("totalValue", totalValue);
            req.setAttribute("uniqueAuthors", uniqueAuthors);
            req.setAttribute("uniqueCategories", uniqueCategories);
            req.setAttribute("averagePrice", averagePrice);
            req.setAttribute("lowStockBooks", lowStockBooks);
            req.setAttribute("recentBooks", recentBooks);

            req.getRequestDispatcher("view/stockKeeper/StockDashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading book list");
//            req.getRequestDispatcher("view/error.jsp").forward(req, resp);
        }
    }

    // POST method: Handle adding a new book
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String action = req.getParameter("action");

            int id = !req.getParameter("id").isEmpty() ? Integer.parseInt(req.getParameter("id")) : 0;

            switch (action) {
                case "deleteBookAction": {
                    System.out.println(action);
                    BookDAO.deleteBook(id);
                    String ctx = req.getContextPath();
                    resp.sendRedirect(ctx + "/books?activeTab=manageBooks");
                    break;
                }
                case "AddBookFromStock": {
                    System.out.println(req.getParameterMap().toString());
                    String title = req.getParameter("title");
                    String author = req.getParameter("author");
                    String category = req.getParameter("category");
                    int stock = Integer.parseInt(req.getParameter("stock"));
                    String publisher = req.getParameter("publisher");
                    int year = Integer.parseInt(req.getParameter("year"));
                    double price = Double.parseDouble(req.getParameter("price"));
                    String imageUrl = req.getParameter(id > 0 ? "editBookURL" : "bookURL");
//                    Enumeration<String> parameterNames = req.getParameterNames();
//
//                    while (parameterNames.hasMoreElements()) {
//                        System.out.println(parameterNames.nextElement());
//                    }
                    Book book = new Book(id, title, author, category, stock, publisher, year, price, imageUrl);
                    if (id > 0) {
                        BookDAO.updateBook(book);
                    } else {
                        BookDAO.insertBook(book);
                    }

                    resp.sendRedirect(req.getContextPath() + "/books?activeTab=manageBooks");
                    break;
                }

                case "AddBookFromAdmin": {
                    String title = req.getParameter("title");
                    String author = req.getParameter("author");
                    String category = req.getParameter("category");
                    int stock = Integer.parseInt(req.getParameter("stock"));
                    String publisher = req.getParameter("publisher");
                    int year = Integer.parseInt(req.getParameter("year"));
                    double price = Double.parseDouble(req.getParameter("price"));
                    String imageUrl = req.getParameter("bookURL");

                    Book book = new Book(id, title, author, category, stock, publisher, year, price, imageUrl);
                    if (id > 0) {
                        BookDAO.updateBook(book);
                    } else {
                        BookDAO.insertBook(book);
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin?activeTab=booksSection");
                    break;
                }
                default:
                    doGet(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to add book: " + e.getMessage());
            // resp.sendRedirect("view/error.jsp");
        }
    }

}
