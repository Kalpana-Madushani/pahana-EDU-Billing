package model;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
 
public class DBConnection {
    private static Connection connection;
    private static final String URL = "jdbc:mysql://localhost:3306/pahanabookshop?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";
    
    private DBConnection(){
        
    }
 
    public static Connection getInstance() throws SQLException, ClassNotFoundException {
        if (connection == null || connection.isClosed()) {
            Class.forName("com.mysql.cj.jdbc.Driver");  // Load MySQL driver explicitly
            connection = DriverManager.getConnection(URL, USER, PASS);
        }
        return DriverManager.getConnection(URL, USER, PASS);
        
    }
}
 
 