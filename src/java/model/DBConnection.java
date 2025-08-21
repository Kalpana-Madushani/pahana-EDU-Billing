package model;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
 
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/pahanabookshop?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";  // Put your MySQL root password here
    
 
    public static Connection getInstance() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");  // Load MySQL driver explicitly
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
 
 