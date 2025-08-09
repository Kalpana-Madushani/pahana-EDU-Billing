package Dao;

import model.Book;
import model.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BillDAO {

    // Create bill, bill_items, update stock. Returns bill id or -1 on error.
    // bookIds and quantities should be same length; they are strings from request.
    public static int createBill(int customerId, String[] bookIds, String[] quantities) {
        String insertBillSql = "INSERT INTO bills (customer_id, total_amount) VALUES (?, ?)";
        String insertItemSql = "INSERT INTO bill_items (bill_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement psBill = null;
        PreparedStatement psItem = null;
        try {
            conn = DBConnection.getInstance();
            conn.setAutoCommit(false);

            // 1) compute total
            double total = 0;
            List<Integer> bIds = new ArrayList<>();
            List<Integer> qtys = new ArrayList<>();
            for (int i = 0; i < bookIds.length; i++) {
                int bid = Integer.parseInt(bookIds[i]);
                int q = Integer.parseInt(quantities[i]);
                bIds.add(bid);
                qtys.add(q);

                // fetch price from books table
                String priceSql = "SELECT price, stock FROM books WHERE id = ?";
                try (PreparedStatement psPrice = conn.prepareStatement(priceSql)) {
                    psPrice.setInt(1, bid);
                    ResultSet rs = psPrice.executeQuery();
                    if (rs.next()) {
                        double price = rs.getDouble("price");
                        int stock = rs.getInt("stock");
                        if (q > stock) {
                            conn.rollback();
                            return -2; // insufficient stock
                        }
                        total += price * q;
                    } else {
                        conn.rollback();
                        return -3; // book not found
                    }
                }
            }

            // 2) insert into bills
            psBill = conn.prepareStatement(insertBillSql, Statement.RETURN_GENERATED_KEYS);
            psBill.setInt(1, customerId);
            psBill.setDouble(2, total);
            psBill.executeUpdate();
            ResultSet rsBill = psBill.getGeneratedKeys();
            int billId = -1;
            if (rsBill.next()) billId = rsBill.getInt(1);
            else { conn.rollback(); return -1; }

            // 3) insert bill items and update stock
            psItem = conn.prepareStatement(insertItemSql);
            for (int i = 0; i < bIds.size(); i++) {
                int bid = bIds.get(i);
                int q = qtys.get(i);

                // get current price
                String priceSql = "SELECT price FROM books WHERE id = ?";
                double price = 0;
                try (PreparedStatement psPrice = conn.prepareStatement(priceSql)) {
                    psPrice.setInt(1, bid);
                    ResultSet rs = psPrice.executeQuery();
                    if (rs.next()) price = rs.getDouble("price");
                }

                psItem.setInt(1, billId);
                psItem.setInt(2, bid);
                psItem.setInt(3, q);
                psItem.setDouble(4, price);
                psItem.addBatch();

                // update stock
                String updStock = "UPDATE books SET stock = stock - ? WHERE id = ?";
                try (PreparedStatement psUpd = conn.prepareStatement(updStock)) {
                    psUpd.setInt(1, q);
                    psUpd.setInt(2, bid);
                    psUpd.executeUpdate();
                }
            }
            psItem.executeBatch();

            conn.commit();
            return billId;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return -1;
        } finally {
            try { if (psBill != null) psBill.close(); } catch (Exception ignored) {}
            try { if (psItem != null) psItem.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ignored) {}
        }
    }

    // Fetch bill with items (for print view)
    public static BillData getBillDataById(int billId) {
        BillData data = new BillData();
        String billSql = "SELECT b.*, c.name, c.phone, c.email, c.address FROM bills b LEFT JOIN customers c ON b.customer_id = c.id WHERE b.id = ?";
        String itemsSql = "SELECT bi.*, bk.title FROM bill_items bi LEFT JOIN books bk ON bi.book_id = bk.id WHERE bi.bill_id = ?";
        try (Connection conn = DBConnection.getInstance();
             PreparedStatement psBill = conn.prepareStatement(billSql);
             PreparedStatement psItems = conn.prepareStatement(itemsSql)) {

            psBill.setInt(1, billId);
            ResultSet rs = psBill.executeQuery();
            if (rs.next()) {
                data.billId = rs.getInt("id");
                data.customerName = rs.getString("name");
                data.customerPhone = rs.getString("phone");
                data.total = rs.getDouble("total_amount");
                data.date = rs.getTimestamp("bill_date");
            }

            psItems.setInt(1, billId);
            ResultSet rsItems = psItems.executeQuery();
            while (rsItems.next()) {
                BillItem bi = new BillItem();
                bi.title = rsItems.getString("title");
                bi.quantity = rsItems.getInt("quantity");
                bi.price = rsItems.getDouble("price");
                data.items.add(bi);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
    
    public static List<BillData> getAllBillsSummary() {
    List<BillData> list = new ArrayList<>();
    String sql = "SELECT b.id, b.customer_id, b.total_amount, b.bill_date, c.name FROM bills b LEFT JOIN customers c ON b.customer_id = c.id ORDER BY b.bill_date DESC";
    try (Connection conn = DBConnection.getInstance();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            BillData bd = new BillData();
            bd.billId = rs.getInt("id");
            bd.customerName = rs.getString("name");
            bd.total = rs.getDouble("total_amount");
            bd.date = rs.getTimestamp("bill_date");
            list.add(bd);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


    // Helper classes
    public static class BillData {
        public int billId;
        public String customerName;
        public String customerPhone;
        public double total;
        public Timestamp date;
        public List<BillItem> items = new ArrayList<>();
    }

    public static class BillItem {
        public String title;
        public int quantity;
        public double price;
    }
}
