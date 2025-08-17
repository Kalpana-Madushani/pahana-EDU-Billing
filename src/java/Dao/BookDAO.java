package Dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Book;
import model.DBConnection;

public class BookDAO {

    public static void insertBook(Book book) {
        String sql = "INSERT INTO books (title, author, category, stock, publisher, year, price, imageUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getCategory());
            stmt.setInt(4, book.getStock());
            stmt.setString(5, book.getPublisher());
            stmt.setInt(6, book.getYear());
            stmt.setDouble(7, book.getPrice());
            stmt.setString(8, book.getImageUrl());

            stmt.executeUpdate();
        } catch (Exception e) {
        }
    }

    public static List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY year ASC";

        try (Connection conn = DBConnection.getInstance();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Book book = new Book(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getString("category"),
                    rs.getInt("stock"),
                    rs.getString("publisher"),
                    rs.getInt("year"),
                    rs.getDouble("price"),
                    rs.getString("imageUrl")
                );
                list.add(book);
            }
        } catch (Exception e) {
        }

        return list;
    }
    
    
    public static void updateBook(Book book) {
    String sql = "UPDATE books SET title=?, author=?, category=?, stock=?, publisher=?, year=?, price=?, imageUrl=? WHERE id=?";

    try (Connection conn = DBConnection.getInstance();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, book.getTitle());
        stmt.setString(2, book.getAuthor());
        stmt.setString(3, book.getCategory());
        stmt.setInt(4, book.getStock());
        stmt.setString(5, book.getPublisher());
        stmt.setInt(6, book.getYear());
        stmt.setDouble(7, book.getPrice());
        stmt.setString(8, book.getImageUrl());
        stmt.setInt(9, book.getId());

        stmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public static void deleteBook(int id) {
    String sql = "DELETE FROM books WHERE id = ?";

    try (Connection conn = DBConnection.getInstance();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, id);
        stmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public static Book getBookById(int id) {
    String sql = "SELECT * FROM books WHERE id = ?";
    try (Connection conn = DBConnection.getInstance();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return new Book(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("author"),
                rs.getString("category"),
                rs.getInt("stock"),
                rs.getString("publisher"),
                rs.getInt("year"),
                rs.getDouble("price"),
                rs.getString("imageUrl")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}


public static void decreaseStock(int bookId, int qty) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE books SET stock = stock - ? WHERE id = ?";
    try (Connection conn = DBConnection.getInstance();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, qty);
        ps.setInt(2, bookId);
        ps.executeUpdate();
    }
}

}
